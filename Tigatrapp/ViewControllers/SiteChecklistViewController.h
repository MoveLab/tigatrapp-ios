//
//  SiteChecklistViewController.h
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiteChecklistViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIPickerView *typeOfBreedingSitePickerView;
@property (nonatomic, weak) IBOutlet UIPickerView *stagnantWaterPickerView;
@property (nonatomic, weak) IBOutlet UIPickerView *mosquitoLarvaePickerView;

@property (nonatomic, strong) NSDictionary *currentReport;

- (IBAction)pressOK:(id)sender;

@end
