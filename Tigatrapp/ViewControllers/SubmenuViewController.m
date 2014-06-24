//
//  SubmenuViewController.m
//  Tigatrapp
//
//  Created by jordi on 22/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import "SubmenuViewController.h"
#import "HelpViewController.h"

@interface SubmenuViewController ()

@end

@implementation SubmenuViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.tableView.tableFooterView = [UIView new];
    
    _menuLabel.text = [LocalText with:@"menu"];
    _newsLabel.text = [LocalText with:@"menu_option_tigatrapp_news"];
    _helpLabel.text = [LocalText with:@"menu_option_help"];
    _aboutLabel.text = [LocalText with:@"menu_option_about"];
    _shareLabel.text = [LocalText with:@"menu_option_share"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    if (indexPath.row == 4) {
        NSArray *activityItems;
        activityItems = @[@"http://atrapaeltrigre.com"];
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc]
         initWithActivityItems:activityItems
         applicationActivities:nil];
        
        [self presentViewController:activityController animated:YES completion:nil];
        
    }
}

#pragma mark - Navigation

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
    
    if ([segue.identifier isEqualToString:@"helpSegue"]) {
        HelpViewController *viewController = segue.destinationViewController;
        viewController.urlString = [NSString stringWithFormat:@"http://tigaserver.atrapaeltigre.com/help/ios/%@/",[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0]];
        
    } else if ([segue.identifier isEqualToString:@"aboutSegue"]) {
        HelpViewController *viewController = segue.destinationViewController;
        viewController.urlString = [NSString stringWithFormat:@"http://tigaserver.atrapaeltigre.com/about/ios/%@/",[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0]];
        viewController.fallbackFile = [NSString stringWithFormat:@"about_%@",[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] ];
    }


}


@end
