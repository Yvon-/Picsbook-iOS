//
//  YVHPicVC.h
//  Picsbook3 SB
//
//  Created by Yvon Valdepeñas on 31/08/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YVHPicVC : UIViewController


- (id)initWithPic:(UIImage *)pic;
@property(nonatomic,strong) UIImage *img;
@end
