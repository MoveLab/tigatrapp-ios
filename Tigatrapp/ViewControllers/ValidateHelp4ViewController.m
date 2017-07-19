//
//  ValidateHelp4ViewController.m
//  Tigatrapp
//
//  Created by jordi on 10/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import "ValidateHelp4ViewController.h"

@interface ValidateHelp4ViewController ()

@end

@implementation ValidateHelp4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LocalText with:@"back"];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];

    _titleLabel.text = [LocalText with:@"i18n_whichparts"];
    _textLabel.text = [LocalText with:@"i18n_markparts"];
    _subtitleLabel.text = [LocalText with:@"i18n_abdomen2"];
    _tigerLabel.text = [LocalText with:@"i18n_tigermosquito"];
    _yellowLabel.text = [LocalText with:@"i18n_yellowfever2"];
    [_doneButton setTitle:[LocalText with:@"i18n_understood"] forState:UIControlStateNormal];
    [_doneButton setTitleColor:C_YELLOW forState:UIControlStateNormal];
    _doneButton.layer.borderColor = C_GRAYLINE.CGColor;
    _doneButton.layer.borderWidth = 1.0;
    [Helper resizePortraitView:self.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressDone:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
