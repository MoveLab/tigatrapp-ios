//
//  PybossaViewController.m
//  Tigatrapp
//
//  Created by jordi on 19/5/16.
//  Copyright © 2016 ibeji. All rights reserved.
//

#import "PybossaViewController.h"

@interface PybossaViewController ()

@end

@implementation PybossaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = [LocalText with:@"header_title"];
    
    /*
    _urlString = [NSString stringWithFormat:@"http://crowdcrafting.org/project/mosquito-alert/newtask?lang=%@&timestamp=%.0f"
                  ,[LocalText currentLoc]
                  ,[[NSDate date] timeIntervalSince1970] * 1000];
    */
    _urlString = [NSString stringWithFormat:@"http://mosquitoalert.pybossa.com/project/mosquito-alert/newtask?lang=%@&timestamp=%.0f"
                  ,[LocalText currentLoc]
                  ,[[NSDate date] timeIntervalSince1970] * 1000];

    
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
    [Helper resizePortraitView:self.view];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebView delegate

/*
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}
*/
/*
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:_urlString]) {
        [_webView loadHTMLString:[[NSUserDefaults standardUserDefaults] objectForKey:_urlString]
                         baseURL:nil];
    } else if (_fallbackFile) {
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:_fallbackFile ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:htmlString baseURL:nil];
    }
}
*/

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //NSLog(@"webview did finish load %@",_urlString);
    [self.webView.scrollView setScrollEnabled:YES];
    [self.webView.scrollView setAlwaysBounceVertical:NO];
    [self.webView.scrollView setAlwaysBounceHorizontal:NO];
    [self.webView.scrollView setBounces:NO];

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
