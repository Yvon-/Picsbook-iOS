//
//  YVHCustomButtonBar.m
//  Picsbook3 SB
//
//  Created by Yvon Valdepeñas on 30/09/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHCustomButtonBar.h"
#import "YVHGalleryVC.h"
//#import "YVHMainVC.h"
#import "YVHCameraVC.h"

@implementation YVHCustomButtonBar{
    YVHCameraVC *parent;
    UIView * v;
    YVHGalleryVC *gallery;
//    YVHMainVC * main;
    
}

- (id)initWithParent:(YVHCameraVC*)vc
{
    self = [super initWithFrame:vc.view.frame];
    if (self) {
        // Initialization code
        v = vc.view;
        parent = vc;
        gallery = [[YVHCameraVC alloc] init];
//        main = [[YVHMainVC alloc] init];
        [self initializeBarInParent];
        [self addCustomElements];
        
    }
    return self;
}

-(void)initializeBarInParent{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.tabBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, v.bounds.size.height - 0, screenRect.size.width, 52)];
    self.tabBackground.image = [UIImage imageNamed:@"TabBar.png"];
    [v addSubview:self.tabBackground];
    [UIView animateWithDuration:0.4 animations:^{
        self.tabBackground.frame = CGRectMake(0, v.bounds.size.height - 52, screenRect.size.width, 52);
        self.tabBackground.alpha = .5;
    }];
}

-(void)addCustomElements
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
	// Initialise our two images
	UIImage *btnImage = [UIImage imageNamed:@"Galery.png"];
	UIImage *btnImageSelected = [UIImage imageNamed:@"Galery_s.png"];
	
	self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
	_btn1.frame = CGRectMake(screenRect.size.width/8 - 30, v.bounds.size.height+10 - 50, 40, 30); // Set the frame (size and position) of the button)
   
	[_btn1 setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
	[_btn1 setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
	[_btn1 setTag:1]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
	[_btn1 setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
    [_btn1 setImageEdgeInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
    [_btn1.imageView setContentMode:UIViewContentModeScaleAspectFit];

	
	// Now we repeat the process for the other buttons
	btnImage = [UIImage imageNamed:@"mapOff.png"];
	btnImageSelected = [UIImage imageNamed:@"mapOn.png"];
	self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
	_btn2.frame = CGRectMake(3*screenRect.size.width/8 - 30, v.bounds.size.height +5 - 50, 40, 40);
	[_btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[_btn2 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[_btn2 setTag:2];
	
	btnImage = [UIImage imageNamed:@"cameraOff.png"];
	btnImageSelected = [UIImage imageNamed:@"cameraOff.png"];
	self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
	_btn3.frame = CGRectMake(5*screenRect.size.width/8-20 , v.bounds.size.height+5 - 50, 50, 40);
	[_btn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[_btn3 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[_btn3 setTag:3];
	
	btnImage = [UIImage imageNamed:@"menu.png"];
	btnImageSelected = [UIImage imageNamed:@"menu.png"];
	self.btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
	_btn4.frame = CGRectMake(7*screenRect.size.width/8 -10, v.bounds.size.height+10 - 50, 35, 30);
	[_btn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[_btn4 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[_btn4 setTag:4];
	
	// Add my new buttons to the view
	[v addSubview:_btn1];
	[v addSubview:_btn2];
	[v addSubview:_btn3];
	[v addSubview:_btn4];
	
}



- (void)selectButton:(int)tabID
{
	switch(tabID)
	{
		case 1:
			[_btn1 setSelected:true];
			[_btn2 setSelected:false];
			[_btn3 setSelected:false];
			[_btn4 setSelected:false];

            [parent presentModalViewController:gallery animated:YES];
			break;
		case 2:
			[_btn1 setSelected:false];
			[_btn2 setSelected:true];
			[_btn3 setSelected:false];
			[_btn4 setSelected:false];
            
//            [parent presentModalViewController:main animated:YES];
			break;
		case 3:
			[_btn1 setSelected:false];
			[_btn2 setSelected:false];
			[_btn3 setSelected:true];
			[_btn4 setSelected:false];
            
            [parent toCamera];
            
			break;
		case 4:
			[_btn1 setSelected:false];
			[_btn2 setSelected:false];
			[_btn3 setSelected:false];
			[_btn4 setSelected:true];
			break;
	}
	
	
}

@end
