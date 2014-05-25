//
//  ChooseOnMapViewController.h
//  Tigatrapp
//
//  Created by jordi on 26/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Report.h"

@class ActivityMapAnnotation;

@interface ChooseOnMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *removeButton;
@property (nonatomic, strong) ActivityMapAnnotation *annotation;

@property (nonatomic, weak) Report *report;

- (IBAction)pressSegmentedControl:(id)sender;
- (IBAction)pressRemove:(id)sender;

@end
