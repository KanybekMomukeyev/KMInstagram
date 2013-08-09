//
//  KMInstagramSettings.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMInstagramSettings.h"

@implementation KMInstagramSettings

#define kKMInstagramClientId @"026c438e96e64a0aab6f950786851e04"
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
