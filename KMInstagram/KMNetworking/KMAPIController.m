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
#import "KMLikesCommentsReqManager.h"
#import "KMDataCacheRequestManager.h"
#import "KMDataStoreManager.h"
#import "KMSyncDataManager.h"

@interface KMAPIController()
@property (nonatomic, strong) KMUserAuthManager *userAuthManager;
@property (nonatomic, strong) KMLikesCommentsReqManager *likesCommentsReqManager;
@property (nonatomic, strong) KMDataCacheRequestManager *cachedRequestManager;
@property (nonatomic, strong) KMDataStoreManager *dataStoreManager;
@property (nonatomic, strong) KMSyncDataManager *syncDataManager;
@end


@implementation KMAPIController

SINGLETON_GCD(KMAPIController)

- (KMUserAuthManager *)userAuthManager {
    if (!_userAuthManager) {
        _userAuthManager = [KMUserAuthManager new];
    }
    return _userAuthManager;
}

-(KMLikesCommentsReqManager *)likesCommentsReqManager {
    if (!_likesCommentsReqManager) {
        _likesCommentsReqManager = [KMLikesCommentsReqManager new];
    }
    return _likesCommentsReqManager;
}

- (KMDataCacheRequestManager *)cachedRequestManager {
    if (!_cachedRequestManager) {
        _cachedRequestManager = [KMDataCacheRequestManager new];
    }
    return _cachedRequestManager;
}

- (KMDataStoreManager *)dataStoreManager {
    if (!_dataStoreManager) {
        _dataStoreManager = [KMDataStoreManager new];
    }
    return _dataStoreManager;
}

- (KMSyncDataManager *)syncDataManager {
    if (!_syncDataManager) {
        _syncDataManager = [KMSyncDataManager new];
    }
    return _syncDataManager;
}

@end
