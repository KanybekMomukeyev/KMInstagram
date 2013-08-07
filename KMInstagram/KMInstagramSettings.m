//
//  KMInstagramSettings.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMInstagramSettings.h"

@implementation KMInstagramSettings

#define kKMInstagramClientId @"c22e560ed1a74621af40ca67e136639f"
#define kKMInstagramCallbackUrl @"http://mail.ru"

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
