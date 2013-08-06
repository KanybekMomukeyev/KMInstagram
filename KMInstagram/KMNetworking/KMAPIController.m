//
//  KMAPIController.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMAPIController.h"
#import "Singleton.h"
#import "KMUserAuthManager.h"


@interface KMAPIController()
@property (nonatomic, strong) KMUserAuthManager *userAuthManager;
@end


@implementation KMAPIController

SINGLETON_GCD(KMAPIController)

- (KMUserAuthManager *)userAuthManager {
    if (!_userAuthManager) {
        _userAuthManager = [KMUserAuthManager new];
    }
    return _userAuthManager;
}

@end
