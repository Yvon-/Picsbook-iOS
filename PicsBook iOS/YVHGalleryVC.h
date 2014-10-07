//
//  YVHGallery.h
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 30/09/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YVHCameraVC.h"

@interface YVHGalleryVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
