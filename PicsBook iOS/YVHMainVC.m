//
//  YVHMainVC.m
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 07/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHMainVC.h"
#import "YVHCameraVC.h"
#import "RXCustomTabBar.h"
#import "YVHDAO.h"
#import "Pic.h"
#import "Face.h"
#import "YVHUtil.h"

@interface YVHMainVC ()

@end

@implementation YVHMainVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    BOOL initialPicsCharged = [[NSUserDefaults standardUserDefaults] boolForKey:@"initialPicsCharged"];
    if(!initialPicsCharged){
        [self chargeInitialPics];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"initialPicsCharged"];
        [[NSUserDefaults standardUserDefaults] synchronize];


    //Delay for get initial picsInverse geocoding
    [NSTimer scheduledTimerWithTimeInterval:.5
                                     target:self
                                   selector:@selector(presentVC)
                                   userInfo:nil
                                    repeats:NO];
    }
    else{
        [self presentVC];
    }
}
-(void)presentVC{
    UIViewController *vc1 =  [self.storyboard instantiateViewControllerWithIdentifier:@"YVHGalleryVC"];
    
    UIViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    
    UIViewController *vc3 = [[YVHCameraVC alloc]init];
    
    
    RXCustomTabBar *tabBarController = [[RXCustomTabBar alloc]init];
    
    [tabBarController setViewControllers:@[vc1, vc2, vc3]];
    [self presentViewController:tabBarController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MainVC memory warning");
}

-(void)chargeInitialPics{
    Pic *pic1, *pic2, *pic3, *pic4, *pic5, *pic6;
    UIImage * img;
    
    pic1 =  [Pic insertInManagedObjectContext:[YVHDAO getContext]];
    pic2 =  [Pic insertInManagedObjectContext:[YVHDAO getContext]];
    pic3 =  [Pic insertInManagedObjectContext:[YVHDAO getContext]];
    pic4 =  [Pic insertInManagedObjectContext:[YVHDAO getContext]];
    pic5 =  [Pic insertInManagedObjectContext:[YVHDAO getContext]];
    pic6 =  [Pic insertInManagedObjectContext:[YVHDAO getContext]];
    
    //Foto1
    img = [UIImage imageNamed:@"Foto1.jpg"];
    pic1.latitude = [NSNumber numberWithDouble:43.15094166666667];
    pic1.longitude = [NSNumber numberWithDouble:-3.776036111111111];
    pic1.name = @"Cabaña pasiega";
    pic1 = [self saveImage:img currentPic:pic1];
    CLLocation * selectedLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[pic1.latitude doubleValue]
                                                               longitude:(CLLocationDegrees)[pic1.longitude doubleValue]];
    pic1 = [[YVHUtil getInstance] getReverseGeocodeLocation:selectedLocation forPic:pic1];
    
    //Foto2
    img = [UIImage imageNamed:@"Foto2.jpg"];
 //   pic2.latitude = [NSNumber numberWithDouble:40.81551388888889];
 //   pic2.longitude = [NSNumber numberWithDouble:-3.8320388888888886];
    pic2.latitude = [NSNumber numberWithDouble:40.828213];
    pic2.longitude = [NSNumber numberWithDouble:-3.831705]; 
    pic2.name = @"Cuerda larga";
    pic2 = [self saveImage:img currentPic:pic2];
    selectedLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[pic2.latitude doubleValue]
                                                  longitude:(CLLocationDegrees)[pic2.longitude doubleValue]];
    pic2 = [[YVHUtil getInstance] getReverseGeocodeLocation:selectedLocation forPic:pic2];
    
    //Foto3
    img = [UIImage imageNamed:@"Foto3.jpg"];
    pic3.latitude = [NSNumber numberWithDouble:36.31910277777778];
    pic3.longitude = [NSNumber numberWithDouble:-5.453113888888889];
    pic3.name = @"Castillo de Castellar";
    pic3 = [self saveImage:img currentPic:pic3];
    selectedLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[pic3.latitude doubleValue]
                                                  longitude:(CLLocationDegrees)[pic3.longitude doubleValue]];
    pic3 = [[YVHUtil getInstance] getReverseGeocodeLocation:selectedLocation forPic:pic3];
    
    //Foto4
    img = [UIImage imageNamed:@"Foto4.jpg"];
    pic4.name = @"Parque de la Paloma";
    pic4.latitude = [NSNumber numberWithDouble:40.379080555555554];
    pic4.longitude = [NSNumber numberWithDouble:-3.714055555555556];
    pic4 = [self saveImage:img currentPic:pic4];
    selectedLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[pic4.latitude doubleValue]
                                                               longitude:(CLLocationDegrees)[pic4.longitude doubleValue]];
    
    pic4 = [[YVHUtil getInstance] getReverseGeocodeLocation:selectedLocation forPic:pic4];
    
    //Foto5
    img = [UIImage imageNamed:@"Kardashians.jpg"];
    pic5.name = @"Kardashians";
    pic5.latitude = [NSNumber numberWithDouble:40.554064];
    pic5.longitude = [NSNumber numberWithDouble:-3.899602];
    pic5 = [self saveImage:img currentPic:pic5];
    selectedLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[pic5.latitude doubleValue]
                                                  longitude:(CLLocationDegrees)[pic5.longitude doubleValue]];
    
    pic5 = [[YVHUtil getInstance] getReverseGeocodeLocation:selectedLocation forPic:pic5];
    //Search for faces in new filtered image
    NSArray * facesRect = [[YVHUtil getInstance] faceDetectInImage:img];
    
    //Añadimos a Core data
    for(NSString * s in facesRect){
        Face * faceRect = [Face  insertInManagedObjectContext:[YVHDAO getContext]];
        faceRect.nsrectstring = s;
        [pic5 addPic_faceObject:faceRect];
    }
    
    
    //Foto6
    img = [UIImage imageNamed:@"naomi.jpg"];
    pic6.name = @"naomi";
    pic6.latitude = [NSNumber numberWithDouble:40.417935];
    pic6.longitude = [NSNumber numberWithDouble:-3.713629];
    pic6 = [self saveImage:img currentPic:pic6];
    selectedLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[pic6.latitude doubleValue]
                                                  longitude:(CLLocationDegrees)[pic6.longitude doubleValue]];
    
    pic6 = [[YVHUtil getInstance] getReverseGeocodeLocation:selectedLocation forPic:pic6];
    //Search for faces in new filtered image
    facesRect = [[YVHUtil getInstance] faceDetectInImage:img];
    
    //Añadimos a Core data
    for(NSString * s in facesRect){
        Face * faceRect = [Face  insertInManagedObjectContext:[YVHDAO getContext]];
        faceRect.nsrectstring = s;
        [pic6 addPic_faceObject:faceRect];
    }
    [YVHDAO saveContext];
    
}

