//
//  NSDateFormatter+EasyDateFormatting.m
//  DBMotion
//
//  Created by Andrey Kladov on 23.01.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDateFormatter+Extensions.h"
#import "NSDate+Extensions.h"

@implementation NSDateFormatter (Extensions)

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = formatString;
    return dateFormatter;
}

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)dateFormat {
    return [[NSDateFormatter dateFormatterWithFormat:dateFormat] dateFromString:dateString];
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat {
    return [[NSDateFormatter dateFormatterWithFormat:dateFormat] stringFromDate:date];
}

+ (NSString *)monthNameStringFromMonthNum:(NSUInteger)num withFromat:(NSString *)format {
    NSString * dateString = [NSString stringWithFormat: @"%d", num];
    NSDate* date = [NSDateFormatter dateFromString:dateString withFormat:@"MM"];
    return [NSDateFormatter stringFromDate:date withFormat:format];
}

+ (NSString *)VK_formattedStringWithTimeStamp:(NSNumber *)timeStamp {
    NSDate *origDate = [NSDate dateWithTimeIntervalSince1970:timeStamp.integerValue];
    return [NSDateFormatter VK_formattedStringFromDate:origDate];
}

+ (NSString *)VK_formattedStringFromDate:(NSDate *)date {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    NSString *timeString = @"";
    if (interval > 0.0 && interval < 2.9) {
        return NSLocalizedString(@"UpdatedRightAway", @"");
    } else if (interval < 60.0) {
        return [NSString stringWithFormat:@"%.0f %@ %@", interval, NSLocalizedString(@"seconds", @""), NSLocalizedString(@"ago", @"")];
    } else if (interval > 30.0*60 && interval < 40.0*60.0) {
        return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"half hour ", @""), NSLocalizedString(@"ago", @"")];
    } else if (interval < 55.0*60.0 ) {
        return [NSString stringWithFormat:@"%.0f %@ %@", interval/60.0, NSLocalizedString(@"minutes", @""), NSLocalizedString(@"ago", @"")];
    } else if (interval > 55.0*60.0 && interval < 65.0*60.0) {
        timeString = NSLocalizedString(@"hour ", @"");
    } else {
        NSString *todayStartString = [NSDateFormatter stringFromDate:[NSDate date] 
                                                          withFormat:@"dd.MM.yyyy 00.00.00"];
        NSDate *todayStartDate = [NSDateFormatter dateFromString:todayStartString 
                                                      withFormat:@"dd.MM.yyyy HH.mm.ss"];
        NSTimeInterval dayInterval = [date timeIntervalSinceDate:todayStartDate];
        if (dayInterval < 0) {
            if (dayInterval > -(60.0*60.0*24.0)) {
                return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"yesterday at", @""), [NSDateFormatter stringFromDate:date withFormat:@"HH.mm"]];
            }
        } else {
            return [NSDateFormatter stringFromDate:date withFormat:@"HH:mm"];
        }
        return [NSDateFormatter stringFromDate:date withFormat:@"dd.MM.yy HH:mm"];
    }
    return [NSDateFormatter stringFromDate:date withFormat:@"dd.MM.yyyy HH:mm"];
}

+ (NSString *)VK_formattedMessageStringFromTimeStamp:(NSNumber *)timeStamp {
    NSDate *origDate = [NSDate dateWithTimeIntervalSince1970:timeStamp.integerValue];
    if (origDate.isYesterday) {
        return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"yesterday", @""), [NSDateFormatter stringFromDate:origDate withFormat:@"HH:mm"]];
    } else if (origDate.isToday) {
        return [NSDateFormatter stringFromDate:origDate withFormat:@"HH:mm"];
    }
    return [NSDateFormatter stringFromDate:origDate withFormat:@"dd.MM.yy HH:mm"];
}

@end
