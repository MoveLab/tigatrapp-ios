//
//  ValidateHelp22ViewController.m
//  Tigatrapp
//
//  Created by jordi on 10/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import "ValidateHelp22ViewController.h"
#import "RestApi.h"
#import "LocalText.h"

@interface ValidateHelp22ViewController ()

@end

@implementation ValidateHelp22ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.title = [LocalText with:@"back"];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    _titleLabel.text = [LocalText with:@"header_title"];
    _mosquitoLabel.text = [LocalText with:@"i18n_tiger"];
    _latinLabel.text = [NSString stringWithFormat:@"(%@)",[LocalText with:@"i18n_latin_tiger"]];
    _textLabel.text = [LocalText with:@"i18n_whitestripes"];
    _text2Label.text = [LocalText with:@"i18n_whitelinehead"];
    _text3Label.text = [LocalText with:@"i18n_stripedlegs"];
    _exampleLabel.text = [LocalText with:@"i18n_examples"];
    _toraxLabel.text = [LocalText with:@"i18n_thorax"];
    _abdomenLabel.text = [LocalText with:@"i18n_abdomen"];
    [_doneButton setTitle:[LocalText with:@"i18n_ok2"] forState:UIControlStateNormal];
    [_doneButton setTitleColor:C_YELLOW forState:UIControlStateNormal];
    _doneButton.layer.borderColor = C_GRAYLINE.CGColor;
    _doneButton.layer.borderWidth = 1.0;
    [Helper resizePortraitView:self.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
