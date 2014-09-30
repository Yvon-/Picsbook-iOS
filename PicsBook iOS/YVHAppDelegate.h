//
//  YVHAppDelegate.h
//  Picsbook3 SB
//
//  Created by Yvon Valdepeñas on 20/08/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YVHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
