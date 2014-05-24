//
//  ChooseOnMapViewController.h
//  Tigatrapp
//
//  Created by jordi on 26/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ChooseOnMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end
