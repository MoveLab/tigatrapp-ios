//
//  NewMosquitoViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "NewMosquitoViewController.h"
#import "MosquitoChecklistViewController.h"
#import "PickPhotoViewController.h"
#import "NoteViewController.h"
#import "ChooseOnMapViewController.h"
#import "Report.h"
#import "CurrentLocation.h"

@interface NewMosquitoViewController ()

@end

@implementation NewMosquitoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.report = [[Report alloc] init];
    self.tableView.tableFooterView = [UIView new];
}


- (void) viewWillAppear:(BOOL)animated {
    if (_report.images.count>0) {
        _numberOfImagesLabel.text = [NSString stringWithFormat:@"%d",_report.images.count];
    } else {
        _numberOfImagesLabel.text = @"";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location

-(IBAction)pressSwitch:(id)sender  {
    if (_actualSwitch.isOn) {
        
        if([CLLocationManager locationServicesEnabled]) {
            _report.locationChoice = @"current";
            _report.currentLocationLon = [NSNumber numberWithFloat:2.0];
            _report.currentLocationLat = [NSNumber numberWithFloat:1.0];
            _report.selectedLocationLon = [NSNumber numberWithFloat:[CurrentLocation sharedInstance].currentLongitude];
            _report.selectedLocationLat = [NSNumber numberWithFloat:[CurrentLocation sharedInstance].currentLatitude];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tigatrapp"
                                                            message:[NSString stringWithFormat:@"Posición actual guardada\n\nLat: %f\nLon: %f",[CurrentLocation sharedInstance].currentLatitude,[CurrentLocation sharedInstance].currentLongitude]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        } else {
            _report.locationChoice = nil;
            _report.currentLocationLon = nil;
            _report.currentLocationLat = nil;

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tigatrapp"
                                                            message:@"Turn on Location Services to allow Tigatrapp to determine your location"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }

        
        
        
        
    } else {
        _report.locationChoice = nil;
        _report.currentLocationLon = nil;
        _report.currentLocationLat = nil;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Volver"
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    if ([segue.identifier isEqualToString:@"checklistSegue"]) {
        MosquitoChecklistViewController *viewController = segue.destinationViewController;
        viewController.report = _report;
    } else if ([segue.identifier isEqualToString:@"photoSegue"]) {
        PickPhotoViewController *viewController = segue.destinationViewController;
        viewController.report = _report;
    } else if ([segue.identifier isEqualToString:@"mapSegue"]) {
        ChooseOnMapViewController *viewController = segue.destinationViewController;
        viewController.report = _report;
    } else if ([segue.identifier isEqualToString:@"noteSegue"]) {
        NoteViewController *viewController = segue.destinationViewController;
        viewController.report = _report;
    }
    
}

@end
