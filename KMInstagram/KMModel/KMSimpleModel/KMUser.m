//
//  KMUser.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMUser.h"

@implementation KMUser

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSNull class]])
        {
            _profile_picture = [dict objectForKey:@"profile_picture"];
            _username =  [dict objectForKey:@"username"];
            _userId = [dict objectForKey:@"id"];
            _full_name = [dict objectForKey:@"full_name"];
        }
    }
    return self;
}
@end
