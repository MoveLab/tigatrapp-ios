//
//  NewBreedingSiteTableViewController.h
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <UIKit/UIKit.h>
#import "Report.h"

@interface SiteChecklistViewController : UITableViewController 

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *firstQuestionLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondQuestionLabel;
@property (nonatomic, weak) IBOutlet UILabel *thirdQuestionLabel;
@property (nonatomic, weak) IBOutlet UILabel *fourthQuestionLabel;

@property (nonatomic, weak) IBOutlet UIButton *q11Button;
@property (nonatomic, weak) IBOutlet UIButton *q12Button;
@property (nonatomic, weak) IBOutlet UIButton *q21Button;
@property (nonatomic, weak) IBOutlet UIButton *q22Button;
@property (nonatomic, weak) IBOutlet UIButton *q31Button;
@property (nonatomic, weak) IBOutlet UIButton *q32Button;
@property (nonatomic, weak) IBOutlet UIButton *q33Button;
@property (nonatomic, weak) IBOutlet UIButton *q41Button;
@property (nonatomic, weak) IBOutlet UIButton *q42Button;

@property (nonatomic, weak) IBOutlet UILabel *q11Label;
@property (nonatomic, weak) IBOutlet UILabel *q12Label;
@property (nonatomic, weak) IBOutlet UILabel *q21Label;
@property (nonatomic, weak) IBOutlet UILabel *q22Label;
@property (nonatomic, weak) IBOutlet UILabel *q31Label;
@property (nonatomic, weak) IBOutlet UILabel *q32Label;
@property (nonatomic, weak) IBOutlet UILabel *q33Label;
@property (nonatomic, weak) IBOutlet UILabel *q41Label;
@property (nonatomic, weak) IBOutlet UILabel *q42Label;

@property (nonatomic, strong) Report *report;

- (IBAction)pressButton:(id)sender;


@end
