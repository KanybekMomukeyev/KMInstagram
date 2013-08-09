//
//  KMUserAuthManager.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMUserAuthManager.h"
#import "KMDataStoreManager.h"
#import "KMAPIController.h"

#define kKMUserInstagramAcessToken @"kKMUserInstagramAcessToken"

@interface  KMUserAuthManager()
@property (nonatomic, strong) NSString *acessToken;
@end

@implementation KMUserAuthManager

- (void)setAccessToke:(NSString *)acessToken
{
    _acessToken = acessToken;
    [[NSUserDefaults standardUserDefaults] setValue:acessToken forKey:kKMUserInstagramAcessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    [[[KMAPIController sharedInstance] dataStoreManager] deleteAllCommands];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kKMUserInstagramAcessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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


