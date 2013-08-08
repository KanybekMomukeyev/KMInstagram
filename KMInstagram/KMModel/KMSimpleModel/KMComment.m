//
//  KMComment.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMComment.h"

@implementation KMComment

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSNull class]])
        {
            if ([dict objectForKey:@"created_time"]) {
                _created_time = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"created_time"] doubleValue]];
            }
            _text = [dict objectForKey:@"text"];
            _commentId = [dict objectForKey:@"id"];
            _user = [[KMUser alloc] initWithDictionary:[dict objectForKey:@"from"]];
        }
    }
    return self;
}

@end
