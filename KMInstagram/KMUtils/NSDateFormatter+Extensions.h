//
//  NSDateFormatter+EasyDateFormatting.h
//  DBMotion
//
//  Created by Andrey Kladov on 23.01.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Extensions)

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)formatString;
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)dateFormat;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat;
+ (NSString *)monthNameStringFromMonthNum:(NSUInteger)num withFromat:(NSString *)format;

+ (NSString *)VK_formattedStringWithTimeStamp:(NSNumber *)timeStamp;
+ (NSString *)VK_formattedStringFromDate:(NSDate *)date;
+ (NSString *)VK_formattedMessageStringFromTimeStamp:(NSNumber *)timeStamp;

@end
