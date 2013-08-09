//
//  KMAPIController.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KMUserAuthManager;
@class KMLikesCommentsReqManager;
@class KMDataCacheRequestManager;
@class KMDataStoreManager;
@class KMSyncDataManager;

@interface KMAPIController : NSObject
@property (readonly, nonatomic, strong) KMUserAuthManager *userAuthManager;
@property (readonly, nonatomic, strong) KMLikesCommentsReqManager *likesCommentsReqManager;
@property (readonly, nonatomic, strong) KMDataCacheRequestManager *cachedRequestManager;
@property (readonly, nonatomic, strong) KMDataStoreManager *dataStoreManager;
@property (readonly, nonatomic, strong) KMSyncDataManager *syncDataManager;
+ (KMAPIController *)sharedInstance;
@end
