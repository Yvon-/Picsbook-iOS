//
//  RumexCustomTabBar.m
//  
//
//  Created by Oliver Farago on 19/06/2010.
//  Copyright 2010 Rumex IT All rights reserved.
//

#import "RXCustomTabBar.h"

@implementation RXCustomTabBar
static RXCustomTabBar* _shared = nil;
@synthesize btn1, btn2, btn3, btn4;



static int lastTab = 0;

+(RXCustomTabBar*)getInstance
{
    @synchronized([RXCustomTabBar class])
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

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self hideTabBar];
	[self addCustomElements];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
//	[self hideTabBar];
//	[self addCustomElements];
}

- (void)hideTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}


-(void)initializeBar{

}

- (void)hideNewTabBar 
{
    self.btn1.hidden = 1;
    self.btn2.hidden = 1;
    self.btn3.hidden = 1;
    self.btn4.hidden = 1;
}

- (void)showNewTabBar 
{
    self.btn1.hidden = 0;
    self.btn2.hidden = 0;
    self.btn3.hidden = 0;
    self.btn4.hidden = 0;
}

-(void)addCustomElements
{
    
    //Bar image
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.tabBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 0, screenRect.size.width, 52)];
    self.tabBackground.image = [UIImage imageNamed:@"TabBar.png"];
    [self.view addSubview:self.tabBackground];
    [UIView animateWithDuration:0.4 animations:^{
        self.tabBackground.frame = CGRectMake(0, self.view.bounds.size.height - 52, screenRect.size.width, 52);
        self.tabBackground.alpha = .5;
    }];
    
	// Initialise our two images
	UIImage *btnImage = [UIImage imageNamed:@"Galery.png"];
	UIImage *btnImageSelected = [UIImage imageNamed:@"Galery_s.png"];
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
	self.btn1.frame = CGRectMake(screenRect.size.width/8 - 30, self.view.bounds.size.height+10 - 50, 40, 30); // Set the frame (size and position) of the button)
	[self.btn1 setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
	[self.btn1 setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
	[self.btn1 setTag:0]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
	
    [self.btn1 setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
 //   [self.btn1 setImageEdgeInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
 //   [self.btn1.imageView setContentMode:UIViewContentModeScaleAspectFit];
	

	
	// Now we repeat the process for the other buttons
	btnImage = [UIImage imageNamed:@"mapOff.png"];
	btnImageSelected = [UIImage imageNamed:@"mapOn.png"];
	self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.btn2.frame = CGRectMake(3*screenRect.size.width/8 - 30, self.view.bounds.size.height +5 - 50, 40, 40);
	[self.btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[self.btn2 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[self.btn2 setTag:1];
	
	btnImage = [UIImage imageNamed:@"cameraOff.png"];
	btnImageSelected = [UIImage imageNamed:@"cameraOff.png"];
	self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.btn3.frame = CGRectMake(5*screenRect.size.width/8-20 , self.view.bounds.size.height+5 - 50, 50, 40);
	[self.btn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[self.btn3 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[self.btn3 setTag:2];
	
	btnImage = [UIImage imageNamed:@"menu.png"];
	btnImageSelected = [UIImage imageNamed:@"menu.png"];
	self.btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.btn4.frame = CGRectMake(7*screenRect.size.width/8 -10, self.view.bounds.size.height+10 - 50, 35, 30);
	[self.btn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[self.btn4 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[self.btn4 setTag:3];
    
    
	// Add my new buttons to the view
	[self.view addSubview:btn1];
	[self.view addSubview:btn2];
	[self.view addSubview:btn3];
	[self.view addSubview:btn4];
	
	// Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
	[btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn4 addTarget:self action:@selector(buttonOptions:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClicked:(id)sender
{
	int tagNum = [sender tag];
	[self selectTab:tagNum];
    lastTab = tagNum;
}

int lasttab = 0;
- (void)buttonOptions:(id)sender
{
	switch (lastTab) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GalleryOptions"
                                                                object:self];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MapOptions"
                                                                object:self];
            break;
    }
}


- (void)selectTab:(int)tabID
{
	switch(tabID)
	{
		case 0:
			[btn1 setSelected:true];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
            lastTab = 0;
			break;
		case 1:
			[btn1 setSelected:false];
			[btn2 setSelected:true];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
            lastTab = 1;
			break;
		case 2:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:true];
			[btn4 setSelected:false];
            
			break;
	}	
	
	self.selectedIndex = tabID;
	
	
}


-(void) toLastTab{
    [self selectTab:lastTab];
}


@end
