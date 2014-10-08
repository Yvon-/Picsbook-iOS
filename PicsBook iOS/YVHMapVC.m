//
//  YVHMapVC.m
//  Picsbook3 SB
//
//  Created by Yvon Valdepeñas on 01/10/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHMapVC.h"
#import "YVH MapViewAnnotation.h"
#import "YVHDAO.h"
#import "Pic.h"

@interface YVHMapVC ()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *picsArray;
@end

@implementation YVHMapVC

#define METERS_PER_MILE 1609.344

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Coredata Stack access
    self.managedObjectContext = [YVHDAO getContext];
    
    self.picsArray = [YVHDAO getSelectedPics];
    
  //  [self.mapView addAnnotations:[self getAnnotations]];
    [self.mapView showAnnotations:[self getAnnotations] animated:YES];
    _mapView.showsUserLocation = YES;
    //[self zoomToLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
     NSLog(@"MapVC memory warning");
    self.view = nil;
}


int zoomFactor = 20000;

- (IBAction)zoomIn:(id)sender {
    MKUserLocation *userLocation = _mapView.userLocation;
    zoomFactor /= 2;
    MKCoordinateRegion region =    MKCoordinateRegionMakeWithDistance (
                                                                       userLocation.location.coordinate, zoomFactor, zoomFactor);
    [_mapView setRegion:region animated:NO];
}

- (IBAction)changeMapType:(id)sender {
    if (_mapView.mapType == MKMapTypeStandard)
        _mapView.mapType = MKMapTypeSatellite;
    else
        _mapView.mapType = MKMapTypeStandard;
    
}
-(void)viewDidDisappear:(BOOL)animated{
    self.view = nil;
    self.mapView = nil;
}

- (IBAction)zoomOut:(id)sender {
    MKUserLocation *userLocation = _mapView.userLocation;
    
    zoomFactor *= 2;
    
    MKCoordinateRegion region =    MKCoordinateRegionMakeWithDistance (
                                                                       userLocation.location.coordinate, zoomFactor, zoomFactor);
    [_mapView setRegion:region animated:NO];
}

float lat, lon;
- (NSMutableArray *)createAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    //Read locations details from plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Locations" ofType:@"plist"];
    NSArray *locations = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *row in locations) {
        NSNumber *latitude = [row objectForKey:@"latitude"];
        NSNumber *longitude = [row objectForKey:@"longitude"];
        NSString *title = [row objectForKey:@"title"];
        lat = [latitude floatValue];
        lon = [longitude floatValue];
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude.doubleValue;
        coord.longitude = longitude.doubleValue;
        YVH_MapViewAnnotation *annotation = [[YVH_MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coord];
        [annotations addObject:annotation];
    }
    return annotations;
}


- (NSMutableArray *)getAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    //Read locations details from plist
    for (Pic *p in self.picsArray) {
        NSNumber *latitude =  p.latitude ;
        NSNumber *longitude = p.longitude;
        if([latitude isEqual:@0] && [longitude isEqual:@0]) continue;
        NSString *title = p.name;
        
        
        lat = [latitude floatValue];
        lon = [longitude floatValue];
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude.doubleValue;
        coord.longitude = longitude.doubleValue;
        YVH_MapViewAnnotation *annotation = [[YVH_MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coord];
        [annotations addObject:annotation];
    }
    return annotations;
}

- (void)zoomToLocation
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = lat;
    zoomLocation.longitude= lon;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 7.5*METERS_PER_MILE,7.5*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    [self.mapView regionThatFits:viewRegion];
}

@end
