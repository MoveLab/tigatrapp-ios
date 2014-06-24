//
//  PhotoViewController.h
//  Tigatrapp
//
//  Created by jordi on 24/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <UIKit/UIKit.h>
#import "Report.h"

@interface PhotoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic) int imageIndex;
@property (nonatomic, weak) Report *report;

-(IBAction)pressDelete:(id)sender;

@end
