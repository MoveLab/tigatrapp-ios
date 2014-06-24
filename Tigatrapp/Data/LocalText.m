//
//  LocalText.m
//  Tigatrapp
//
//  Created by jordi on 02/06/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import "LocalText.h"

@implementation LocalText

+(NSString *) with:(NSString *)string {
    return NSLocalizedString(string,nil);
}

@end
