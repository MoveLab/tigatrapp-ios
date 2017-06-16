//
//  NotificationsViewController.m
//  Tigatrapp
//
//  Created by jordi on 24/6/16.
//  Copyright © 2016 ibeji. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationViewController.h"
#import "RestApi.h"
#import "FormatDate.h"

@interface NotificationsViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, weak) NSArray *currentArray;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [LocalText with:@"header_title"];
    
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray *itemsArray = @[[LocalText with:@"notifications_new"]
                            ,[LocalText with:@"notifications_old"]];

    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:itemsArray];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(pressSegmentedControl:) forControlEvents: UIControlEventValueChanged];

    self.currentArray = [RestApi sharedInstance].notificationsArray;
    
    if (SHOW_LOGS) NSLog(@"NOTIFICACIONS  : %lu i %lu", (unsigned long)[RestApi sharedInstance].notificationsArray.count, (unsigned long)[RestApi sharedInstance].ackNotificationsArray.count);
    
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segment control change

- (void) updateView {
    if (_segmentedControl.selectedSegmentIndex == 0) _currentArray = [RestApi sharedInstance].notificationsArray;
    else _currentArray = [RestApi sharedInstance].ackNotificationsArray;
    
    [self.tableView reloadData];
    
}

- (IBAction)pressSegmentedControl:(UISegmentedControl *)sender {
    [self updateView];
}


#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 44.0)];
    [_segmentedControl setFrame:CGRectMake(15, 10, 290.0, 24.0)];
    [view addSubview:_segmentedControl];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 42, 305.0, 1.0)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:line];
    
    [view setBackgroundColor:C_GRAY];
    return view;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_currentArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *entry = [_currentArray objectAtIndex:indexPath.row];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:2];
    titleLabel.text = [entry objectForKey:@"expert_comment"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    NSDate *date = [dateFormat dateFromString:[entry objectForKey:@"date_comment"]];

    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateLabel.text = [dateFormat2 stringFromDate:date];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:[LocalText with:@"back"]
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem = backButton;

    if ([[segue identifier] isEqualToString:@"notificationSegue"]) {
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *entry = [_currentArray objectAtIndex:ip.row];
        NotificationViewController *vc = [segue destinationViewController];
        vc.notification = entry;
    }
    
}


@end
