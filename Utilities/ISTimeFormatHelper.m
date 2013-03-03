//
//  TimeFormatHelper.m
//  DriveBook
//
//  Created by Christian Falch on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ISTimeFormatHelper.h"


@implementation ISTimeFormatHelper

// Returns the last day in the month in the date
+(NSDate*) lastDayInMonth:(NSDate*)date
{
    NSDateComponents *dateComps = [[ISTimeFormatHelper sharedCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    
    NSDate* endDate = [[ISTimeFormatHelper sharedCalendar] dateFromComponents:dateComps];
    
    // last day in year, or last day in month
    // Last day of month
    NSRange daysRange = [[ISTimeFormatHelper sharedCalendar] rangeOfUnit:NSDayCalendarUnit  inUnit:NSMonthCalendarUnit forDate:endDate];
    
    dateComps.day = daysRange.length;
    dateComps.hour = 23;
    dateComps.minute = 59;
    dateComps.second = 59;
    
    return [[ISTimeFormatHelper sharedCalendar] dateFromComponents:dateComps];   
}

// Returns true if the date falls into a weekend
+(BOOL) dateIsInWeekend:(NSDate*)date
{
    // Set correct first weekday
    NSCalendar *gregorian = [ISTimeFormatHelper sharedCalendar];
    [gregorian setFirstWeekday:2]; // Sunday == 1, Saturday == 7
    NSDateComponents* comps = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    return comps.weekday == 1 || comps.weekday == 7;
}

+(NSDate*) firstDateInWeekFromDate:(NSDate*)date
{
    NSCalendar *gregorian = [ISTimeFormatHelper sharedCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    /*
     Create a date components to represent the number of days to subtract
     from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so
     subtract 1 from the number
     of days to subtract from the date in question.  (If today's Sunday,
     subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    /* Substract [gregorian firstWeekday] to handle first day of the week being something else than Sunday */
    [componentsToSubtract setDay: - ([weekdayComponents weekday] - [gregorian firstWeekday])];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    /*
     Optional step:
     beginningOfWeek now has the same hour, minute, and second as the
     original date (today).
     To normalize to midnight, extract the year, month, and day components
     and create a new date from those components.
     */
    NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: beginningOfWeek];
    
    return [gregorian dateFromComponents: components];
}

// Returns the time as seconds
+(NSDate*) dateTimeFromSeconds:(int)seconds
{
    // Find current year
    NSDateComponents *dateComps = [[ISTimeFormatHelper sharedCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:[NSDate date]];    
    
    [dateComps setSecond:seconds];
    [dateComps setHour:0];
    [dateComps setMinute:0];
    
    return [[ISTimeFormatHelper sharedCalendar] dateFromComponents:dateComps];    
}

+(NSString*) monthNameFromMonthNumber:(int)month
{
    NSString* monthName = [[[ISTimeFormatHelper sharedDateFormatter] monthSymbols] objectAtIndex:(month-1)];
    
    // find and capitalize month name
    monthName = [monthName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[monthName substringToIndex:1] uppercaseString]];
    
    return monthName;
}

+(NSString*) shortDayNameFromDate:(NSDate*)t
{
    if(t)
    {
        // Format date/time
        [[ISTimeFormatHelper sharedDateFormatter] setTimeStyle:NSDateFormatterNoStyle];
        [[ISTimeFormatHelper sharedDateFormatter] setDateFormat:@"EEE"];
        
        return [[ISTimeFormatHelper sharedDateFormatter] stringFromDate:t];
    }
    else
    {
        return @"-";
    }
}

+(NSString*) dayNameFromDate:(NSDate *)t
{
    [[ISTimeFormatHelper sharedDateFormatter] setDateStyle:NSDateFormatterFullStyle];
    
    NSString* dayName = [[ISTimeFormatHelper sharedDateFormatter] stringFromDate:t];
    dayName = [dayName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[dayName substringToIndex:1] uppercaseString]];
    
    return dayName;

}

+(NSString*) yearStringFromDate:(NSDate*)t
{
    NSDateComponents *dateComps = [[ISTimeFormatHelper sharedCalendar] components:NSYearCalendarUnit fromDate:t];
    return [NSString stringWithFormat:@"%d", [dateComps year]];
}

+(NSString*) shortMonthNameFromDate:(NSDate*)t
{
    if(t)
    {
        // Format date/time
        [[ISTimeFormatHelper sharedDateFormatter] setTimeStyle:NSDateFormatterNoStyle];
        [[ISTimeFormatHelper sharedDateFormatter] setDateFormat:@"MMM"];
        
        return [[ISTimeFormatHelper sharedDateFormatter] stringFromDate:t];
    }
    else
    {
        return @"-";
    }
}

// Returns a date without time as a string
+(NSString*) filenameStringFromDate:(NSDate*)t
{
    if(t)
    {
        // Format date/time
        [[ISTimeFormatHelper sharedDateFormatter] setTimeStyle:NSDateFormatterNoStyle];
        [[ISTimeFormatHelper sharedDateFormatter] setDateFormat:@"MMddyy"];
        
        return [[ISTimeFormatHelper sharedDateFormatter] stringFromDate:t];
    }
    else
    {
        return @"-";
    }
}

// Returns a date without time as a string 
+(NSString*) reallyShortStringFromDate:(NSDate*)t
{
    if(t)
    {
        // Format date/time
        [[ISTimeFormatHelper sharedDateFormatter] setTimeStyle:NSDateFormatterNoStyle];
        [[ISTimeFormatHelper sharedDateFormatter] setDateStyle:NSDateFormatterShortStyle];
        
        return [[ISTimeFormatHelper sharedDateFormatter] stringFromDate:t];
    }
    else
    {
        return @"-";
    }
}

// Returns a date without time as a string 
+(NSString*) dateStringFromDate:(NSDate*)t
{
    if(t)
    {
        // Format date/time
        [[ISTimeFormatHelper sharedDateFormatter] setTimeStyle:NSDateFormatterNoStyle];
        [[ISTimeFormatHelper sharedDateFormatter] setDateStyle:NSDateFormatterMediumStyle];
        
        return [[ISTimeFormatHelper sharedDateFormatter] stringFromDate:t];
    }
    else
    {
        return @"-";
    }
}

// Returns the time part of the date
+(NSString*) timeStringFromDate:(NSDate*)t
{
    if(!t)
        return @"00:00";
    
    // Format start time
    [[ISTimeFormatHelper sharedDateFormatter] setDateFormat:@"HH:mm"];
    
    return [[ISTimeFormatHelper sharedDateFormatter] stringFromDate:t];
}

#pragma mark Singleton stuff

// singleton stuff
// return the shared NSDateFormatter instance
+ (NSDateFormatter*)sharedDateFormatter
{
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary] ;
    NSDateFormatter *dateFormatter = [threadDictionary objectForKey: @"DDMyDateFormatter"] ;
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init] ;
        [threadDictionary setObject: dateFormatter forKey: @"DDMyDateFormatter"] ;
    }
    
    return dateFormatter ;
}

// return the shared NSCalendar instance
+ (NSCalendar*)sharedCalendar
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary] ;
    NSCalendar *calendar = [threadDictionary objectForKey: @"DDMyCalendar"] ;
    if (calendar == nil)
    {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [threadDictionary setObject: calendar forKey: @"DDMyCalendar"] ;
    }
    
    return calendar;
}

// Returns the date for the monday in the week the date falls into
+(NSDate*) dateForFirstDayInWeekFromDate:(NSDate*)date
{
    NSCalendar *gregorian = [ISTimeFormatHelper sharedCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents * componentsToSubtract = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    [componentsToSubtract setWeekday:-componentsToSubtract.weekday];
    
    /* Substract [gregorian firstWeekday] to handle first day of the week being something else than Sunday */                                      
    return [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
}

@end
