//
//  GalleryViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import "GalleryViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

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

    NSArray *imagesArray = @[@"a.jpg",@"b.jpg",@"c.jpg",@"d.jpg",@"e.jpg",@"f.jpg",@"g.jpg"
                             ,@"h.jpg",@"i.jpg",@"j.jpg",@"k.jpg",@"l.jpg"];
    NSArray *labelsArray = @[@"gallery_array0",@"gallery_array1",@"gallery_array2",@"gallery_array3",@"gallery_array4"
                             ,@"gallery_array5",@"gallery_array6",@"gallery_array7",@"gallery_array8"
                             ,@"gallery_array9",@"gallery_array10",@"gallery_array11"];
    
    _pageControl.numberOfPages = imagesArray.count;
    
    float scrollviewWidth = _scrollView.frame.size.width;
    float scrollviewHeight = _scrollView.frame.size.height-100.0;
    
    if (SHOW_LOGS) NSLog(@"Draw Scrollview width=%f height=%f", scrollviewWidth,scrollviewHeight);
    
    _scrollView.contentSize = CGSizeMake(scrollviewWidth*imagesArray.count, scrollviewHeight);
    _scrollView.scrollsToTop = YES;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    
    for (int i=0; i<imagesArray.count; i++) {

        UIView *pageView = [[UIView alloc]  initWithFrame:CGRectMake(scrollviewWidth*i,0.0,scrollviewWidth,scrollviewHeight)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0,20.0,scrollviewWidth-40.0,200.0)];
        imageView.image = [UIImage imageNamed:[imagesArray objectAtIndex:i]];
        [pageView addSubview:imageView];
        
        //UILabel *credit = [[UILabel alloc] initWithFrame:CGRectMake(20.0,0.0,scrollviewWidth-40.0,18.0)];
        //credit.numberOfLines = 0;
        //credit.textAlignment = NSTextAlignmentRight;
        //credit.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
        //credit.text = [LocalText with:@"photo_credit_gallery"];
        //[pageView addSubview:credit];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0,230.0,scrollviewWidth-40.0,scrollviewHeight-200.0)];
        
        
        NSString *theString = [LocalText with:[labelsArray objectAtIndex:i]];

        theString = [theString stringByReplacingOccurrencesOfString:@" +" withString:@" "
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange(0, theString.length)];
        theString = [theString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];

        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[theString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        label.attributedText = attrStr;
        label.font = [UIFont fontWithName:@"Futura-Medium" size:15.0];
        label.numberOfLines = 0;
        [label sizeToFit];
        [pageView addSubview:label];
        
        [_scrollView addSubview:pageView];
    }
}

#pragma mark - scrollview delegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float pageWidth = _scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    long page = lround(fractionalPage);
    [self.pageControl setCurrentPage:(int)page];
}

#pragma mark - page control

- (IBAction)pressChangePage:(UIPageControl *) pageControl {

    float scrollviewWidth = _scrollView.frame.size.width;
    [_scrollView scrollRectToVisible:CGRectMake(scrollviewWidth*pageControl.currentPage
                                                , 0.0, scrollviewWidth, 1.0) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
