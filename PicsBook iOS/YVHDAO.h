//
//  YVHDAO.h
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 08/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YVHCoreDataStack.h"

@interface YVHDAO : NSObject



+(NSManagedObjectContext *) getContext;
+(NSArray*)getPics:(NSPredicate*)pred;
+(void)setSelectedPics:(NSArray*)pics;
+(NSArray*)getSelectedPics;


@end
