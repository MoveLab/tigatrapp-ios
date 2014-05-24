//
//  ActivityMapAnnotation.h
//  Tigatrapp
//
//  Created by jordi on 22/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ActivityMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
