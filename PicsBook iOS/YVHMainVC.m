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

@interface YVHMainVC ()

@end

@implementation YVHMainVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    
    BOOL initialPicsCharged = [[NSUserDefaults standardUserDefaults] boolForKey:@"initialPicsCharged"];
    if(!initialPicsCharged){
        [self chargeInitialPics];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"initialPicsCharged"];
    }
    
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
    Pic *pic1, *pic2, *pic3, *pic4;
    UIImage * img;
    
    pic1 =  [Pic insertInManagedObjectContext:[YVHDAO getContext]];
    pic2 =  [Pic insertInManagedObjectContext:[YVHDAO getContext]];
    pic3 =  [Pic insertInManagedObjectContext:[YVHDAO getContext]];
    pic4 =  [Pic insertInManagedObjectContext:[YVHDAO getContext]];
    
    
    //Foto1
    img = [UIImage imageNamed:@"Foto1.jpg"];
    pic1.name = @"Cabaña pasiega";
    pic1.latitude = [NSNumber numberWithDouble:43.15094166666667];
    pic1.longitude = [NSNumber numberWithDouble:-3.776036111111111];
    pic1.path = [self saveImageToDisk:img]; //Copiar en /Documents
    //Creamos y guardamos una reducida
    [self saveTumbnail:[self getThumbnail:img]];
    
    //Foto2
    img = [UIImage imageNamed:@"Foto2.jpg"];
    pic2.name = @"Cuerda larga";
    pic2.latitude = [NSNumber numberWithDouble:40.81551388888889];
    pic2.longitude = [NSNumber numberWithDouble:-3.8320388888888886];
    pic2.path = [self saveImageToDisk:img]; //Copiar en /Documents
    //Creamos y guardamos una reducida
    [self saveTumbnail:[self getThumbnail:img]];
    
    //Foto3
    img = [UIImage imageNamed:@"Foto3.jpg"];
    pic3.name = @"Castillar";
    pic3.latitude = [NSNumber numberWithDouble:36.31910277777778];
    pic3.longitude = [NSNumber numberWithDouble:-5.453113888888889];
    pic3.path = [self saveImageToDisk:img]; //Copiar en /Documents
    //Creamos y guardamos una reducida
    [self saveTumbnail:[self getThumbnail:img]];
    
    //Foto4
    img = [UIImage imageNamed:@"Foto4.jpg"];
    pic4.name = @"Parque de la Paloma";
    pic4.latitude = [NSNumber numberWithDouble:40.379080555555554];
    pic4.longitude = [NSNumber numberWithDouble:-3.714055555555556];
    pic4.path = [self saveImageToDisk:img]; //Copiar en /Documents
    //Creamos y guardamos una reducida
    [self saveTumbnail:[self getThumbnail:img]];
}

-(NSString*)saveImageToDisk:(UIImage*)image{
    
    NSNumber * nPics = [[NSUserDefaults standardUserDefaults] objectForKey:@"totalPicsDone"];
    if(nPics) nPics = @(nPics.intValue+1);
    else nPics = @1;
    
    //    NSString *tmpDir = NSTemporaryDirectory();
    NSString *hDir = NSHomeDirectory();
    NSString *tmpDir = [hDir stringByAppendingString:@"/Documents"];
    NSString *tmpFileName = [@"pic" stringByAppendingString:[nPics stringValue]];
    NSString *tmpFilePath= [tmpDir stringByAppendingPathComponent:tmpFileName];
    
    NSLog(@"Created %@", tmpFilePath);
    
    [[NSUserDefaults standardUserDefaults]setObject:nPics forKey:@"totalPicsDone"];
    //self.picname.text = tmpFileName;
    
    [UIImageJPEGRepresentation(image, 1) writeToFile:tmpFilePath atomically:YES];
    return tmpFilePath;
}

-(void)saveTumbnail:(UIImage*)image{
    
    NSNumber * nPics = [[NSUserDefaults standardUserDefaults] objectForKey:@"totalPicsDone"];
    if(nPics) nPics = @(nPics.intValue);
    else nPics = @1;
    
    //    NSString *tmpDir = NSTemporaryDirectory();
    NSString *hDir = NSHomeDirectory();
    NSString *tmpDir = [hDir stringByAppendingString:@"/Documents"];
    NSString *tmpFileName = [[@"pic" stringByAppendingString:[nPics stringValue]]stringByAppendingString:@"_s"];
    NSString *tmpFilePath= [tmpDir stringByAppendingPathComponent:tmpFileName];
    
    // NSLog(@"Created %@", tmpFilePath);
    
    
    [UIImageJPEGRepresentation(image, 1) writeToFile:tmpFilePath atomically:YES];
    
    
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
