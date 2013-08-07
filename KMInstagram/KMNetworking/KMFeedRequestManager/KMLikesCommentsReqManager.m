//
//  KMLikesCommentsReqManager.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMLikesCommentsReqManager.h"
#import "KMAPIController.h"
#import "KMUserAuthManager.h"
#import "KMInstagramRequestClient.h"
#import "JSONKit.h"
#import "KMUser.h"
#import "KMComment.h"

@implementation KMLikesCommentsReqManager

- (void)getLikesForFeedId:(NSString *)feedId withCompletion:(CompletionBlock)completion
{
    [[KMInstagramRequestClient sharedClient] getPath:[NSString stringWithFormat:@"media/%@/likes", feedId]
                                          parameters:[self baseParams]
                                             success:^(AFHTTPRequestOperation *opertaion, NSDictionary *response) {
                                                 
                                                 __block NSMutableArray *usersArray = [NSMutableArray new];
                                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                     NSArray *responseObjects = [response objectForKey:@"data"];
                                                     [responseObjects enumerateObjectsUsingBlock:^(NSDictionary *object, NSUInteger idx, BOOL *stop){
                                                         KMUser *user = [[KMUser alloc] initWithDictionary:object];
                                                         [usersArray addObject:user];
                                                     }];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         if (completion) {
                                                             completion([NSArray arrayWithArray:usersArray], nil);
                                                         }
                                                     });
                                                 });
                                             }
                                             failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
                                                 NSLog(@"error.description = %@",error.description);
                                                 if (completion) {
                                                     completion(nil, error);
                                                 }
                                             }];

}



- (void)postLikeForFeedId:(NSString *)feedId withCompletion:(CompletionBlock)completion
{
    [[KMInstagramRequestClient sharedClient] postPath:[NSString stringWithFormat:@"media/%@/likes", feedId]
                                           parameters:[self baseParams]
                                              success:^(AFHTTPRequestOperation *opertaion, NSDictionary *response) {
                                                  if (completion) {
                                                     completion(response, nil);
                                                  }
                                              }
                                              failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
                                                  NSLog(@"error.description = %@",error.description);
                                                  if (completion) {
                                                      completion(nil, error);
                                                  }
                                              }];
    
}

- (void)removeLikeForFeedId:(NSString *)feedId withCompletion:(CompletionBlock)completion
{
    [[KMInstagramRequestClient sharedClient] deletePath:[NSString stringWithFormat:@"media/%@/likes", feedId]
                                             parameters:[self baseParams]
                                                success:^(AFHTTPRequestOperation *opertaion, NSDictionary *response) {
                                                    if (completion) {
                                                        completion(response, nil);
                                                    }
                                                }
                                                failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
                                                    NSLog(@"error.description = %@",error.description);
                                                    if (completion) {
                                                        completion(nil, error);
                                                    }
                                                }];

    
}


- (void)getCommentsForFeedId:(NSString *)feedId withCompletion:(CompletionBlock)completion
{
    [[KMInstagramRequestClient sharedClient] getPath:[NSString stringWithFormat:@"media/%@/comments", feedId]
                                          parameters:[self baseParams]
                                             success:^(AFHTTPRequestOperation *opertaion, NSDictionary *response) {
                                                 
                                                 __block NSMutableArray *commentsArray = [NSMutableArray new];
                                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                     NSArray *responseObjects = [response objectForKey:@"data"];
                                                     [responseObjects enumerateObjectsUsingBlock:^(NSDictionary *object, NSUInteger idx, BOOL *stop){
                                                         KMComment *comment = [[KMComment alloc] initWithDictionary:object];
                                                         [commentsArray addObject:comment];
                                                     }];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         if (completion) {
                                                             completion([NSArray arrayWithArray:commentsArray], nil);
                                                         }
                                                     });
                                                 });
                                             }
                                             failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
                                                 NSLog(@"error.description = %@",error.description);
                                                 if (completion) {
                                                     completion(nil, error);
                                                 }
                                             }];
}

@end
