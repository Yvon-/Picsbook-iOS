//
//  YVHUtil.m
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 16/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHUtil.h"
#import "Pic.h"
#import "YVHCoreDataStack.h"


@interface YVHUtil ()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation YVHUtil



static YVHUtil* _shared = nil;


+(YVHUtil*)getInstance
{
    @synchronized([YVHUtil class])
    {
        if (!_shared)
        {
            _shared = [[self alloc]init];
        }
        return _shared;
    }
    return nil;
    
}


+(id)alloc
{
    @synchronized([self class])
    {
        NSAssert(_shared == nil, @"Attempted to allocate a second instance of a singleton.");
        
        _shared = [super alloc];
        
        return _shared;
    }
    
    return nil;
}


-(Pic *)saveImage:(UIImage*)image currentPic:(Pic*)currentPic isNewImage:(BOOL)isNewImage withName:(NSString*)name{
    
    NSString *fileName;
    NSString *filePath;
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    if (isNewImage) {
        
        NSString *hDir = NSHomeDirectory();
        NSString *tmpDir = [hDir stringByAppendingString:@"/Documents"];
        if (name) {
            fileName = name;
        }
        else{
            NSNumber * nPics = [self.defaults objectForKey:@"totalPicsDone"];
            if(nPics) nPics = @(nPics.intValue+1);
            else nPics = @1;
            fileName = [@"pic" stringByAppendingString:[nPics stringValue]];
            [self.defaults setObject:nPics forKey:@"totalPicsDone"];
        }
        filePath = [tmpDir stringByAppendingPathComponent:fileName];
        
        NSLog(@"Created %@", filePath);
        
        
    }
    else{
        fileName = currentPic.name;
        filePath = currentPic.path;
    }
    
    if([UIImageJPEGRepresentation(image, 1) writeToFile:filePath atomically:YES]){
        //Insertamos en CoreData
        currentPic.name = fileName;
        currentPic.path = filePath;
    }else currentPic.name = nil;
    
    //Creamos y guardamos una reducida
    UIImage *small = [self getThumbnail:image];
    [self saveTumbnail:small fileName:fileName];
    
    return currentPic;
}

-(void)saveTumbnail:(UIImage*)image fileName:(NSString*)fileName{

    NSString *hDir = NSHomeDirectory();
    NSString *tmpDir = [hDir stringByAppendingString:@"/Documents"];
    fileName = [fileName stringByAppendingString:@"_s"];
    NSString *filePath = [tmpDir stringByAppendingPathComponent:fileName];
    
    NSLog(@"Created %@", filePath);
    
    [UIImageJPEGRepresentation(image, 1) writeToFile:filePath atomically:YES];
    
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

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(NSArray*)faceDetectInImage:(UIImage*)image{
    
    //    UIImage *careto = [UIImage imageNamed:@"2014-08-28 19.00.58.jpg"];
    int exifOrientation = 0;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGSize c= image.size;
    
    image = [self imageWithImage:image scaledToSize:screenRect.size];
    
    c = image.size;
    
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
    
    
    
    NSMutableArray * faces = [@[] mutableCopy];
    
    for (CIFaceFeature *f in features)
    {
        if (f.hasLeftEyePosition)
            NSLog(@" ojos en %f, %f", f.leftEyePosition.x,
                  f.leftEyePosition.y  );
        if (f.hasRightEyePosition) NSLog(@"Tiene ojo derecho");
        if (f.hasMouthPosition) NSLog(@"Tiene boca");
        
        
        [faces addObject:NSStringFromCGRect(f.bounds)];
        
    }
    
    //  CGRect c = CGRectFromString(s);
    
    return faces;
}

- (Pic*)getReverseGeocodeLocation:(CLLocation *)selectedLocation forPic:(Pic*)p{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:selectedLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(placemarks.count){
            NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
            p.address = [dictionary valueForKey:@"Street"];
            p.city = [dictionary valueForKey:@"City"];
            p.area = [dictionary valueForKey:@"SubAdministrativeArea"];
            p.country = [dictionary valueForKey:@"Country"];
            p.zip = [dictionary valueForKey:@"ZIP"];
        }
        else{
            p.address = nil;
            p.city = nil;
            p.area = nil;
            p.zip = nil;
            p.country = nil;
        }
    }];
    
    return p;
    
}

@end
