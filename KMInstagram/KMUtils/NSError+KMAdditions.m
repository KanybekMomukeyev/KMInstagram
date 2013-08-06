//
//  NSError+KMAdditions.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "NSError+KMAdditions.h"

@implementation NSError (KMAdditions)

+ (NSError *)errorWithString:(NSString *)errorString
{
    if (errorString) {
        NSError *error = [NSError errorWithDomain:@"BANotValidErrorDomain"
                                             code:2
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorString,NSLocalizedDescriptionKey,nil]];
        return error;
    }else {
        return nil;
    }
}

@end
