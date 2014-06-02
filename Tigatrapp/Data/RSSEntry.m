//
//  RSSEntry.m
//  Tigatrapp
//
//  Created by jordi on 02/06/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "RSSEntry.h"

@implementation RSSEntry

@synthesize articleTitle = _articleTitle;
@synthesize articleUrl = _articleUrl;
@synthesize articleDate = _articleDate;

- (id)initWithTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate
{
    if ((self = [super init])) {
        _articleTitle = [articleTitle copy];
        _articleUrl = [articleUrl copy];
        _articleDate = [articleDate copy];
    }
    return self;
}

@end
