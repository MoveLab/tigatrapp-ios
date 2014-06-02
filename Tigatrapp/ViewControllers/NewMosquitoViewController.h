//
//  NewMosquitoViewController.h
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Report.h"

@interface NewMosquitoViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UILabel *reportarMosquitoLabel;
@property (nonatomic, weak) IBOutlet UILabel *checklistLabel;
@property (nonatomic, weak) IBOutlet UILabel *localizacionLabel;
@property (nonatomic, weak) IBOutlet UILabel *actualLabel;
@property (nonatomic, weak) IBOutlet UISwitch *actualSwitch;
@property (nonatomic, weak) IBOutlet UILabel *seleccionarEnElMapaLabel;
@property (nonatomic, weak) IBOutlet UILabel *informacionAdicionalLabel;
@property (nonatomic, weak) IBOutlet UILabel *hacerUnaFotografiaLabel;
@property (nonatomic, weak) IBOutlet UILabel *numberOfImagesLabel;
@property (nonatomic, weak) IBOutlet UILabel *notaLabel;
@property (nonatomic, weak) IBOutlet UIButton *enviarButton;

@property (nonatomic, strong) Report *report;
@property (nonatomic, strong) Report *sourceReport;

-(IBAction)pressSwitch:(id)sender;
-(IBAction)pressSend:(id)sender;
-(IBAction)pressDelete:(id)sender;

@end
