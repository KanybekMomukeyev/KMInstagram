//
//  KMSyncDataManager.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/8/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
	KMNoneSyncCommand		= 0,
	KMDeleteSyncCommand  	= 401,
	KMPostSyncCommand       = 402
} KMSyncCommandType;

@interface KMSyncDataManager : NSObject
- (void)syncWithRemoteService;
- (void)addSyncModelWithMethod:(KMSyncCommandType)method httpPath:(NSString *)path feedId:(NSString *)feedId;
@end
