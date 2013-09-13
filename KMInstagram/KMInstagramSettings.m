//
//  KMInstagramSettings.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMInstagramSettings.h"

@implementation KMInstagramSettings

#define kKMInstagramClientId @"dc9d12759911461a9714732aa102f3d8"
#define kKMInstagramCallbackUrl @"http://diesel.elcat.kg"


+ (NSString *)clientId
{
    return [NSString stringWithFormat:@"%@", kKMInstagramClientId];
}

+ (NSString *)callbackUrl
{
    return [NSString stringWithFormat:@"%@", kKMInstagramCallbackUrl];
}

+ (NSArray *)scopes
{
    return [NSArray arrayWithObjects:@"likes", @"relationships", @"comments", nil];
}

@end
