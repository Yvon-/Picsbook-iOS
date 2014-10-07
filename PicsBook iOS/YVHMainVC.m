//
//  YVHMainVC.m
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 07/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHMainVC.h"

@interface YVHMainVC ()

@end

@implementation YVHMainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    
    UIViewController *vc1 =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YVHGalleryVC"];
    vc1.title = @"Gallery";
    
    
    UIViewController *vc2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VC2"];
    vc2.title = @"VC2";
    
    self.tabBarController = [[UITabBarController alloc]init];
    
    [self.tabBarController setViewControllers:@[vc1, vc2]];
    
    [self presentViewController:self.tabBarController animated:YES completion:nil];
}


@end
