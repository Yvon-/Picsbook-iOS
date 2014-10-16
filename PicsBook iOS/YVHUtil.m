//
//  YVHUtil.m
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 16/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHUtil.h"
#import "Pic.h"

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


-(Pic *)saveImage:(UIImage*)image currentPic:(Pic*)currentPic isNewImage:(BOOL)isNewImage{
    
    NSString *fileName;
    NSString *filePath;
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    if (isNewImage) {
        NSNumber * nPics = [self.defaults objectForKey:@"totalPicsDone"];
        if(nPics) nPics = @(nPics.intValue+1);
        else nPics = @1;

        NSString *hDir = NSHomeDirectory();
        NSString *tmpDir = [hDir stringByAppendingString:@"/Documents"];
        fileName = [@"pic" stringByAppendingString:[nPics stringValue]];
        filePath = [tmpDir stringByAppendingPathComponent:fileName];
        
        NSLog(@"Created %@", filePath);
        
        [self.defaults setObject:nPics forKey:@"totalPicsDone"];
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

@end
