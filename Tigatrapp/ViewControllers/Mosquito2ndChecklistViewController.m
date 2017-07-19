//
//  Mosquito2ndChecklistViewController.m
//  Tigatrapp
//
//  Created by jordi on 15/7/16.
//  Copyright © 2016 ibeji. All rights reserved.
//

#import "Mosquito2ndChecklistViewController.h"
#import "HelpViewController.h"
#import "HelpImageViewController.h"

@interface Mosquito2ndChecklistViewController ()
@property (nonatomic, strong) NSArray *answersArray; // [question][value answer]
@property (nonatomic, strong) NSArray *labelsArray; // [question][label]
@property (nonatomic, strong) NSArray *buttonsArray; // [question][button]
@property (nonatomic, strong) NSArray *questionArray; // [question]
@end

@implementation Mosquito2ndChecklistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.questionArray = @[[LocalText with:@"confirmation_q1_adult_sizecolor"]
                           ,[LocalText with:@"confirmation_q2_adult_headthorax"]
                           ,[LocalText with:@"adult_report_q3"]];
    
    self.answersArray = @[@[[LocalText with:@"adult_report_q1a1"]
                            ,[LocalText with:@"adult_report_q1a2"]
                            ,[LocalText with:@"adult_report_q1a3"]
                            ,[LocalText with:@"adult_report_q1a4"]]
                          ,@[[LocalText with:@"adult_report_q2a1"]
                            ,[LocalText with:@"adult_report_q2a2"]
                            ,[LocalText with:@"adult_report_q2a3"]
                            ,[LocalText with:@"adult_report_q2a4"]]
                          ,@[[LocalText with:@"adult_report_q3a1"]
                             ,[LocalText with:@"adult_report_q3a2"]
                             ,[LocalText with:@"adult_report_q3a3"]
                             ,[LocalText with:@"adult_report_q3a4"]]];
    
    self.labelsArray = @[@[_q11Label, _q12Label, _q13Label, _q14Label]
                         ,@[_q21Label, _q22Label, _q23Label, _q24Label]
                         ,@[_q31Label, _q32Label, _q33Label, _q34Label]];
    
    self.buttonsArray = @[@[_q11Button, _q12Button, _q13Button, _q14Button]
                          ,@[_q21Button, _q22Button, _q23Button, _q24Button]
                          ,@[_q31Button, _q32Button, _q33Button, _q34Button]];
    
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

    _titleLabel.text = [LocalText with:@"report_checklist_title_adult"];
    _firstQuestionLabel.text = _questionArray[0];
    _secondQuestionLabel.text = _questionArray[1];
    _thirdQuestionLabel.text = _questionArray[2];
 
    // valors d'entrada
    
    if (_report.answer1 != nil) {
        if ([_report.answer1 intValue] == 0) [_q11Button setSelected:YES];
        if ([_report.answer1 intValue] == 1) [_q12Button setSelected:YES];
        if ([_report.answer1 intValue] == 2) [_q13Button  setSelected:YES];
        if ([_report.answer1 intValue] == 3) [_q14Button  setSelected:YES];
    }
    if (_report.answer2 != nil) {
        if ([_report.answer2 intValue] == 0) [_q21Button setSelected:YES];
        if ([_report.answer2 intValue] == 1) [_q22Button setSelected:YES];
        if ([_report.answer2 intValue] == 2) [_q23Button  setSelected:YES];
        if ([_report.answer2 intValue] == 3) [_q24Button  setSelected:YES];
    }
    if (_report.answer3 != nil) {
        if ([_report.answer3 intValue] == 0) [_q31Button  setSelected:YES];
        if ([_report.answer3 intValue] == 1) [_q32Button  setSelected:YES];
        if ([_report.answer3 intValue] == 2) [_q33Button  setSelected:YES];
        if ([_report.answer3 intValue] == 3) [_q34Button  setSelected:YES];
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

    [_report.responses removeAllObjects];
    
    for (int i=0; i<_answersArray.count; i++) {
        int indexSelected = [self renewAnswersAtIndex:i];
        if (indexSelected >= 0) {
            NSDictionary *response = @{@"question":_questionArray[i]
                                       , @"answer":_answersArray[i][indexSelected]};
            [_report.responses addObject:response];
            if (i==0) _report.answer1 = [NSNumber numberWithInt:indexSelected];
            if (i==1) _report.answer2 = [NSNumber numberWithInt:indexSelected];
            if (i==2) _report.answer3 = [NSNumber numberWithInt:indexSelected];
            
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
    
    NSString *local = [LocalText currentLoc];
    NSString *sufix = ([local isEqualToString:@"ca"] ? @"CAT" : ([local isEqualToString:@"es"] ? @"ESP" : @"ENG" ));
    
    if ([segue.identifier isEqualToString:@"helpQ1Segue"]) {
        HelpImageViewController *viewController = segue.destinationViewController;
        //viewController.imageName = @"checklist_image_adult_1.jpg";
        NSString *imageName = [NSString stringWithFormat:@"Aedes_Help1_%@.png", sufix ];
        //NSLog(@"sufix %@ imageName %@", sufix,imageName);
        viewController.imageName = imageName;
        viewController.caption = [LocalText with:@"q1_sizecolor_text_help"];
    } else if ([segue.identifier isEqualToString:@"helpQ2Segue"]) {
        HelpImageViewController *viewController = segue.destinationViewController;
        //viewController.imageName = nil;
        //viewController.imageName = @"checklist_image_adult_2.jpg";
        viewController.imageName = [NSString stringWithFormat:@"Aedes_Help2_%@.png", sufix ];
        viewController.caption = [LocalText with:@"q2_headthorax_text_help"];
    } else if ([segue.identifier isEqualToString:@"helpQ3Segue"]) {
        HelpImageViewController *viewController = segue.destinationViewController;
        //viewController.imageName = @"checklist_image_adult_3.jpg";
        viewController.imageName = [NSString stringWithFormat:@"Aedes_Help3_%@.png", sufix ];
        viewController.caption = [LocalText with:@"q3_abdomenlegs_text"];
    }
}


@end
