//
//  YVHUtil.h
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 16/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pic.h"

@interface YVHUtil : NSObject

+ (YVHUtil*)getInstance;
-(Pic *)saveImage:(UIImage*)image currentPic:(Pic*)currentPic isNewImage:(BOOL)isNewImage withName:(NSString*)name;
-(void)saveTumbnail:(UIImage*)image fileName:(NSString*)fileName;
-(UIImage *)getThumbnail:(UIImage*)originalImage;
-(CGSize)reducePic:(CGSize)sz;


@end
