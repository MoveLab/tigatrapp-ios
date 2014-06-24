//
//  CurrentLocation.h
//  Tigatrapp
//
//  Created by jordi on 24/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentLocation : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL locationEnabled;
@property (nonatomic) float currentLatitude;
@property (nonatomic) float currentLongitude;

+ (CurrentLocation *)sharedInstance;
-(void) startLocation;

@end
