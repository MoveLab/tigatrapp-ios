//
//  MosquitoChecklistViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import "MosquitoChecklistViewController.h"
#import "HelpViewController.h"
#import "HelpImageViewController.h"

@interface MosquitoChecklistViewController ()


@end

@implementation MosquitoChecklistViewController
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
    
    self.tableView.tableFooterView = [UIView new];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];

    _titleLabel.text = [LocalText with:@"report_checklist_title_adult"];
    _firstQuestionLabel.text = [LocalText with:@"confirmation_q1_adult_sizecolor"];
    _secondQuestionLabel.text = [LocalText with:@"confirmation_q2_adult_headthorax"];
    _thirdQuestionLabel.text = [LocalText with:@"adult_report_q3"];
    
    [_firstSegmentedControl setTitle:[LocalText with:@"yes"] forSegmentAtIndex:0];
    [_firstSegmentedControl setTitle:[LocalText with:@"no"] forSegmentAtIndex:1];
    [_firstSegmentedControl setTitle:[LocalText with:@"dontknow"] forSegmentAtIndex:2];
    [_secondSegmentedControl setTitle:[LocalText with:@"yes"] forSegmentAtIndex:0];
    [_secondSegmentedControl setTitle:[LocalText with:@"no"] forSegmentAtIndex:1];
    [_secondSegmentedControl setTitle:[LocalText with:@"dontknow"] forSegmentAtIndex:2];
    [_thirdSegmentedControl setTitle:[LocalText with:@"yes"] forSegmentAtIndex:0];
    [_thirdSegmentedControl setTitle:[LocalText with:@"no"] forSegmentAtIndex:1];
    [_thirdSegmentedControl setTitle:[LocalText with:@"dontknow"] forSegmentAtIndex:2];
    
    [_firstSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [_secondSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [_thirdSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    if (_report.answer1) [_firstSegmentedControl setSelectedSegmentIndex:[_report.answer1 intValue]];
    if (_report.answer2) [_secondSegmentedControl setSelectedSegmentIndex:[_report.answer2 intValue]];
    if (_report.answer3) [_thirdSegmentedControl setSelectedSegmentIndex:[_report.answer3 intValue]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ok button


- (void) renewResponses {
    // en bloc per evitar problemes amb els idiomes
    
    [_report.responses removeAllObjects];
    
    if ([_firstSegmentedControl selectedSegmentIndex] != UISegmentedControlNoSegment) {
        _report.answer1 = [NSNumber numberWithLong:_firstSegmentedControl.selectedSegmentIndex];
        NSDictionary *response1 = @{@"question":_firstQuestionLabel.text
                                    , @"answer":[_firstSegmentedControl titleForSegmentAtIndex:_firstSegmentedControl.selectedSegmentIndex]};
        [_report.responses addObject:response1];
    }
    
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

#pragma mark - UIBarButtonItems actions

- (IBAction) pressCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) pressSave:(id)sender {
    [self renewResponses];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISegmentController actions


- (IBAction)pressSegment:(UISegmentedControl *)segmentedControl {
   // [self renewResponses];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
     
    if ([segue.identifier isEqualToString:@"helpSegueQ1"]) {
        HelpImageViewController *viewController = segue.destinationViewController;
        viewController.imageName = @"checklist_image_adult_1.jpg";
        viewController.caption = [LocalText with:@"q1_sizecolor_text"];
    } else if ([segue.identifier isEqualToString:@"helpSegueQ2"]) {
        HelpImageViewController *viewController = segue.destinationViewController;
        viewController.imageName = @"checklist_image_adult_2.jpg";
        viewController.caption = [LocalText with:@"q3_headthorax_text"];
    } else if ([segue.identifier isEqualToString:@"helpSegueQ3"]) {
        HelpImageViewController *viewController = segue.destinationViewController;
        viewController.imageName = @"checklist_image_adult_3.jpg";
        viewController.caption = [LocalText with:@"q2_abdomenlegs_text"];
    }
}

@end
