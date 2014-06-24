//
//  PickPhotoViewController.h
//  Tigatrapp
//
//  Created by jordi on 24/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <UIKit/UIKit.h>
#import "Report.h"

@interface PickPhotoViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIButton *pickPhotoButton;
@property (nonatomic, weak) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, weak) Report *report;

-(IBAction) takePhoto:(id) sender;
-(IBAction) pickPhoto:(id) sender;

@end
