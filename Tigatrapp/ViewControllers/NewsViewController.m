//
//  NewsViewController.m
//  Tigatrapp
//
//  Created by jordi on 02/06/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "NewsViewController.h"
#import "FormatDate.h"

@interface NewsViewController ()
@property (nonatomic,strong) NSXMLParser *parser;
@property (nonatomic,strong) NSMutableArray *feeds;
@property (nonatomic,strong) NSMutableDictionary *item;
@property (nonatomic,strong) NSMutableString *thetitle;
@property (nonatomic,strong) NSMutableString *link;
@property (nonatomic,strong) NSMutableString *pubDate;
@property (nonatomic,strong) NSString *element;
@end

@implementation NewsViewController

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

    self.feeds = [NSMutableArray array];
    self.tableView.tableFooterView = [UIView new];

    NSURL *url;
    
    if ([[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] isEqualToString:@"ca"]) {
        url = [NSURL URLWithString:@"http://atrapaeltigre.com/web/ca/feed/"];
    } else {
        url = [NSURL URLWithString:@"http://atrapaeltigre.com/web/feed/"];
    }
    
    NSError *error = nil;
    NSData *feedData = [[NSData alloc] initWithContentsOfURL:url options:NSDataReadingUncached error:&error];

    if (error==nil) {
        //_parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        _parser = [[NSXMLParser alloc] initWithData:feedData];
        [_parser setDelegate:self];
        [_parser setShouldResolveExternalEntities:NO];
        [_parser parse];
    } else {
        if (SHOW_LOGS) NSLog(@"Error url %@",[error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tigatrapp"
                                                        message:[LocalText with:@"rss_internet_connection_warning"]
                                                       delegate:self
                                              cancelButtonTitle:[LocalText with:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    
    NSDictionary *entry = [_feeds objectAtIndex:indexPath.row];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:2];
    titleLabel.text = [entry objectForKey:@"title"];
    dateLabel.text = [FormatDate rssStringToString:[entry objectForKey:@"pubDate"]];
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    NSDictionary *entry = [_feeds objectAtIndex:indexPath.row];
    NSString *urlString = [entry objectForKey:@"link"];
    NSString* trimmedUrlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"urlString = (%@)",trimmedUrlString);
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:trimmedUrlString]])
        NSLog(@"Failed to open url:");

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 44.0)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 300.0, 36.0)];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0]];
    //[label setTextColor:[UIColor darkGrayColor]];
    NSString *string =[LocalText with:@"rss_title_tigatrapp"];
    [label setText:string];
    [view addSubview:label];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 42, 305.0, 1.0)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:line];
    
    [view setBackgroundColor:C_GRAY];
    return view;
}


#pragma mark - XMLParser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    _element = elementName;
    
    if ([_element isEqualToString:@"item"]) {
        _item = [[NSMutableDictionary alloc] init];
        _thetitle = [[NSMutableString alloc] init];
        _link = [[NSMutableString alloc] init];
        _pubDate = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([_element isEqualToString:@"title"]) {
        [_thetitle appendString:string];
    } else if ([_element isEqualToString:@"link"]) {
        [_link appendString:string];
    } else if ([_element isEqualToString:@"pubDate"]) {
        [_pubDate appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [_item setObject:[_thetitle stringByReplacingOccurrencesOfString:@"\n" withString:@" "] forKey:@"title"];
        [_item setObject:[_link stringByReplacingOccurrencesOfString:@"\n" withString:@" "] forKey:@"link"];
        [_item setObject:[_pubDate stringByReplacingOccurrencesOfString:@"\n" withString:@" "] forKey:@"pubDate"];
        [_feeds addObject:[_item copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.tableView reloadData];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSString *info = [NSString stringWithFormat:
                      @"Error %i, Description: %@, Line: %i, Column: %i",
                      (int) [parseError code],
                      [[parser parserError] localizedDescription],
                      (int) [parser lineNumber],
                      (int) [parser columnNumber]];
    
    NSLog(@"RSS Feed Parse Error: %@", info);
}

@end
