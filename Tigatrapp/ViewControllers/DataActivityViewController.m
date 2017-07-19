//
//  DataActivityViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import "DataActivityViewController.h"
#import "ActivityMapAnnotation.h"
#import "UserReports.h"
#import "Report.h"
#import "ReportViewController.h"
#import "RestApi.h"

@interface DataActivityViewController ()
@property (strong, nonatomic) NSMutableArray *annotationsArray;
@property (nonatomic) BOOL located;
@end

@implementation DataActivityViewController

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
    
    self.title = [LocalText with:@"header_title"];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];

    // Do any additional setup after loading the view.
    self.annotationsArray = [[NSMutableArray alloc] init];
    
    for (Report *report in [UserReports sharedInstance].reports) {
        ActivityMapAnnotation *annotation = [[ActivityMapAnnotation alloc] initWithReport:report];
        [_mapView addAnnotation:annotation];
        [_annotationsArray addObject:annotation];
    }
    if ([CLLocationManager locationServicesEnabled]) {
        // no adapto el mapa a les mides
        self.located = NO;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        [_mapView setShowsUserLocation:YES];
        
    } else {
        [_mapView showAnnotations:_annotationsArray animated:NO];
        if (SHOW_LOGS) NSLog(@"inicialitzo mapa propers");
        double radius = 5000; // fixe 5km
        [[RestApi sharedInstance] nearbyReportsFromLat:_mapView.centerCoordinate.latitude
                                                andLon:_mapView.centerCoordinate.longitude
                                             andRadius:radius];
        
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:[LocalText with:@"back"]
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [_segmentedControl setTitle:[LocalText with:@"menu_option_map_type_street"] forSegmentAtIndex:0];
    [_segmentedControl setTitle:[LocalText with:@"menu_option_map_type_satellite"] forSegmentAtIndex:1];
    
    
    _nearbyLabel.text = [LocalText with:@"my-map-legend-label-nearby-observations-nearby-observations"];
    _ownLabel.text = [LocalText with:@"my-map-legend-label-my-observations-my-observations"];
    _legendView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    _legendView.layer.cornerRadius = 4.0;
    _legendView.layer.masksToBounds = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotNearbyReports:)
                                                 name:@"nearbyReports"
                                               object:nil];
    
    [Helper resizePortraitView:self.view];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    for (ActivityMapAnnotation *annotation in [_mapView selectedAnnotations]) {
        if ([annotation.type isEqualToString:@"nearby"]) {
            
        } else {
            Report *report = [[UserReports sharedInstance] reportWithId:annotation.reportId];
            if (report == nil) {
                if (SHOW_LOGS) NSLog(@"elimino annotation %@",annotation.subtitle);
                [_mapView removeAnnotation:annotation];
            } else {
                // validar si hi ha hagut canvis de coordenades i reposicionar
                [annotation updateCoordinates:report];
                
            }
            
        }
    }
    if ([CLLocationManager locationServicesEnabled]) {
        // no adapto el mapa a les mides
    } else {
        [_mapView showAnnotations:[_mapView selectedAnnotations] animated:NO];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if (!_located) {
        self.located = YES;
        if (SHOW_LOGS) NSLog(@"inicialitzo localitzacio a posicio actual");
        CLLocation *location = [locations lastObject];
        //double radius = MIN([self getRadius],10000); // min 10KM
        double radius = 5000; // fixe 5km
        [[RestApi sharedInstance] nearbyReportsFromLat:location.coordinate.latitude
                                                andLon:location.coordinate.longitude
                                             andRadius:radius];
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.2;
        span.longitudeDelta = 0.2;
        CLLocationCoordinate2D clocation;
        clocation.latitude = location.coordinate.latitude;
        clocation.longitude = location.coordinate.longitude;
        region.span = span;
        region.center = clocation;
        [_mapView setRegion:region animated:YES];
        
        
    }

}


- (IBAction)pressSegmentedControl:(id)sender {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        _mapView.mapType = MKMapTypeStandard;
    } else {
        _mapView.mapType = MKMapTypeSatellite;
    }
    
}

