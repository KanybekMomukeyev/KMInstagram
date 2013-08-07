//
//  CDPagination.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "CDPagination.h"


@implementation CDPagination

@dynamic nextUrl;
@dynamic next_max_id;

- (void)setWithDictionary:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSNull class]])
    {
        self.nextUrl = [dict objectForKey:@"next_url"];
        self.next_max_id = [dict objectForKey:@"next_max_id"];
    }
}

@end
