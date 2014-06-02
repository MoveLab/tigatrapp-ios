//
//  ChooseOnMapViewController.m
//  Tigatrapp
//
//  Created by jordi on 26/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "ChooseOnMapViewController.h"
#import "CurrentLocation.h"
#import "ActivityMapAnnotation.h"

@interface ChooseOnMapViewController ()
@end

@implementation ChooseOnMapViewController

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
    // Do any additional setup after loading the view.
    
    MKCoordinateRegion region;
    if ([_report.locationChoice isEqualToString:@"selected"]) {
        region.center.latitude = [_report.selectedLocationLat floatValue];
        region.center.longitude = [_report.selectedLocationLon floatValue];
        _annotation = [[ActivityMapAnnotation alloc] init];
        [_mapView addAnnotation:_annotation];
        _annotation.coordinate = region.center;
        
    } else {
        region.center.latitude = [CurrentLocation sharedInstance].currentLatitude;
        region.center.longitude = [CurrentLocation sharedInstance].currentLongitude;
    }
    
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [_mapView setRegion:region animated:YES];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5;
    [_mapView addGestureRecognizer:lpgr];
    
    [_segmentedControl setTitle:[LocalText with:@"menu_option_map_type_street"] forSegmentAtIndex:0];
    [_segmentedControl setTitle:[LocalText with:@"menu_option_map_type_satellite"] forSegmentAtIndex:1];
    
    _removeButton.title = [LocalText with:@"delete"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark segmented control

- (IBAction)pressSegmentedControl:(id)sender {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        _mapView.mapType = MKMapTypeStandard;
    } else {
        _mapView.mapType = MKMapTypeSatellite;
    }
    
}

#pragma mark - select location


- (IBAction)pressRemove:(id)sender {

    if (_annotation) {
        [_mapView removeAnnotation:_annotation];
        _report.locationChoice = nil;
        _report.selectedLocationLon = nil;
        _report.selectedLocationLat = nil;
    }
    
}


- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:_mapView];

    _report.locationChoice = @"selected";
    _report.selectedLocationLon = [NSNumber numberWithFloat:touchMapCoordinate.longitude];
    _report.selectedLocationLat = [NSNumber numberWithFloat:touchMapCoordinate.latitude];
    
    if (!_annotation) {
        _annotation = [[ActivityMapAnnotation alloc] initWithReport:_report];
    }
    _annotation.coordinate = touchMapCoordinate;
    [_mapView addAnnotation:_annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.image = [UIImage imageNamed:@"mappoint1"];
    annotationView.annotation = annotation;
    
    return annotationView;
}



/*
#pragma mark - Navigation

//  In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
