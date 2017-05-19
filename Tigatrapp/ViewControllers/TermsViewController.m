//
//  TermsViewController.m
//  Tigatrapp
//
//  Created by jordi on 02/06/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import "TermsViewController.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [LocalText with:@"header_title"];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];

    
    _acceptLabel.text = [LocalText with:@"consent_button_label"];
    _denyLabel.text = [LocalText with:@"decline_button_label"];

    [self.webView setBackgroundColor:[UIColor clearColor]];
   // NSString *filename = [NSString stringWithFormat:@"consent_%@",[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] ];
    NSString *filename = [NSString stringWithFormat:@"consent_%@",[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] ];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:filename ofType:@"html"];
    
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressAccept:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"newTerms"];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (IBAction)pressDeny:(id)sender {
    exit(0);
}

#pragma mark - UIWebView delegate

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
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
