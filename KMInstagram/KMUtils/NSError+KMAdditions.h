//
//  NSError+KMAdditions.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (KMAdditions)
+ (NSError *)errorWithString:(NSString *)errorString;
@end
