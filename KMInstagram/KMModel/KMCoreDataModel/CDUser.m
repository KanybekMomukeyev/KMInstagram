//
//  CDUser.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "CDUser.h"
#import "CDFeed.h"


@implementation CDUser

@dynamic profile_picture;
@dynamic username;
@dynamic userId;
@dynamic full_name;
@dynamic caption;
@dynamic comment;
@dynamic feedComments;
@dynamic feed;

- (void)setWithDictionary:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSNull class]])
    {
        self.profile_picture = [dict objectForKey:@"profile_picture"];
        self.username = [dict objectForKey:@"username"];
        self.userId = [dict objectForKey:@"id"];
        self.full_name = [dict objectForKey:@"full_name"];
    }
}

@end
