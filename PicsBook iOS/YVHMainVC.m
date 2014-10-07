//
//  YVHMainVC.m
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 07/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHMainVC.h"
#import "RXCustomTabBar.h"

@interface YVHMainVC ()

@end

@implementation YVHMainVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    
    UIViewController *vc1 =  [self.storyboard instantiateViewControllerWithIdentifier:@"YVHGalleryVC"];
    vc1.title = @"Gallery";
    
    
    UIViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    vc2.title = @"Map";
    
    RXCustomTabBar *tabBarController = [[RXCustomTabBar alloc]init];
    
    [tabBarController setViewControllers:@[vc1, vc2]];
    
    [self presentViewController:tabBarController animated:YES completion:nil];
}


@end
