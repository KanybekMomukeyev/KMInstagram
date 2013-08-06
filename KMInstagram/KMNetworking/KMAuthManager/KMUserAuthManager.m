//
//  KMUserAuthManager.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMUserAuthManager.h"

#define kKMUserInstagramAcessToken @"kKMUserInstagramAcessToken"

@interface  KMUserAuthManager()
@property (nonatomic, strong) NSString *acessToken;
@end

@implementation KMUserAuthManager

- (void)setAccessToke:(NSString *)acessToken
{
    _acessToken = acessToken;
    [[NSUserDefaults standardUserDefaults] setValue:acessToken forKey:kKMUserInstagramAcessToken];
}


- (NSString *)getAcessToken {
    if (!_acessToken) {
        _acessToken = [[NSUserDefaults standardUserDefaults] valueForKey:kKMUserInstagramAcessToken];
    }
    return _acessToken;
}

- (void)logOut
{
    self.acessToken = nil;
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kKMUserInstagramAcessToken];
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"instagram"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
}


@end


