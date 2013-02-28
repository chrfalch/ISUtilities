//
//  NumberFormatHelper.h
//  DriveBook
//
//  Created by Christian Falch on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISNumberFormatHelper : NSObject

// Returns a number formatted with the current locale
+(NSString*) stringFromNumber:(float)number;

// Returns a number from a string
+(float) formattedNumberFromString:(NSString*)string;

// Returns a number from a string
+(NSNumber*) formattedNSNumberFromString:(NSString*)string;

@end
