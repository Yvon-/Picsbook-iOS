//
//  YVH MapViewAnnotation.m
//  Picsbook3 SB
//
//  Created by Yvon Valdepeñas on 03/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVH MapViewAnnotation.h"

@implementation YVH_MapViewAnnotation

@synthesize coordinate=_coordinate;
@synthesize title=_title;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    _title = title;
    _coordinate = coordinate;
    return self;
}
@end
