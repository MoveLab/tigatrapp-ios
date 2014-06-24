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
    
    ActivityMapAnnotation *mapAnnotation = (ActivityMapAnnotation *) annotation;
    
    if ([mapAnnotation.type isEqualToString:@"adult"]) {
        annotationView.image = [UIImage imageNamed:@"mappoint1"];
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
        
    }
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    ActivityMapAnnotation *annotation = view.annotation;
    Report *report = [[UserReports sharedInstance] reportWithId:annotation.reportId];
    
    ReportViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewMosquitoViewController"];
    mvc.reportType = annotation.type;
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
