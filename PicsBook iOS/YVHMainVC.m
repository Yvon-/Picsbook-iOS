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

@interface YVHMainVC ()

@end

@implementation YVHMainVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    
    UIViewController *vc1 =  [self.storyboard instantiateViewControllerWithIdentifier:@"YVHGalleryVC"];
    
    UIViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    
    UIViewController *vc3 = [[YVHCameraVC alloc]init];

    
    
    RXCustomTabBar *tabBarController = [[RXCustomTabBar alloc]init];
    
    [tabBarController setViewControllers:@[vc1, vc2, vc3]];
    
    [self presentViewController:tabBarController animated:YES completion:nil];
}


@end
