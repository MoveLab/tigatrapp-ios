//
//  NewBreedingSiteTableViewController.h
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <UIKit/UIKit.h>
#import "Report.h"

@interface SiteChecklistViewController : UITableViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *firstQuestionLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondQuestionLabel;
@property (nonatomic, weak) IBOutlet UILabel *thirdQuestionLabel;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *secondSegmentedControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *thirdSegmentedControl;

@property (nonatomic, weak) Report *report;

- (IBAction)pressSegment:(UISegmentedControl *)segmentedControl;


@end
