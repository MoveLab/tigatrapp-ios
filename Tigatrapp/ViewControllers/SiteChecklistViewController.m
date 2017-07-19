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
@property (nonatomic, strong) NSArray *answersArray; // [question][value answer]
@property (nonatomic, strong) NSArray *labelsArray; // [question][label]
@property (nonatomic, strong) NSArray *buttonsArray; // [question][button]
@property (nonatomic, strong) NSArray *questionArray; // [question]
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
    
    self.questionArray = @[[LocalText with:@"site_report_q1"]
                           ,[LocalText with:@"site_report_q2"]
                           ,[LocalText with:@"site_report_q3"]
                           ,[LocalText with:@"site_report_q4"]];
    
    self.answersArray = @[@[[LocalText with:@"yes"]
                            ,[LocalText with:@"no"]]
                          ,@[[LocalText with:@"yes"]
                             ,[LocalText with:@"no"]]
                          ,@[[LocalText with:@"site_report_q3_response1"]
                             ,[LocalText with:@"site_report_q3_response2"]
                             ,[LocalText with:@"site_report_q3_response3"]]
                          ,@[[LocalText with:@"yes"]
                             ,[LocalText with:@"no"]]];
    
    self.labelsArray = @[@[_q11Label, _q12Label]
                         ,@[_q21Label, _q22Label]
                         ,@[_q31Label, _q32Label, _q33Label]
                         ,@[_q41Label, _q42Label]];
    
    self.buttonsArray = @[@[_q11Button, _q12Button]
                         ,@[_q21Button, _q22Button]
                         ,@[_q31Button, _q32Button, _q33Button]
                         ,@[_q41Button, _q42Button]];
   
    for (int i=0; i< _buttonsArray.count; i++) {
        NSArray *a = _buttonsArray[i];
        for (int j=0; j< a.count; j++) {
            UIButton *b = _buttonsArray[i][j];
            b.tag = (i+1)*10 + (j+1);
            [b setImage:[UIImage imageNamed:@"on"] forState:UIControlStateSelected];
            [b setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [b setSelected:NO];
            
            UILabel *l = _labelsArray[i][j];
            l.text = _answersArray[i][j];
        }
    }
    

    self.tableView.tableFooterView = [UIView new];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];

    _titleLabel.text = [LocalText with:@"report_checklist_title_site"];
    _firstQuestionLabel.text = _questionArray[0];
    _secondQuestionLabel.text = _questionArray[1];
    _thirdQuestionLabel.text = _questionArray[2];
    _fourthQuestionLabel.text = _questionArray[3];
    

    if (_report.answer1 != nil ) {
        // tots els sites que no son embornals son altres
        if ([_report.answer1 intValue] > 1) _report.answer1 = [NSNumber numberWithInteger:1];
        
        if ([_report.answer1 intValue] == 0) [_q11Button setSelected:YES];
        if ([_report.answer1 intValue] == 1) [_q12Button setSelected:YES];

    }
    
    if (_report.answer2 != nil ) {
        if ([_report.answer2 intValue] == 0) [_q21Button setSelected:YES];
        if ([_report.answer2 intValue] == 1) [_q22Button setSelected:YES];
    }

    if (_report.answer3 != nil ) {
        if ([_report.answer3 intValue] == 0) [_q31Button  setSelected:YES];
        if ([_report.answer3 intValue] == 1) [_q32Button  setSelected:YES];
        if ([_report.answer3 intValue] == 2) [_q33Button  setSelected:YES];
    }

    if (_report.answer4 != nil ) {
        // la resposta no ho se passa a no
        if ([_report.answer4 intValue] > 1) _report.answer4 = [NSNumber numberWithInteger:1];

        if ([_report.answer4 intValue] == 0) [_q41Button  setSelected:YES];
        if ([_report.answer4 intValue] == 1) [_q42Button  setSelected:YES];
    }

    [Helper resizePortraitView:self.view];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - renew responses

- (int) renewAnswersAtIndex:(int)index {
    
    NSArray *arr = _buttonsArray[index];
    for (int i=0; i<arr.count; i++) {
        UIButton *b = _buttonsArray[index][i];
        if (b.isSelected) {
            return i;
        }
    }
    return -1;
}


- (void) renewResponses {
    // en bloc per evitar problemes amb els idiomes

    

    [_report.responses removeAllObjects];
    
    for (int i=0; i<_answersArray.count; i++) {
       int indexSelected = [self renewAnswersAtIndex:i];

        if (indexSelected>=0) {
            NSDictionary *response = @{@"question":_questionArray[i]
                                       , @"answer":_answersArray[i][indexSelected]};
            [_report.responses addObject:response];
            if (i==0) _report.answer1 = [NSNumber numberWithInt:indexSelected];
            if (i==1) _report.answer2 = [NSNumber numberWithInt:indexSelected];
            if (i==2) _report.answer3 = [NSNumber numberWithInt:indexSelected];
            if (i==3) _report.answer4 = [NSNumber numberWithInt:indexSelected];
        }
        
    }
        
}


- (IBAction)pressButton:(UIButton *)sender {
    
    int grup = ((int)sender.tag / 10)-1;
    
    for (UIButton *b in _buttonsArray[grup]) {
        b.selected = NO;
    }
    sender.selected = YES;
    
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIBarButtonItems actions

- (IBAction) pressCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) pressSave:(id)sender {
    [self renewResponses];
    [self.navigationController popViewControllerAnimated:YES];
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
        viewController.imageName = nil;
        viewController.caption = [LocalText with:@"site_report_item_help_2"];
    } else if ([segue.identifier isEqualToString:@"helpQ3Segue"]) {
        HelpImageViewController *viewController = segue.destinationViewController;
        viewController.imageName = @"checklist_image_sites_3.jpg";
        viewController.caption = [LocalText with:@"site_report_item_help_3"];
    } else if ([segue.identifier isEqualToString:@"helpQ4Segue"]) {
        HelpImageViewController *viewController = segue.destinationViewController;
        viewController.imageName = nil;
        viewController.caption = [LocalText with:@"site_report_item_help_4"];
    }
}

@end
