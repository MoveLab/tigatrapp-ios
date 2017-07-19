//
//  MissionsViewController.m
//  Tigatrapp
//
//  Created by jordi on 19/4/16.
//  Copyright © 2016 ibeji. All rights reserved.
//

#import "MissionsViewController.h"
#import "MissionViewController.h"
#import "RestApi.h"
#import "LocalText.h"

@interface MissionsViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, weak) NSMutableArray *currentArray;
@end

@implementation MissionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [LocalText with:@"header_title"];
    
    NSArray *itemsArray = @[[LocalText with:@"task_list_pending"]
                            ,[LocalText with:@"task_list_completed"]];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:itemsArray];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(pressSegmentedControl:) forControlEvents: UIControlEventValueChanged];
    
    self.currentArray =  [RestApi sharedInstance].missionsArray;
    
    [Helper resizePortraitView:self.view];

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
    if (_segmentedControl.selectedSegmentIndex == 0) _currentArray = [RestApi sharedInstance].missionsArray;
    else _currentArray = [RestApi sharedInstance].ackMissionsArray;
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"missionCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *entry = [_currentArray objectAtIndex:indexPath.row];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:2];
    
    
    NSString *text = ([[LocalText currentLoc] isEqualToString:@"ca"]? entry[@"short_description_catalan"]
                      : ([[LocalText currentLoc] isEqualToString:@"es"]? entry[@"short_description_spanish"] : entry[@"short_description_english"]));
    titleLabel.text = text;
    
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (entry[@"expiration_time"] == [NSNull null]) {
            dateLabel.text = @"";
        } else {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
            NSDate *date = [dateFormat dateFromString:entry[@"expiration_time"]];
            
            NSDateFormatter *publishDateFormat = [[NSDateFormatter alloc] init];
            [publishDateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
            dateLabel.text = [NSString stringWithFormat:@"%@ %@",[LocalText with:@"task_expires"],[publishDateFormat stringFromDate:date]];
            
        }
        
    } else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        
    }
    
    

    
    
    /*
    @try
    {
        NSString *dateString = [entry objectForKey:@"expiration_time"];
        NSDate *date = [dateFormat dateFromString:dateString];
        
        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
        [dateFormat2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateLabel.text = [dateFormat2 stringFromDate:date];
    }
    @catch (NSException *exception)
    {
        dateLabel.text = @"";
    }
    */
    return cell;
}



 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
     // Return NO if you do not want the specified item to be editable.
     return YES;
 }



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSDictionary *entry = [_currentArray objectAtIndex:indexPath.row];
        [[RestApi sharedInstance].deletedMissionsArray addObject:entry];
        [_currentArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[RestApi sharedInstance] saveAckMissionsToUserDefaults ];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"missionSegue"]) {
        // perform your computation to determine whether segue should occur
        
        if (_segmentedControl.selectedSegmentIndex > 0 ) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:[LocalText with:@"header_title"]
                                         message:[LocalText with:@"toast__mission_already_complete"]
                                         delegate:nil
                                         cancelButtonTitle:[LocalText with:@"ok"]
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            // prevent segue from occurring
            return NO;
        }
    }
    
    // by default perform the segue transition
    return YES;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"missionSegue"]) {
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        NSDictionary *entry = [_currentArray objectAtIndex:ip.row];
        MissionViewController *vc = [segue destinationViewController];
        vc.mission = entry;
    }
    
}

@end
