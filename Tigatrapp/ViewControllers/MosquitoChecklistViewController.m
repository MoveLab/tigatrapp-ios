//
//  MosquitoChecklistViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "MosquitoChecklistViewController.h"

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
    
    [_firstSegmentedControl setTitle:@"Sí" forSegmentAtIndex:0];
    [_firstSegmentedControl setTitle:@"No" forSegmentAtIndex:1];
    [_firstSegmentedControl setTitle:@"No ho sé" forSegmentAtIndex:2];
    [_secondSegmentedControl setTitle:@"Sí" forSegmentAtIndex:0];
    [_secondSegmentedControl setTitle:@"No" forSegmentAtIndex:1];
    [_secondSegmentedControl setTitle:@"No ho sé" forSegmentAtIndex:2];
    [_thirdSegmentedControl setTitle:@"Sí" forSegmentAtIndex:0];
    [_thirdSegmentedControl setTitle:@"No" forSegmentAtIndex:1];
    [_thirdSegmentedControl setTitle:@"No ho sé" forSegmentAtIndex:2];
    
    [_firstSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [_secondSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [_thirdSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];

    [self setInitialValueForSegmentedControl:_firstSegmentedControl withQuestion:_firstQuestionLabel.text];
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
        if ([[response valueForKey:@"answer"] isEqualToString:@"Sí"]) {
            [segmentedControl setSelectedSegmentIndex:0];
        } else if  ([[response valueForKey:@"answer"] isEqualToString:@"No"]) {
            [segmentedControl setSelectedSegmentIndex:1];
        } else if  ([[response valueForKey:@"answer"] isEqualToString:@"No ho sé"]) {
            [segmentedControl setSelectedSegmentIndex:2];
        }
    }
}

- (IBAction)pressSegment:(UISegmentedControl *)segmentedControl {

    NSString *question;
    if (segmentedControl.tag == 1) {
        question = _firstQuestionLabel.text;
    } else if (segmentedControl.tag == 2) {
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


#pragma mark - Navigation

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
