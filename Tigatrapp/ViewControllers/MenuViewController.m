//
//  MenuViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "MenuViewController.h"
#import "CurrentLocation.h"
#import "RestApi.h"

@interface MenuViewController ()
@property (nonatomic, strong) UIActionSheet *actionSheet;
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
    
    [[CurrentLocation sharedInstance] startLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"images pending to upload:%d",[[RestApi sharedInstance].imagesToUpload count]);
    NSLog(@"reports pending to upload:%d",[[RestApi sharedInstance].reportsToUpload count]);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) pressMoreOptions:(id)sender {
    [_actionSheet showInView:self.view];
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //  [self FBShare];
            break;
        default:
            break;
    }
}

#pragma mark - Navigation


- (IBAction) pressWebButton:(id)sender {
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Volver"
                                  style:UIBarButtonItemStylePlain
                                  target:nil
                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;

}


@end
