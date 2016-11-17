//
//  DataActivityViewController.h
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DataActivityViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIView *legendView;
@property (weak, nonatomic) IBOutlet UILabel *nearbyLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownLabel;

- (IBAction)pressSegmentedControl:(id)sender;
- (IBAction)pressShareButton:(id)sender;


@end
