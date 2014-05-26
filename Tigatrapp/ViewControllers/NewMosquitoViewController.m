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
#import "UserReports.h"
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
    
    if (self.report == nil) {
        self.report = [[Report alloc] initWithDictionary:nil];
        _reportarMosquitoLabel.text = @"Nou mosquit tigre";
    } else {
        _reportarMosquitoLabel.text = [NSString stringWithFormat:@"Troballa de mosquit tigre\n%@",[self.report niceCreationTime]];
    }
    self.tableView.tableFooterView = [UIView new];
}


- (void) viewWillAppear:(BOOL)animated {
    if (_report.images.count>0) {
        _numberOfImagesLabel.text = [NSString stringWithFormat:@"%d",_report.images.count];
    } else {
        _numberOfImagesLabel.text = @"";
    }
    
    if ([_report.locationChoice isEqualToString:@"current"]) {
        _actualSwitch.on = YES;
    } else {
        _actualSwitch.on = NO;
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
            _report.selectedLocationLon = nil;
            _report.selectedLocationLat = nil;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tigatrapp"
                                                            message:[NSString stringWithFormat:@"Posición actual guardada\n\nLat: %f\nLon: %f",[CurrentLocation sharedInstance].currentLatitude,[CurrentLocation sharedInstance].currentLongitude]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        } else {
            _report.locationChoice = nil;

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tigatrapp"
                                                            message:@"Turn on Location Services to allow Tigatrapp to determine your location"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } else {
        _report.locationChoice = nil;
    }
}


#pragma mark - Validation and send

- (IBAction)pressSend:(id)sender {
    
    _report.type = @"adult";
    _report.currentLocationLon = [NSNumber numberWithFloat:[CurrentLocation sharedInstance].currentLongitude];
    _report.currentLocationLat = [NSNumber numberWithFloat:[CurrentLocation sharedInstance].currentLatitude];

    [[UserReports sharedInstance] addReport:_report];
    [self.navigationController popViewControllerAnimated:YES];
    
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