-(Pic*)saveImage:(UIImage*)image currentPic:(Pic*)currentPic{
    
    NSString *hDir = NSHomeDirectory();
    NSString *tmpDir = [hDir stringByAppendingString:@"/Documents"];
    NSString *fileName = currentPic.name;
    NSString *filePath = [tmpDir stringByAppendingPathComponent:fileName];
    
    NSLog(@"Created %@", filePath);
    
    if([UIImageJPEGRepresentation(image, 1) writeToFile:filePath atomically:YES]){
        //Insertamos en CoreData
        currentPic.path = filePath;
    }else currentPic.name = nil;
    
    //Creamos y guardamos una reducida
    UIImage *small = [self getThumbnail:image];
    [[YVHUtil getInstance ] saveTumbnail:small fileName:fileName];
    return currentPic;
}

-(UIImage *)getThumbnail:(UIImage*)originalImage{
    
    CGSize destinationSize = [self reducePic:originalImage.size];
    
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(CGSize)reducePic:(CGSize)sz{
    int w, h, ws, hs ;
    w = sz.width;
    h = sz.height;
    if(w > h ){
        ws = 200;
        hs = h*ws/w;
    }
    else{
        hs = 200;
        ws = w*hs/h;
    }
    
    return CGSizeMake(ws, hs);
    
}

@end
