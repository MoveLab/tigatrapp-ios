//
//  NewBreedingSiteTableViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
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
    
    if (_report.answer1) [_pickerView selectRow:[_report.answer1 intValue] inComponent:0 animated:NO];
    if (_report.answer2) [_secondSegmentedControl setSelectedSegmentIndex:[_report.answer2 intValue]];
    if (_report.answer3) [_thirdSegmentedControl setSelectedSegmentIndex:[_report.answer3 intValue]];
    
    //[self setInitialValueForPicker];
    //[self setInitialValueForSegmentedControl:_secondSegmentedControl withQuestion:_secondQuestionLabel.text];
    //[self setInitialValueForSegmentedControl:_thirdSegmentedControl withQuestion:_thirdQuestionLabel.text];
        
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


- (void) renewResponses {
    // en bloc per evitar problemes amb els idiomes
    
    [_report.responses removeAllObjects];
    
    _report.answer1 = [NSNumber numberWithInt:(int)[_pickerView selectedRowInComponent:0]];
    NSDictionary *response1 = @{@"question":_firstQuestionLabel.text
                                , @"answer":[_pickerArray objectAtIndex:[_pickerView selectedRowInComponent:0]]};
    [_report.responses addObject:response1];
    
    if ([_secondSegmentedControl selectedSegmentIndex] != UISegmentedControlNoSegment) {
        _report.answer2 = [NSNumber numberWithInt:(int)_secondSegmentedControl.selectedSegmentIndex];
        NSDictionary *response2 = @{@"question":_secondQuestionLabel.text
                                    , @"answer":[_secondSegmentedControl titleForSegmentAtIndex:_secondSegmentedControl.selectedSegmentIndex]};
        [_report.responses addObject:response2];
        
    }
    
    if ([_thirdSegmentedControl selectedSegmentIndex ] != UISegmentedControlNoSegment) {
        _report.answer3 = [NSNumber numberWithInt:(int)_thirdSegmentedControl.selectedSegmentIndex];
        NSDictionary *response3 = @{@"question":_thirdQuestionLabel.text
                                    , @"answer":[_thirdSegmentedControl titleForSegmentAtIndex:_thirdSegmentedControl.selectedSegmentIndex]};
        [_report.responses addObject:response3];
    }
    
}



#pragma mark - UISegmentController actions


- (IBAction)pressSegment:(UISegmentedControl *)segmentedControl {
    [self renewResponses];
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
    [self renewResponses];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerArray.count;
}

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
    
    if ([segue.identifier isEqualToString:@"helpQ1Segue"]) {
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
