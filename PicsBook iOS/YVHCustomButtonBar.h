//
//  YVHCustomButtonBar.h
//  Picsbook3 SB
//
//  Created by Yvon Valdepeñas on 30/09/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YVHCustomButtonBar : UIView

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIImageView *tabBackground;

- (id)initWithParent:(UIViewController*)vc;
- (void)selectButton:(int)tabID;
@end
