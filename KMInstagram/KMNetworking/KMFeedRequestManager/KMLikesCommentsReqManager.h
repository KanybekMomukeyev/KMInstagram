//
//  KMLikesCommentsReqManager.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMBaseRequestManager.h"
static NSUInteger const kKMSuccessDoneLikeMethod = 1000;

@interface KMLikesCommentsReqManager : KMBaseRequestManager


- (void)getLikesForFeedId:(NSString *)feedId withCompletion:(CompletionBlock)completion;
- (void)postLikeForFeedId:(NSString *)feedId withCompletion:(CompletionBlock)completion;
- (void)removeLikeForFeedId:(NSString *)feedId withCompletion:(CompletionBlock)completion;
- (void)getCommentsForFeedId:(NSString *)feedId withCompletion:(CompletionBlock)completion;

@end
