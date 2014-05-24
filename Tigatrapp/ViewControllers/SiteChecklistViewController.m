//
//  SiteChecklistViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "SiteChecklistViewController.h"

@interface SiteChecklistViewController ()
@property (nonatomic, strong) NSArray *typeOfBreedingSiteArray;
@property (nonatomic, strong) NSArray *stagnantWaterArray;
@property (nonatomic, strong) NSArray *mosquitoLarvaeArray;

@end

@implementation SiteChecklistViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _typeOfBreedingSiteArray = @[@"Nothing selected",@"Embornals",@"Fonts", @"Basses artificials", @"Bidons", @"Pous", @"Altres"];
    _stagnantWaterArray = @[@"Nothing selected",@"Yes",@"No"];
    _mosquitoLarvaeArray = @[@"Nothing selected", @"Yes", @"No", @"Not sure"];
    
    _typeOfBreedingSitePickerView.tag = 10;
    _stagnantWaterPickerView.tag = 20;
    _mosquitoLarvaePickerView.tag = 30;

    [_typeOfBreedingSitePickerView setShowsSelectionIndicator:YES];
    [_stagnantWaterPickerView setShowsSelectionIndicator:YES];
    [_mosquitoLarvaePickerView setShowsSelectionIndicator:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker view data source

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 320;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *returnStr = @"";
    if (pickerView.tag == 10) {
        returnStr = [_typeOfBreedingSiteArray objectAtIndex:row];
    } else if (pickerView.tag == 20) {
        returnStr = [_stagnantWaterArray objectAtIndex:row];
    } else if (pickerView.tag == 30) {
        returnStr = [_mosquitoLarvaeArray objectAtIndex:row];
    }
    
    return returnStr;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 10) {
       return [_typeOfBreedingSiteArray count];
    } else if (pickerView.tag == 20) {
        return [_stagnantWaterArray count];
    } else if (pickerView.tag == 30) {
        return [_mosquitoLarvaeArray count];
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (IBAction)pressOK:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
