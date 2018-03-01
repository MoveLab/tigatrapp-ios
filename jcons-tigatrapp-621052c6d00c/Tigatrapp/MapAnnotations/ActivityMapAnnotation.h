//
//  ActivityMapAnnotation.h
//  Tigatrapp
//
//  Created by jordi on 22/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class Report;

@interface ActivityMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *reportId;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) Report *report;

- (id)initWithReport:(Report *)report;

@end
