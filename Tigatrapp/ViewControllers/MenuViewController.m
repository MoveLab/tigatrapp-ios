//
//  MenuViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import "MenuViewController.h"
#import "CurrentLocation.h"
#import "ReportViewController.h"
#import "RestApi.h"
#import "PybossaViewController.h"

@interface MenuViewController ()
@end

@implementation MenuViewController

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
    
    _notificationCountLabel.layer.masksToBounds = YES;
    _notificationCountLabel.layer.cornerRadius = 18.0;
    //_missionCountLabel.layer.masksToBounds = YES;
    //_missionCountLabel.layer.cornerRadius = 18.0;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self
    //                                         selector:@selector(updateMissionsArray)
    //                                             name:@"missionsUpdated"
    //                                           object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotificationsArray)
                                                 name:@"notificationsUpdated"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateScores)
                                                 name:@"scoreUpdated"
                                               object:nil];

    
    [[CurrentLocation sharedInstance] startLocation];
    
    // han canviat els terms. Canvio crida amb un semàfor nou
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"newTerms"]) {
        [self performSegueWithIdentifier:@"termsSegue" sender:self];
    }
    
    [[RestApi sharedInstance] callUsers];
    [[RestApi sharedInstance] updateNotifications];
    //[[RestApi sharedInstance] updateMissions];
    
    
    _breedingHeaderLabel.text = [LocalText with:@"switchboard_button_text_report"];
    _breedingFootLabel.text = [LocalText with:@"switchboard_button_text_sites"];
    
    _mosquitoHeaderLabel.text = [LocalText with:@"switchboard_button_text_report"];
    _mosquitoFootLabel.text = [LocalText with:@"switchboard_button_text_adult"];
    
    _mapHeaderLabel.text = [LocalText with:@"switchboard_button_text_map"];
    _mapFootLabel.text = @"";
    
    //_galleryHeaderLabel.text = [LocalText with:@"switchboard_button_text_gallery"];
    _notificationFootLabel.text = [LocalText with:@"switchboard_button_notifications_site"];
    //_missionFootLabel.text = [LocalText with:@"switchboard_button_missions_site"];
  
    _verificationHeaderLabel.text = [LocalText with:@"switchboard_button_validations_photos"];
    _verificationFootLabel.text = [LocalText with:@"switchboard_button_validation_photos2"];
    
    _userScoreButton.backgroundColor = C_YELLOW;
    _userLevelHeaderLabel.text = [LocalText with:@"user_level_label"];
    _userScoreHeaderLabel.text = [LocalText with:@"user_score_label"];
    _userLevelLabel.text = @"";
    _userScoreButton.layer.cornerRadius = 32.0;
    [_userScoreButton setTitle:@"" forState:UIControlStateNormal];
    
    [Helper resizePortraitView:self.view];
    
}

- (void) viewWillAppear:(BOOL)animated {
    //[self updateMissionsArray];
    
    [self updateNotificationsArray];
    [[RestApi sharedInstance] upload];
    //[[RestApi sharedInstance] updateMissions];
    [[RestApi sharedInstance] updateNotifications];
    if (SHOW_LOGS) [[RestApi sharedInstance] status];
}

- (void) updateScores {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_userScoreButton setTitle:[NSString stringWithFormat:@"%d",[[RestApi sharedInstance] userScore]] forState:UIControlStateNormal];
        [_userLevelLabel setText:[LocalText with:[[RestApi sharedInstance] userScoreString]]];
    });
}

- (void) updateNotificationsArray {
    
    BOOL foundScore = NO;
    
    // actualitzo badge
    [UIApplication sharedApplication].applicationIconBadgeNumber = [RestApi sharedInstance].serverNotificationsArray.count;
    
    
    if ([self.navigationController.topViewController isEqual:self]) {
        // per evitar mutatings
        // actualitzo les taules del servidor quan estic al topviewcontroller
        [[RestApi sharedInstance].notificationsArray removeAllObjects];
        for (NSDictionary *m in [RestApi sharedInstance].serverNotificationsArray) {
            if (SHOW_LOGS) NSLog(@"Notificacio %@",m);
            if (![[RestApi sharedInstance] existsNotificationWithId:[m[@"id"] intValue]]) {
                [[RestApi sharedInstance].notificationsArray addObject:m];
                [RestApi sharedInstance].userScore = [m[@"score"] intValue];
                [RestApi sharedInstance].userScoreString = m[@"score_label"];
                foundScore = YES;
            }
        }
        [self updateNotificationsCounter:nil];
        
        if (foundScore) {
            [self updateScores];
        } else {
            [[RestApi sharedInstance] getUserScore];
        }
        
    }
    
}

/*
- (void) updateMissionsArray {
    if ([self.navigationController.topViewController isEqual:self]) {
        [[RestApi sharedInstance].missionsArray removeAllObjects];
        for (NSDictionary *m in [RestApi sharedInstance].serverMissionsArray) {
            if (![[RestApi sharedInstance] existsMissionWithId:[m[@"id"] intValue]]) {
                [[RestApi sharedInstance].missionsArray addObject:m];
            }
        }
        [self updateMissionCounter:nil];
    }
}
*/

/*
- (void) updateMissionCounter:(id) sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        int counter = (int)[[RestApi sharedInstance].missionsArray count];
        _missionCountLabel.text = [NSString stringWithFormat:@"%d",counter];
        if (SHOW_LOGS) NSLog(@"missionCounter = %d", counter);
    });
    
}
*/

- (void) updateNotificationsCounter:(id) sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        int counter = (int)[[RestApi sharedInstance].notificationsArray count];
        _notificationCountLabel.text = [NSString stringWithFormat:@"%d",counter];
        if (SHOW_LOGS) NSLog(@"notificationCounter = %d", counter);
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation


- (IBAction) pressWebButton:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[LocalText with:@"project_website"]]];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:[LocalText with:@"back"]
                                  style:UIBarButtonItemStylePlain
                                  target:nil
                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;

    if ([segue.identifier isEqualToString:@"mosquitoSegue"]) {
        ReportViewController *viewController = segue.destinationViewController;
        viewController.reportType = @"adult";
    } else if ([segue.identifier isEqualToString:@"siteSegue"]) {
        ReportViewController *viewController = segue.destinationViewController;
        viewController.reportType = @"site";
    }
    
}


@end
