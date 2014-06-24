//
//  NewMosquitoViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
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
#import "HelpViewController.h"

#define COMMIT_ALERT 87
#define DELETE_ALERT 88
#define THANKS_ALERT 89

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
            self.report.versionUUID =  [[NSUUID UUID] UUIDString];
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
            self.report.versionUUID =  [[NSUUID UUID] UUIDString];
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
    
    if ([_report.versionNumber intValue]>1 && [_report.locationChoice isEqualToString:@"current"]) {
        _report.locationChoice = @"was_current";
        _report.selectedLocationLon = [NSNumber numberWithFloat:[_report.currentLocationLon floatValue]];
        _report.selectedLocationLat = [NSNumber numberWithFloat:[_report.currentLocationLat floatValue]];
        _report.currentLocationLon = nil;
        _report.currentLocationLat = nil;
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    if (_report.images.count>0) {
        _numberOfImagesLabel.text = [NSString stringWithFormat:@"%d",(int)_report.images.count];
    } else {
        _numberOfImagesLabel.text = @"";
    }
    
    if ([_report.locationChoice isEqualToString:@"current"]) {
        _actualSwitch.on = YES;
    } else {
        _actualSwitch.on = NO;
    }
    
    if (_report.responses.count == 3) {
        _checklistIcon.alpha = 1.0;
    } else {
        _checklistIcon.alpha = 0.2;
    }
    
    if (_report.note.length > 0) {
        _noteIcon.alpha = 1.0;
    } else {
        _noteIcon.alpha = 0.2;
    }
    
    if (_report.images.count > 0 ) {
        _photoIcon.alpha = 1.0;
    } else {
        _photoIcon.alpha = 0.2;
    }
    
    if ([_report.locationChoice isEqualToString:@"current"]) {
        _mapIcon.alpha = 0.2;
        _currentIcon.alpha = 1.0;
    } else if ([_report.locationChoice isEqualToString:@"selected"]) {
        _mapIcon.alpha = 1.0;
        _currentIcon.alpha = 0.2;
    } else {
        _mapIcon.alpha = 0.2;
        _currentIcon.alpha = 0.2;
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
        
        if([[CurrentLocation sharedInstance] locationEnabled]) {
            _report.locationChoice = @"current";
            _report.selectedLocationLon = nil;
            _report.selectedLocationLat = nil;

            _mapIcon.alpha = 0.2;
            _currentIcon.alpha = 1.0;
            
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
            _actualSwitch.on = NO;
            _currentIcon.alpha = 0.2;

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tigatrapp"
                                                            message:[LocalText with:@"turn_on_location"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } else {
        _report.locationChoice = nil;
        _currentIcon.alpha = 0.2;
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
        
        if ([_report.locationChoice isEqualToString:@"was_current"]) {
            _report.locationChoice = @"current";
            _report.currentLocationLon = [NSNumber numberWithFloat:[_report.selectedLocationLon floatValue]];
            _report.currentLocationLat = [NSNumber numberWithFloat:[_report.selectedLocationLat floatValue]];
            _report.selectedLocationLon = nil;
            _report.selectedLocationLat = nil;
        }
        
        if (buttonIndex == 0) {
            if (self.sourceReport==nil) {
                if (SHOW_LOGS) NSLog(@"insertant versio %d",[_report.versionNumber intValue]);
                [[UserReports sharedInstance] addReport:_report];
            } else {
                if (SHOW_LOGS) NSLog(@"insertant versio %d",[_report.versionNumber intValue]);
                [[UserReports sharedInstance].reports removeObject:_sourceReport];
                [[UserReports sharedInstance] addReport:_report];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tigatrapp"
                                                            message:[LocalText with:@"report_sent_confirmation"]
                                                           delegate:self
                                                  cancelButtonTitle:[LocalText with:@"ok"]
                                                  otherButtonTitles:nil];
            alert.tag = THANKS_ALERT;
            [alert show];

        }
    } else if (alertView.tag == THANKS_ALERT) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Validation and send

- (BOOL) checkAnswers {
    
    BOOL fail = NO;
    
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
        fail = YES;
    }
    
    if ((_report.locationChoice==nil)
        ||([_report.locationChoice isEqualToString:@"current"] && (_report.currentLocationLat==nil))
        ||([_report.locationChoice isEqualToString:@"selected"] && (_report.selectedLocationLat==nil))) {
        check = [NSString stringWithFormat:@"%@\n%@"
                 ,check
                 ,[LocalText with:@"toast_specify_location"]];
        fail = YES;
    }
    
    if ([_report.type isEqualToString:@"site"] && [_report.images count]==0) {
        check = [NSString stringWithFormat:@"%@\n%@"
                 ,check
                 ,[LocalText with:@"toast_attach_photo"]];
        fail = YES;
    }
    
    if (fail) {
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


- (void)backControl:(id) sender {
    NSLog(@"goiing back");
}

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
    } else if ([segue.identifier isEqualToString:@"helpSegue"]) {
        HelpViewController *viewController = segue.destinationViewController;
        if ([_reportType isEqualToString:@"adult"]) {
            viewController.htmlString = [LocalText with:@"adult_report_help_html"];
        } else {
            viewController.htmlString = [LocalText with:@"site_report_help_html"];
        }
    }
}

@end
