//
//  DataActivityViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "DataActivityViewController.h"
#import "ActivityMapAnnotation.h"
#import "UserReports.h"
#import "Report.h"
#import "NewMosquitoViewController.h"

@interface DataActivityViewController ()

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
    // Do any additional setup after loading the view.
    NSMutableArray *annotationsArray = [[NSMutableArray alloc] init];
    
    for (Report *report in [UserReports sharedInstance].reports) {
        ActivityMapAnnotation *annotation = [[ActivityMapAnnotation alloc] initWithReport:report];
        [_mapView addAnnotation:annotation];
        [annotationsArray addObject:annotation];
    }
    [_mapView showAnnotations:annotationsArray animated:NO];
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:[LocalText with:@"back"]
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [_segmentedControl setTitle:[LocalText with:@"menu_option_map_type_street"] forSegmentAtIndex:0];
    [_segmentedControl setTitle:[LocalText with:@"menu_option_map_type_satellite"] forSegmentAtIndex:1];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    for (ActivityMapAnnotation *annotation in [_mapView selectedAnnotations]) {
        if ([[UserReports sharedInstance] reportWithId:annotation.reportId]==nil) {
            if (SHOW_LOGS) NSLog(@"elimino annotation %@",annotation.subtitle);
            [_mapView removeAnnotation:annotation];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.centerOffset = CGPointMake(0, -20);
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setImage:[UIImage imageNamed:@"chevron.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTintColor:[UIColor lightGrayColor]];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    ActivityMapAnnotation *mapAnnotation = (ActivityMapAnnotation *) annotation;
    
    if ([mapAnnotation.type isEqualToString:@"adult"]) {
        annotationView.image = [UIImage imageNamed:@"mappoint1"];
        annotationView.annotation = annotation;
    } else if ([mapAnnotation.type isEqualToString:@"site"]) {
        annotationView.image = [UIImage imageNamed:@"mappoint2"];
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    ActivityMapAnnotation *annotation = view.annotation;
    Report *report = [[UserReports sharedInstance] reportWithId:annotation.reportId];
    [report print];
    
    NewMosquitoViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewMosquitoViewController"];
    mvc.sourceReport = report;
    
    [self.navigationController pushViewController:mvc animated:YES];
    
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
