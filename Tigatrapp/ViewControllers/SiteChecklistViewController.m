//
//  NewBreedingSiteTableViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "SiteChecklistViewController.h"
#import "HelpViewController.h"
#import "HelpImageViewController.h"

@interface SiteChecklistViewController ()
@property (nonatomic, strong) NSArray *pickerArray;
@end

@implementation SiteChecklistViewController
@synthesize report = _report;

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
    
    _pickerArray = @[[LocalText with:@"embornals"]
                      ,[LocalText with:@"fonts"]
                      ,[LocalText with:@"basses"]
                      ,[LocalText with:@"bidons"]
                      ,[LocalText with:@"pous"]
                      ,[LocalText with:@"altres"]];
    
    self.tableView.tableFooterView = [UIView new];
    
    _titleLabel.text = [LocalText with:@"report_checklist_title_site"];
    _firstQuestionLabel.text = [LocalText with:@"site_report_q1"];
    _secondQuestionLabel.text = [LocalText with:@"site_report_q2"];
    _thirdQuestionLabel.text = [LocalText with:@"site_report_q3"];
    
    [_secondSegmentedControl setTitle:[LocalText with:@"yes"] forSegmentAtIndex:0];
    [_secondSegmentedControl setTitle:[LocalText with:@"no"] forSegmentAtIndex:1];
    [_thirdSegmentedControl setTitle:[LocalText with:@"yes"] forSegmentAtIndex:0];
    [_thirdSegmentedControl setTitle:[LocalText with:@"no"] forSegmentAtIndex:1];
    [_thirdSegmentedControl setTitle:[LocalText with:@"dontknow"] forSegmentAtIndex:2];
    
    [_secondSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [_thirdSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    [self setInitialValueForPicker];
    [self setInitialValueForSegmentedControl:_secondSegmentedControl withQuestion:_secondQuestionLabel.text];
    [self setInitialValueForSegmentedControl:_thirdSegmentedControl withQuestion:_thirdQuestionLabel.text];
        
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ok button


- (IBAction)pressOK:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UISegmentController actions

- (void) setInitialValueForSegmentedControl:(UISegmentedControl *)segmentedControl withQuestion:(NSString *)question {
    NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"question = \"%@\""
                                                            ,question
                                                            ]];
    NSArray *responseArray = [_report.responses filteredArrayUsingPredicate:filter];
    
    if (responseArray.count > 0) {
        NSDictionary *response = [responseArray objectAtIndex:0];
        if ([[response valueForKey:@"answer"] isEqualToString:[LocalText with:@"yes"]]) {
            [segmentedControl setSelectedSegmentIndex:0];
        } else if  ([[response valueForKey:@"answer"] isEqualToString:[LocalText with:@"no"]]) {
            [segmentedControl setSelectedSegmentIndex:1];
        } else if  ([[response valueForKey:@"answer"] isEqualToString:[LocalText with:@"dontknow"]]) {
            [segmentedControl setSelectedSegmentIndex:2];
        }
    }
}

- (void) setInitialValueForPicker {
    
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"question = \"%@\""
                                                            ,[LocalText with:@"site_report_q1"]
                                                            ]];
    NSArray *responseArray = [_report.responses filteredArrayUsingPredicate:filter];
    NSLog(@"reponseArray %@",responseArray);
    
    if (responseArray.count > 0) {

        NSDictionary *response = [responseArray objectAtIndex:0];
        NSString *answer = [response objectForKey:@"answer"];
        for (int i=0; i<_pickerArray.count; i++) {
            if ([[_pickerArray objectAtIndex:i] isEqualToString:answer]) {
                [_pickerView selectRow:i inComponent:0 animated:NO];
            }
        }
    }
}

- (IBAction)pressSegment:(UISegmentedControl *)segmentedControl {
    
    NSString *question;
    if (segmentedControl.tag == 2) {
        question = _secondQuestionLabel.text;
    } else if (segmentedControl.tag == 3) {
        question = _thirdQuestionLabel.text;
    } else {
        question = @"error";
    }
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"question = \"%@\""
                                                            ,question
                                                            ]];
    NSArray *responseArray = [_report.responses filteredArrayUsingPredicate:filter];
    
    if (responseArray.count > 0) {
        [_report.responses removeObjectsInArray:responseArray];
    }
    
    NSDictionary *newResponse = @{@"question":question
                                  , @"answer":[segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]};
    [_report.responses addObject:newResponse];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Picker delegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [_pickerArray objectAtIndex:row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:C_YELLOW}];
    
    return attString;
    
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSString *question = [LocalText with:@"site_report_q1"];;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"question = \"%@\""
                                                            ,question
                                                            ]];
    NSArray *responseArray = [_report.responses filteredArrayUsingPredicate:filter];
    
    if (responseArray.count > 0) {
        [_report.responses removeObjectsInArray:responseArray];
    }
    
    NSDictionary *newResponse = @{@"question":question
                                  , @"answer":[_pickerArray objectAtIndex:row]};
    NSLog(@"response=%@",newResponse);
    [_report.responses addObject:newResponse];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerArray.count;
}

/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerArray objectAtIndex:row];
}
*/

#pragma mark - Navigation

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
        viewController.htmlString = [LocalText with:@"site_report_help_html"];
    } else if ([segue.identifier isEqualToString:@"helpQ1Segue"]) {
        HelpImageViewController *viewController = segue.destinationViewController;
        viewController.imageName = @"checklist_image_sites_1.jpg";
        viewController.caption = [LocalText with:@"site_report_item_help_1"];
    } else if ([segue.identifier isEqualToString:@"helpQ2Segue"]) {
        HelpImageViewController *viewController = segue.destinationViewController;
        viewController.imageName = @"checklist_image_sites_2.jpg";
        viewController.caption = [LocalText with:@"site_report_item_help_2"];
    } else if ([segue.identifier isEqualToString:@"helpQ3Segue"]) {
        HelpImageViewController *viewController = segue.destinationViewController;
        viewController.imageName = @"checklist_image_sites_3.jpg";
        viewController.caption = [LocalText with:@"site_report_item_help_3"];
    }
}

@end
