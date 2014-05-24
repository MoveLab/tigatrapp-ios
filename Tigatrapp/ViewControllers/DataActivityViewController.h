//
//  DataActivityViewController.h
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface DataActivityViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)pressSegmentedControl:(id)sender;


@end
