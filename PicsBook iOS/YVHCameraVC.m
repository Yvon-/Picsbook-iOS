//
//  YVHCameraVC.m
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 30/09/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHCameraVC.h"
#import "Pic.h"
#import "Face.h"
#import "RXCustomTabBar.h"
#import "YVHDAO.h"
#import "YVHUtil.h"

@interface YVHCameraVC ()

@property (nonatomic, strong) NSUserDefaults *defaults;

//Gps
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;

@property (nonatomic) NSMutableArray *capturedImages;

//Current Pic
@property(strong, nonatomic) Pic * currentPic;

@end

@implementation YVHCameraVC 

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.capturedImages = [[NSMutableArray alloc] init];
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    //Location manager settings
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    
    //Coredata Stack access
    self.managedObjectContext = [YVHDAO getContext];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self toCamera];
}
-(void) viewWillDisappear:(BOOL)animated{
  //  [[YVHCoreDataStack getInstance] saveContext];//Guardamos en CD
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"CameraVC memory warning");
}


- (void)toCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}


#pragma mark -
#pragma mark - ImagePicker

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.capturedImages addObject:image];
    [self finishAndUpdate];
    [[RXCustomTabBar getInstance] toLastTab];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [[RXCustomTabBar getInstance] toLastTab];
    
}

#pragma mark -  Camera auxiliar methods

- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            self.currentPic =  [Pic insertInManagedObjectContext:self.managedObjectContext];
            // Camera took a single picture.
            UIImage *originalPhoto = [self.capturedImages objectAtIndex:0];
            
            //Guardamos foto en disco. Crea y guarda un thumbnail
            self.currentPic = [[YVHUtil getInstance] saveImage:originalPhoto currentPic:self.currentPic isNewImage:YES withName:nil];
            
            //Localizamos
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                [self getGeoPos];
                
                //                [self showData]; //Muestra datos en el view
            });
            
            //Detectamos caras
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                NSArray * facesRect = [[YVHUtil getInstance] faceDetectInImage:originalPhoto];
                
                //Añadimos a Core data
                for(NSString * s in facesRect){
                    Face * faceRect = [Face  insertInManagedObjectContext:self.managedObjectContext];
                    faceRect.nsrectstring = s;
                    [self.currentPic addPic_faceObject:faceRect];
                }
            });
            
      
            
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            //            self.imageView.animationImages = self.capturedImages;
            //            self.imageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            //            self.imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            //            [self.imageView startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }
     [YVHDAO saveContext];//Guardamos en CD
    
}



//-(void)showData{
//    _picname.text = _currentPic.name;
//    _picPath.text = _currentPic.path;
//    _piclong.text = [_currentPic.longitude stringValue];
//    _piclat.text = [_currentPic.latitude stringValue];
//}



- (IBAction)showAlbumPics:(id)sender {
    NSArray * array = [self getPics:nil];
    if (array == nil)
    {
        NSLog(@"No hay datos");
    }
    else{
        NSString *text=@"";
        for(Pic *a in array){
            NSString * s1 = [NSString stringWithFormat:@"%@ - %@ - %@\n",a.name, a.longitude, a.latitude];
            text = [text stringByAppendingString:s1];
        }
//        self.piclist.text = text;
    }
    
}
-(NSArray*)getPics:(NSPredicate*)pred{
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Pic" inManagedObjectContext:_managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    if(pred)request.predicate = pred;
    
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"No hay datos");
    }
    return array;
}

- (void)deletePic:(NSManagedObject*)p{
    [_managedObjectContext deleteObject:p];
}

-(IBAction)deleteAll:(id)sender{
    NSArray *pics = [self getPics:nil];
    for(Pic * p in pics) [self deletePic:p];
}




#pragma mark -
#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 newLocation.coordinate.latitude];
    
    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.6f",
                                  newLocation.coordinate.longitude];
    
    self.currentPic.latitude = [NSNumber numberWithFloat:[currentLatitude floatValue]];
    self.currentPic.longitude = [NSNumber numberWithFloat:[currentLongitude floatValue]];
    
    
    
//    self.piclong.text = currentLongitude;
//    self.piclat.text = currentLatitude;
    
    [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    NSLog(@"Location manager fails");
}

-(void)getGeoPos{
    
    
    [_locationManager startUpdatingLocation];
    
    //    CLLocationManager *gestorLocalizacion = [[CLLocationManager alloc] init];
    //    [gestorLocalizacion setDistanceFilter:10];
    //    [gestorLocalizacion setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    //    [gestorLocalizacion setDelegate:self];
    //    [gestorLocalizacion startUpdatingLocation];
    
    
}

@end
