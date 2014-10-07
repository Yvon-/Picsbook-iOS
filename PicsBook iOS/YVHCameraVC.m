//
//  YVHCameraVC.m
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 30/09/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHCameraVC.h"
#import "Pic.h"
#import "RXCustomTabBar.h"
#import "YVHCoreDataStack.h"

@interface YVHCameraVC ()

@property (nonatomic, strong) NSUserDefaults *defaults;

//Gps
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
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
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    
    //Coredata Stack access
    self.managedObjectContext = [[YVHCoreDataStack getInstance] managedObjectContext];
    
    
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

- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            _currentPic =  [Pic insertInManagedObjectContext:self.managedObjectContext];
            // Camera took a single picture.
            [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
            
            UIImage *originalPhoto = [self.capturedImages objectAtIndex:0];

            
            //Guardamos foto en disco
            [self saveImage:originalPhoto withName:nil];
            
            //Detectamos caras
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                [self faceDetectInImage:originalPhoto];
            });
            
            //Localizamos
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                [self getGeoPos];
                
//                [self showData]; //Muestra datos en el view
            });
            
            
            self.imageView.image = originalPhoto;
            
            
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
     [[YVHCoreDataStack getInstance] saveContext];//Guardamos en CD
    
}

//-(void)showData{
//    _picname.text = _currentPic.name;
//    _picPath.text = _currentPic.path;
//    _piclong.text = [_currentPic.longitude stringValue];
//    _piclat.text = [_currentPic.latitude stringValue];
//}

-(void)saveImage:(UIImage*)image withName:(NSString *)name{
    
    NSNumber * nPics = [self.defaults objectForKey:@"totalPicsDone"];
    if(nPics) nPics = @(nPics.intValue+1);
    else nPics = @1;
    
    //    NSString *tmpDir = NSTemporaryDirectory();
    NSString *hDir = NSHomeDirectory();
    NSString *tmpDir = [hDir stringByAppendingString:@"/Documents"];
    NSString *tmpFileName = [@"pic" stringByAppendingString:[nPics stringValue]];
    NSString *tmpFilePath= [tmpDir stringByAppendingPathComponent:tmpFileName];
    
    NSLog(@"Created %@", tmpFilePath);
    
    [self.defaults setObject:nPics forKey:@"totalPicsDone"];
    //self.picname.text = tmpFileName;
    

    if([UIImageJPEGRepresentation(image, 1) writeToFile:tmpFilePath atomically:YES]){
        //Insertamos en CoreData
        self.currentPic.name = tmpFileName;
        self.currentPic.path = tmpFilePath;
    }else self.currentPic.name = nil;
    
    
}

-(void)faceDetectInImage:(UIImage*)image{
    
    //    UIImage *careto = [UIImage imageNamed:@"2014-08-28 19.00.58.jpg"];
    int exifOrientation = 0;
    
    
    switch (image.imageOrientation) {
        case UIImageOrientationUp:
            exifOrientation = 1;
            break;
        case UIImageOrientationDown:
            exifOrientation = 3;
            break;
        case UIImageOrientationLeft:
            exifOrientation = 8;
            break;
        case UIImageOrientationRight:
            exifOrientation = 6;
            break;
        case UIImageOrientationUpMirrored:
            exifOrientation = 2;
            break;
        case UIImageOrientationDownMirrored:
            exifOrientation = 4;
            break;
        case UIImageOrientationLeftMirrored:
            exifOrientation = 5;
            break;
        case UIImageOrientationRightMirrored:
            exifOrientation = 7;
            break;
        default:
            break;
    }
    
    
    //    if (!context) {
    CIContext *  context = [CIContext contextWithOptions:nil];
    //    }
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    
    
    CIDetector *face = [CIDetector detectorOfType:CIDetectorTypeFace
                                          context:context
                                          options:opts];
    CIImage * myImage = [[CIImage alloc] initWithImage:image];
    
    NSArray *features = [face featuresInImage:myImage
                                      options:@{ CIDetectorImageOrientation: [NSNumber numberWithInt:exifOrientation]}];

    for (CIFaceFeature *f in features)
    {
        if (f.hasLeftEyePosition)
            NSLog(@" ojos en %f, %f", f.leftEyePosition.x,
                  f.leftEyePosition.y  );
        if (f.hasRightEyePosition) NSLog(@"Tiene ojo derecho");
        if (f.hasMouthPosition) NSLog(@"Tiene boca");
    }
}


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

-(void)getGeoPos{
    
    
    [_locationManager startUpdatingLocation];
    
    //    CLLocationManager *gestorLocalizacion = [[CLLocationManager alloc] init];
    //    [gestorLocalizacion setDistanceFilter:10];
    //    [gestorLocalizacion setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    //    [gestorLocalizacion setDelegate:self];
    //    [gestorLocalizacion startUpdatingLocation];
    
    
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

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


@end
