//
//  NSDate+Extensions.m
//  VKMessenger
//
//  Created by Andrey Kladov on 20.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Extensions.h"
#import "NSDateFormatter+Extensions.h"

@implementation NSDate (Extensions)

- (NSTimeInterval)timeIntervalSinceTodaysBeginning {
    NSString *todayStartString = [NSDateFormatter stringFromDate:[NSDate date] 
                                                      withFormat:@"dd.MM.yyyy 00.00.00"];
    NSDate *todayStartDate = [NSDateFormatter dateFromString:todayStartString 
                                                  withFormat:@"dd.MM.yyyy HH.mm.ss"];
    return [self timeIntervalSinceDate:todayStartDate];
}

- (BOOL)isTomorrow {
    NSTimeInterval interval = [self timeIntervalSinceTodaysBeginning];
    return ((interval > 0) && (interval < (60.0*60.0*48.0)));
}

- (BOOL)isToday {
    NSTimeInterval interval = [self timeIntervalSinceTodaysBeginning];
    return ((interval >= 0) && (interval < (60.0*60.0*24.0)));
}

- (BOOL)isYesterday {
    NSTimeInterval interval = [self timeIntervalSinceTodaysBeginning];
    return ((interval < 0) && (interval > -(60.0*60.0*24.0)));
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate {
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back       
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


@end
