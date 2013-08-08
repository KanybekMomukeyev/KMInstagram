//
//  KMDataCacheRequestManager.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//


#import "KMBaseRequestManager.h"
@interface KMDataCacheRequestManager : KMBaseRequestManager
@property (nonatomic, readonly) NSUInteger pagingIndex;
@property (readwrite ,nonatomic, strong) NSString *nextMaxId;

- (void)getUserFeedWithCount:(NSInteger)count
                  completion:(CompletionBlock)completion;

- (void)pagingUserFeedWithCount:(NSInteger)count
                          minId:(NSString *)minId
                          maxId:(NSString *)maxId
                     completion:(CompletionBlock)completion;
@end
