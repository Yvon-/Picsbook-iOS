//
//  YVH MapViewAnnotation.h
//  Picsbook3 SB
//
//  Created by Yvon Valdepeñas on 03/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface YVH_MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic,copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate;


@end
