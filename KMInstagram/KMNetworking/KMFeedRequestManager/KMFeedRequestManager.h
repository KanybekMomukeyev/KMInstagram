//
//  KMFeedRequestManager.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KMPagination;

@interface KMFeedRequestManager : NSObject
@property (nonatomic, getter = isLoading) BOOL loading;
@property (nonatomic, strong, readonly) NSDate *lastUpdateDate;
@property (nonatomic, strong, readonly) KMPagination *pagination;

- (void)getUserFeedWithCount:(NSInteger)count
                       minId:(NSString *)minId
                       maxId:(NSString *)maxId
                  completion:(CompletionBlock)completion;

@end
