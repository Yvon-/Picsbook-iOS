//
//  PicListCell.h
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 19/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *facesText;
@property (weak, nonatomic) IBOutlet UILabel *faces;
@property (weak, nonatomic) IBOutlet UILabel *addressText;
@property (weak, nonatomic) IBOutlet UILabel *address;


@end
