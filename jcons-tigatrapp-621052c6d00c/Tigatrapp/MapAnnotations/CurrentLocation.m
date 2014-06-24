//
//  CurrentLocation.m
//  Tigatrapp
//
//  Created by jordi on 24/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import "CurrentLocation.h"

@implementation CurrentLocation

static CurrentLocation *sharedInstance = nil;

+ (CurrentLocation *) sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

-(void) startLocation {
    
    // location
    
    _locationEnabled = NO;
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;

    if([CLLocationManager locationServicesEnabled]){
        
        if (SHOW_LOGS) NSLog(@"Location enabled");
        [_locationManager startUpdatingLocation];
        
    }
    else {
        _locationEnabled = NO;
        // locationServicesEnabled was set to NO
        if (SHOW_LOGS) NSLog(@"Location disabled");
        
    }
}

# pragma mark - CLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied) {
        //location denied, handle accordingly
        _locationEnabled = NO;
        if (SHOW_LOGS) NSLog(@"We have not access to location services");
        
    } else if (status == kCLAuthorizationStatusAuthorized) {
        //hooray! begin startTracking
        if (SHOW_LOGS) NSLog(@"We have access to location services");
        [_locationManager startUpdatingLocation];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _locationEnabled = YES;
     CLLocation *location  = [locations lastObject];
    //if (SHOW_LOGS) NSLog(@"LocationManager at %f %f",location.coordinate.latitude,location.coordinate.longitude);
    _currentLatitude = location.coordinate.latitude;
    _currentLongitude = location.coordinate.longitude;
}


@end
