//
//  KMPagination.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMPagination.h"

@implementation KMPagination

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSNull class]])
        {
            _nextUrl = [dict objectForKey:@"next_url"];
            _next_max_id = [dict objectForKey:@"next_max_id"];
        }
    }
    return self;
}

/*
"pagination": {
    "next_url": "https://api.instagram.com/v1/users/self/feed?access_token=262845382.c22e560.8c26c32ac4ad478ebb8d3fbb00a164f3&count=10&max_id=516798973433099614_237109364",
    "next_max_id": "516798973433099614_237109364"
}
*/
@end
