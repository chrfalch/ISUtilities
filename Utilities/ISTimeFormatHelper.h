//
//  TimeFormatHelper.h
//  DriveBook
//
//  Created by Christian Falch on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ISTimeFormatHelper : NSObject {
    
}

// Returns the last day in the month in the date
+(NSDate*) lastDayInMonth:(NSDate*)date;

// Returns the date of the first day in the week of the given day
+(NSDate*) firstDateInWeekFromDate:(NSDate*)date;

// Returns true if the date falls into a weekend
+(BOOL) dateIsInWeekend:(NSDate*)date;

// Returns the short day name for the date
+(NSString*) getShortDayName:(NSDate*)t;

// Returns the day name as used in section headers
+(NSString*) getDateAsDay:(NSDate*)t;

// Returns the year for the given date as a string
+(NSString*) getYearAsString:(NSDate*)t;

// Returns the short month name for the date
+(NSString*) getShortMonthName:(NSDate*)t;

// Returns the time as seconds
+(NSDate*) getTimeFromSeconds:(int)seconds;

// Returns a date without time as a string 
+(NSString*) getReallyShortDateAsString:(NSDate*)t;

// Returns the date as a filename-ready string
+(NSString*) getDateAsFilenameString:(NSDate*)t;

// Returns a date without time as a string 
+(NSString*) getShortDateAsString:(NSDate*)t;

// Returns the time part of the date
+(NSString*) getTimeAsString:(NSDate*)t;

// Returns the name of a given month
+(NSString*) getMonthNameFromNumber:(NSString*)monthNumberAsString;

// return the shared NSDateFormatter instance
+ (NSDateFormatter*)sharedDateFormatter;

// return the shared NSCalendar instance
+ (NSCalendar*)sharedCalendar;

// Returns the date for the monday in the week the date falls into
+(NSDate*) getFirstDateInWeek:(NSDate*)date;

// Returns the current date/time
+(NSDate*) getNow;

@end
