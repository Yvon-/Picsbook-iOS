//
//  YVHUtil.h
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 16/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pic.h"
#import <CoreLocation/CoreLocation.h>

@interface YVHUtil : NSObject

+ (YVHUtil*)getInstance;
-(Pic *)saveImage:(UIImage*)image currentPic:(Pic*)currentPic isNewImage:(BOOL)isNewImage withName:(NSString*)name;
-(void)saveTumbnail:(UIImage*)image fileName:(NSString*)fileName;
-(UIImage *)getThumbnail:(UIImage*)originalImage;
-(CGSize)reducePic:(CGSize)sz;
-(NSArray*)faceDetectInImage:(UIImage*)image;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (Pic*)getReverseGeocodeLocation:(CLLocation *)selectedLocation forPic:(Pic*)p;

@end
