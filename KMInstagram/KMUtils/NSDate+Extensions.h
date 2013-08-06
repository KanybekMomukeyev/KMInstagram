//
//  NSDate+Extensions.h
//  VKMessenger
//
//  Created by Andrey Kladov on 20.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extensions)

- (BOOL)isTomorrow;
- (BOOL)isToday;
- (BOOL)isYesterday;

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
+ (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;
@end
