//
//  MosquitoChecklistViewController.h
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Report.h"

@interface MosquitoChecklistViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *firstQuestionLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondQuestionLabel;
@property (nonatomic, weak) IBOutlet UILabel *thirdQuestionLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *firstSegmentedControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *secondSegmentedControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *thirdSegmentedControl;

@property (nonatomic, weak) Report *report;

- (IBAction)pressSegment:(UISegmentedControl *)segmentedControl;

@end
