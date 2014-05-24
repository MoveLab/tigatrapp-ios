//
//  ActivityMapAnnotation.m
//  Tigatrapp
//
//  Created by jordi on 22/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "ActivityMapAnnotation.h"

@implementation ActivityMapAnnotation

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super init])) {
        self.title = @"foof";
        self.subtitle = @"faa";
        self.coordinate = CLLocationCoordinate2DMake(88,88);
    }
    return self;
}


- (NSString *)title {
    return _title;
}

- (NSString *)subtitle {
    return _subtitle;
}


- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}


@end
