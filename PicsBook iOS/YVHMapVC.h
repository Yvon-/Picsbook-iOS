//
//  YVHMapVC.h
//  Picsbook3 SB
//
//  Created by Yvon Valdepeñas on 01/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface YVHMapVC : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)changeMapType:(id)sender;


@end
