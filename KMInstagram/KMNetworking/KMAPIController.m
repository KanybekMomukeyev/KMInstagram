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
#import "KMFeedRequestManager.h"
#import "KMLikesCommentsReqManager.h"

@interface KMAPIController()
@property (nonatomic, strong) KMUserAuthManager *userAuthManager;
@property (nonatomic, strong) KMFeedRequestManager *feedRequestManager;
@property (nonatomic, strong) KMLikesCommentsReqManager *likesCommentsReqManager;
@end


@implementation KMAPIController

SINGLETON_GCD(KMAPIController)

- (KMUserAuthManager *)userAuthManager {
    if (!_userAuthManager) {
        _userAuthManager = [KMUserAuthManager new];
    }
    return _userAuthManager;
}

- (KMFeedRequestManager *)feedRequestManager {
    if (!_feedRequestManager) {
        _feedRequestManager = [KMFeedRequestManager new];
    }
    return _feedRequestManager;
}

-(KMLikesCommentsReqManager *)likesCommentsReqManager {
    if (!_likesCommentsReqManager) {
        _likesCommentsReqManager = [KMLikesCommentsReqManager new];
    }
    return _likesCommentsReqManager;
}

@end
