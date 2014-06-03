//
//  MenuViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "MenuViewController.h"
#import "CurrentLocation.h"
#import "ReportViewController.h"
#import "RestApi.h"

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
    
    [[RestApi sharedInstance] init];
    
    [[CurrentLocation sharedInstance] startLocation];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Terms"]) {
        [self performSegueWithIdentifier:@"termsSegue" sender:self];
    }
    
    [[RestApi sharedInstance] callUsers];
    
    _breedingHeaderLabel.text = [LocalText with:@"switchboard_button_text_report"];
    _breedingFootLabel.text = [LocalText with:@"switchboard_button_text_sites"];
    
    _mosquitoHeaderLabel.text = [LocalText with:@"switchboard_button_text_report"];
    _mosquitoFootLabel.text = [LocalText with:@"switchboard_button_text_adult"];
    
    _mapHeaderLabel.text = [LocalText with:@"switchboard_button_text_map"];
    _mapFootLabel.text = @"";
    
    _galleryHeaderLabel.text = [LocalText with:@"switchboard_button_text_gallery"];
    _galleryFootLabel.text = @"";

}

- (void)viewWillAppear:(BOOL)animated {
    [[RestApi sharedInstance] upload];
    [[RestApi sharedInstance] status];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation


- (IBAction) pressWebButton:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://atrapaeltigre.com"]];
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
