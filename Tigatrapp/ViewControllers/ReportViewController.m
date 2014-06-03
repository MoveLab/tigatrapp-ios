//
//  NewMosquitoViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "ReportViewController.h"
#import "MosquitoChecklistViewController.h"
#import "SiteChecklistViewController.h"
#import "PickPhotoViewController.h"
#import "NoteViewController.h"
#import "ChooseOnMapViewController.h"
#import "Report.h"
#import "UserReports.h"
#import "CurrentLocation.h"

#define COMMIT_ALERT 87
#define DELETE_ALERT 88

@interface ReportViewController ()
@end

@implementation ReportViewController

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
    
    if ([_reportType isEqualToString:@"adult"]) {
        if (self.sourceReport == nil) {
            self.report = [[Report alloc] initWithDictionary:nil];
            _reportarMosquitoLabel.text = [LocalText with:@"report_title_adult"];
            _report.type = _reportType;
            [_enviarButton setTitle:[LocalText with:@"submit"] forState:UIControlStateNormal];
            
        } else {
            self.report = [[Report alloc] initWithDictionary:[_sourceReport dictionaryIncludingImages:YES] ];
            self.report.versionNumber = [NSNumber numberWithInt:[self.report.versionNumber intValue]+1];
            _reportarMosquitoLabel.text = [NSString stringWithFormat:@"%@\n%@"
                                           ,[LocalText with:@"view_report_title_adult"]
                                           ,[_report niceCreationTime]];
            [_enviarButton setTitle:[LocalText with:@"update"] forState:UIControlStateNormal];
        }
        _hacerUnaFotografiaLabel.text = [LocalText with:@"photo_label"];
        
    } else {
        if (self.sourceReport == nil) {
            self.report = [[Report alloc] initWithDictionary:nil];
            _reportarMosquitoLabel.text = [LocalText with:@"report_title_site"];
            _report.type = _reportType;
            [_enviarButton setTitle:[LocalText with:@"submit"] forState:UIControlStateNormal];
        } else {
            self.report = [[Report alloc] initWithDictionary:[_sourceReport dictionaryIncludingImages:YES] ];
            self.report.versionNumber = [NSNumber numberWithInt:[self.report.versionNumber intValue]+1];
            _reportarMosquitoLabel.text = [NSString stringWithFormat:@"%@\n%@"
                                           ,[LocalText with:@"view_report_title_site"]
                                           ,[_report niceCreationTime]];
            [_enviarButton setTitle:[LocalText with:@"update"] forState:UIControlStateNormal];
        }
        _hacerUnaFotografiaLabel.text = [LocalText with:@"photo_label_star"];

    }

    
    _checklistLabel.text = [LocalText with:@"checklist_label_editing"];
    _localizacionLabel.text = [LocalText with:@"location_label_editing"];
    _actualLabel.text = [LocalText with:@"location_current_label_button"];
    _seleccionarEnElMapaLabel.text = [LocalText with:@"location_select_label_button"];
    _informacionAdicionalLabel.text = [LocalText with:@"additional_information"];
    _notaLabel.text = [LocalText with:@"note_check_label"];
    
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
                                                            message:[NSString stringWithFormat:@"%@\n\nLat: %f\nLon: %f"
                                                                     ,[LocalText with:@"added_current_loc"]
                                                                     ,[CurrentLocation sharedInstance].currentLatitude
                                                                     ,[CurrentLocation sharedInstance].currentLongitude]
                                                           delegate:self
                                                  cancelButtonTitle:[LocalText with:@"ok"]
                                                  otherButtonTitles:nil];
            [alert show];

        } else {
            _report.locationChoice = nil;

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tigatrapp"
                                                            message:[LocalText with:@"turn_on_location"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } else {
        _report.locationChoice = nil;
    }
}

-(IBAction)pressDelete:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tigatrapp"
                                                    message:[LocalText with:@"delete_report_warning"]
                                                   delegate:self
                                          cancelButtonTitle:[LocalText with:@"delete_report"]
                                          otherButtonTitles:[LocalText with:@"cancel"],nil];
    alert.tag = DELETE_ALERT;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

    if (alertView.tag == DELETE_ALERT) {
        if (buttonIndex == 0) {
            if (_sourceReport!=nil) {
                [[UserReports sharedInstance] deleteReport:_sourceReport];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (alertView.tag == COMMIT_ALERT) {
        if (buttonIndex == 0) {
            if (self.sourceReport==nil) {
                [[UserReports sharedInstance] addReport:_report];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [[UserReports sharedInstance].reports removeObject:_sourceReport];
                [[UserReports sharedInstance] addReport:_report];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

#pragma mark - Validation and send

- (BOOL) checkAnswers {
    
    NSString *check;
    if ([_report.type isEqualToString:@"adult"]) {
        check = [LocalText with:@"toast_report_before_submitting_adult"];
    } else {
        check = [LocalText with:@"toast_report_before_submitting_site"];
    }
    
    if (_report.responses.count <3) {
        check = [NSString stringWithFormat:@"%@\n%@"
                 ,check
                 ,[LocalText with:@"toast_complete_checklist"]];
    }
    
    if ((_report.locationChoice==nil)
        ||([_report.locationChoice isEqualToString:@"current"] && (_report.currentLocationLat==nil))
        ||([_report.locationChoice isEqualToString:@"selected"] && (_report.selectedLocationLat==nil))) {
        check = [NSString stringWithFormat:@"%@\n%@"
                 ,check
                 ,[LocalText with:@"toast_specify_location"]];
    }
    
    if ([_report.type isEqualToString:@"site"] && [_report.images count]==0) {
        check = [NSString stringWithFormat:@"%@\n%@"
                 ,check
                 ,[LocalText with:@"toast_attach_photo"]];
    }
    
    if (check.length > 60) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tigatrapp"
                                                        message:check
                                                       delegate:self
                                              cancelButtonTitle:[LocalText with:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (IBAction)pressSend:(id)sender {
    
    _report.currentLocationLon = [NSNumber numberWithFloat:[CurrentLocation sharedInstance].currentLongitude];
    _report.currentLocationLat = [NSNumber numberWithFloat:[CurrentLocation sharedInstance].currentLatitude];
    
    if ([self checkAnswers]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tigatrapp"
                                                        message:[LocalText with:@"report_sent"]
                                                       delegate:self
                                              cancelButtonTitle:[LocalText with:@"ok"]
                                              otherButtonTitles:[LocalText with:@"cancel"],nil];
        alert.tag = COMMIT_ALERT;
        [alert show];
        

    }
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0 && indexPath.row == 1) {
        if ([_reportType isEqualToString:@"adult"]) {
            [self performSegueWithIdentifier: @"mosquitoSegue" sender: self];
        } else {
            [self performSegueWithIdentifier: @"siteSegue" sender: self];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:[LocalText with:@"back"]
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    if ([segue.identifier isEqualToString:@"mosquitoSegue"]) {
        MosquitoChecklistViewController *viewController = segue.destinationViewController;
        viewController.report = _report;
    } else if ([segue.identifier isEqualToString:@"siteSegue"]) {
        SiteChecklistViewController *viewController = segue.destinationViewController;
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