- (IBAction)pressShareButton:(id)sender {
    UIGraphicsBeginImageContextWithOptions(_mapView.frame.size, NO, 0.0);
    [_mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSArray *activityItems;
    activityItems = @[image];
    UIActivityViewController *activityController = [[UIActivityViewController alloc]
                                                    initWithActivityItems:activityItems
                                                    applicationActivities:nil];
    
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if (annotation == _mapView.userLocation) return nil;
    
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.centerOffset = CGPointMake(0, -20);
    
    ActivityMapAnnotation *mapAnnotation = (ActivityMapAnnotation *) annotation;
    
    if ([mapAnnotation.type isEqualToString:@"adult"]) {
        annotationView.image = [UIImage imageNamed:@"mappoint2"];
        annotationView.annotation = annotation;
        UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mosquito"]];
        myImageView.frame = CGRectMake(0,0,31,31); // Change the size of the image to fit the callout
        annotationView.leftCalloutAccessoryView = myImageView;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    } else if ([mapAnnotation.type isEqualToString:@"nearby"]) {
        annotationView.image = [UIImage imageNamed:@"mappoint3"];
        annotationView.annotation = annotation;
        UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mosquito"]];
        myImageView.frame = CGRectMake(0,0,31,31); // Change the size of the image to fit the callout
        annotationView.leftCalloutAccessoryView = myImageView;
    } else if ([mapAnnotation.type isEqualToString:@"site"]) {
        annotationView.image = [UIImage imageNamed:@"mappoint2"];
        annotationView.annotation = annotation;
        UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aigues"]];
        myImageView.frame = CGRectMake(0,0,31,31); // Change the size of the image to fit the callout
        annotationView.leftCalloutAccessoryView = myImageView;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
    }
    
    return annotationView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    ActivityMapAnnotation *annotation = view.annotation;

    if ([annotation.type isEqualToString:@"nearby"]) {
        // no action. just show callout
    } else {
        Report *report = [[UserReports sharedInstance] reportWithId:annotation.reportId];
        
        ReportViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewMosquitoViewController"];
        mvc.reportType = annotation.type;
        mvc.sourceReport = report;
        
        [self.navigationController pushViewController:mvc animated:YES];
    }
}



#pragma mark trobar centre mapa

- (void) gotNearbyReports:(NSNotification *)notification {
    NSDictionary *d = notification.userInfo;
    
    //NSLog(@"nr %@",d);
    
    NSArray *reports = d[@"response"];
    
    
    for (NSDictionary *r in reports) {
        
        NSDictionary *d = @{@"version_UUID":r[@"version_UUID"]
                            ,@"type":@"nearby"
                            ,@"note":r[@"simplified_annotation"][@"classification"]
                            ,@"location_choice":@"selected"
                            ,@"selected_location_lat":r[@"lat"]
                            ,@"selected_location_lon":r[@"lon"]
                            ,@"creation_time":r[@"creation_time"]};
        Report *report = [[Report alloc] initWithDictionary:d];
        
        ActivityMapAnnotation *annotation = [[ActivityMapAnnotation alloc] initWithReport:report];
        [_mapView addAnnotation:annotation];
        
    }
    if ([CLLocationManager locationServicesEnabled]) {
        // no adapto el mapa a les mides
    } else {
        [_mapView showAnnotations:_annotationsArray animated:YES];
    }
}
    
- (CLLocationCoordinate2D)getTopCenterCoordinate
{
    // to get coordinate from CGPoint of your map
    CLLocationCoordinate2D topCenterCoor = [self.mapView convertPoint:CGPointMake(self.mapView.frame.size.width / 2.0f, 0) toCoordinateFromView:self.mapView];
    return topCenterCoor;
}
- (CLLocationCoordinate2D)getCenterCoordinate
{
    CLLocationCoordinate2D centerCoor = [self.mapView centerCoordinate];
    return centerCoor;
}
- (CLLocationDistance)getRadius {
    CLLocationCoordinate2D centerCoor = [self getCenterCoordinate];
    // init center location from center coordinate
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerCoor.latitude longitude:centerCoor.longitude];
    
    CLLocationCoordinate2D topCenterCoor =  [self getTopCenterCoordinate];
    CLLocation *topCenterLocation = [[CLLocation alloc] initWithLatitude:topCenterCoor.latitude longitude:topCenterCoor.longitude];
    
    CLLocationDistance radius = [centerLocation distanceFromLocation:topCenterLocation];
    
    return radius;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
