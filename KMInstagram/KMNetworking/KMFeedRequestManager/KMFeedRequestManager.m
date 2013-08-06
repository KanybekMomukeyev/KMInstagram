//
//  KMFeedRequestManager.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMFeedRequestManager.h"
#import "KMInstagramRequestClient.h"
#import "KMAPIController.h"
#import "KMUserAuthManager.h"
#import "JSONKit.h"
#import "KMFeed.h"

@interface KMFeedRequestManager()
@property (nonatomic, strong) NSDate *lastUpdateDate;
@end

@implementation KMFeedRequestManager

- (void)getUserFeedWithCount:(NSInteger)count
                       minId:(NSString *)minId
                       maxId:(NSString *)maxId
                  completion:(CompletionBlock)completion
{
    self.loading = YES;
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInteger:count], @"count",  nil];
    [parameters setObject:[[[KMAPIController sharedInstance] userAuthManager] getAcessToken] forKey:@"access_token"];
    if (minId) [parameters setObject:minId forKey:@"min_id"];
    if (maxId) [parameters setObject:maxId forKey:@"max_id"];
    __weak KMFeedRequestManager *self_ = self;
    [[KMInstagramRequestClient sharedClient] getPath:@"users/self/feed"
                                          parameters:parameters
                                             success:^(AFHTTPRequestOperation *opertaion, NSDictionary *response){
                                                 
                                                 //NSLog(@"response = %@",[response JSONString]);
                                                 __block NSMutableArray *feedsArray = [NSMutableArray new];
                                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                     NSArray *responseObjects = [response objectForKey:@"data"];
                                                     [responseObjects enumerateObjectsUsingBlock:^(NSDictionary *object, NSUInteger idx, BOOL *stop){
                                                         KMFeed *feed = [[KMFeed alloc] initWithDictionary:object];
                                                         [feedsArray addObject:feed];
                                                     }];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         self_.loading = NO;
                                                         self_.lastUpdateDate = [NSDate date];
                                                         if (completion) {
                                                             completion([NSArray arrayWithArray:feedsArray], nil);
                                                         }
                                                     });
                                                 });
                                             }
                                             failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
                                                 NSLog(@"error.description = %@",error.description);
                                                 self_.loading = NO;
                                                 if (completion) {
                                                     completion(nil, error);
                                                 }
                                             }];
}




@end
