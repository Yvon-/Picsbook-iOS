//
//  YVHPicVC.m
//  Picsbook3 SB
//
//  Created by Yvon Valdepeñas on 31/08/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHPicVC.h"

@interface YVHPicVC (){

}

@property (weak, nonatomic) IBOutlet UIImageView *pic;


@end


@implementation YVHPicVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pic.image = self.img;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)share:(id)sender {
    UIActivityViewController * controller = [[UIActivityViewController alloc]initWithActivityItems:@[self.img] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];

}


@end
