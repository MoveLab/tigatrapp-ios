//
//  Mosquito2ndChecklistViewController.h
//  Tigatrapp
//
//  Created by jordi on 15/7/16.
//  Copyright © 2016 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Report.h"

@interface Mosquito2ndChecklistViewController :UITableViewController

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *firstQuestionLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondQuestionLabel;
@property (nonatomic, weak) IBOutlet UILabel *thirdQuestionLabel;

@property (nonatomic, weak) IBOutlet UIButton *q11Button;
@property (nonatomic, weak) IBOutlet UIButton *q12Button;
@property (nonatomic, weak) IBOutlet UIButton *q13Button;
@property (nonatomic, weak) IBOutlet UIButton *q14Button;

@property (nonatomic, weak) IBOutlet UIButton *q21Button;
@property (nonatomic, weak) IBOutlet UIButton *q22Button;
@property (nonatomic, weak) IBOutlet UIButton *q23Button;
@property (nonatomic, weak) IBOutlet UIButton *q24Button;

@property (nonatomic, weak) IBOutlet UIButton *q31Button;
@property (nonatomic, weak) IBOutlet UIButton *q32Button;
@property (nonatomic, weak) IBOutlet UIButton *q33Button;
@property (nonatomic, weak) IBOutlet UIButton *q34Button;

@property (nonatomic, weak) IBOutlet UILabel *q11Label;
@property (nonatomic, weak) IBOutlet UILabel *q12Label;
@property (nonatomic, weak) IBOutlet UILabel *q13Label;
@property (nonatomic, weak) IBOutlet UILabel *q14Label;
@property (nonatomic, weak) IBOutlet UILabel *q21Label;
@property (nonatomic, weak) IBOutlet UILabel *q22Label;
@property (nonatomic, weak) IBOutlet UILabel *q23Label;
@property (nonatomic, weak) IBOutlet UILabel *q24Label;
@property (nonatomic, weak) IBOutlet UILabel *q31Label;
@property (nonatomic, weak) IBOutlet UILabel *q32Label;
@property (nonatomic, weak) IBOutlet UILabel *q33Label;
@property (nonatomic, weak) IBOutlet UILabel *q34Label;

@property (nonatomic, strong) Report *report;

- (IBAction)pressButton:(id)sender;

@end
