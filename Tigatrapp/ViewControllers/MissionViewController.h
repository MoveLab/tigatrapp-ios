//
//  MissionViewController.h
//  Tigatrapp
//
//  Created by jordi on 20/7/16.
//  Copyright © 2016 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissionViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSDictionary *mission;

-(IBAction)pressMoreInfo:(id)sender;
-(IBAction)pressCancel:(id)sender;
-(IBAction)pressDone:(id)sender;

@end
