//
//  YVHDAO.m
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 08/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHDAO.h"


@implementation YVHDAO

+(NSManagedObjectContext *)getContext{
    return [[YVHCoreDataStack getInstance] managedObjectContext];
}


+(NSArray*)getPics:(NSPredicate*)pred{
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Pic" inManagedObjectContext:[self getContext]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    if(pred)request.predicate = pred;
    
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [[self getContext] executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"No hay datos");
    }
    
    
    return array;
    
}

@end
