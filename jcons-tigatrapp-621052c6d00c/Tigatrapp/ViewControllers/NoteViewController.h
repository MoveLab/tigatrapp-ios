//
//  NoteViewController.h
//  Tigatrapp
//
//  Created by jordi on 23/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <UIKit/UIKit.h>
#import "Report.h"

@interface NoteViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, weak) Report *report;


@end
