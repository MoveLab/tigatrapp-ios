//
//  NoteViewController.h
//  Tigatrapp
//
//  Created by jordi on 23/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Report.h"

@interface NoteViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, weak) Report *report;


@end
