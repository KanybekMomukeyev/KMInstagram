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
    
}

/*
 "pagination": {
 "next_url": "https://api.instagram.com/v1/users/self/feed?access_token=262845382.c22e560.8c26c32ac4ad478ebb8d3fbb00a164f3&count=10&max_id=516798973433099614_237109364",
 "next_max_id": "516798973433099614_237109364"
 }
 */

@end
