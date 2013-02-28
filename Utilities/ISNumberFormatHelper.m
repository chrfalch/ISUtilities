//
//  NumberFormatHelper.m
//  DriveBook
//
//  Created by Christian Falch on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ISNumberFormatHelper.h"

@implementation ISNumberFormatHelper

// Returns a number formatted with the current locale
+(NSString*) stringFromNumber:(float)number
{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle: NSNumberFormatterDecimalStyle];
    [nf setMaximumFractionDigits:2];
    [nf setLocale:[NSLocale currentLocale]];
    return [nf stringFromNumber:[NSNumber numberWithFloat:number]];
    
    // return [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:number] numberStyle:NSNumberFormatterDecimalStyle];
}

// Returns a number from a string
+(NSNumber*) formattedNSNumberFromString:(NSString*)string
{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle: NSNumberFormatterDecimalStyle];
    [nf setLocale:[NSLocale currentLocale]];
    string = [string stringByReplacingOccurrencesOfString:[nf groupingSeparator] withString:@""];
    return [nf numberFromString: string];
}

// Returns a number from a string
+(float) formattedNumberFromString:(NSString*)string
{
    return [[ISNumberFormatHelper formattedNSNumberFromString:string ] floatValue];
}

@end
