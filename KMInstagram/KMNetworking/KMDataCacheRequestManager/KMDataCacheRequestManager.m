//
//  KMDataCacheRequestManager.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMDataCacheRequestManager.h"
#import "KMInstagramRequestClient.h"
#import "KMAPIController.h"
#import "JSONKit.h"
#import "CDFeed.h"
#import "CDPagination.h"
#import "CDUser.h"

@interface KMBaseRequestManager()
@property (readwrite, nonatomic, strong) NSDate *lastUpdateDate;
@property (readwrite, nonatomic, strong) KMPagination *pagination;
@end

@implementation KMDataCacheRequestManager

- (void)getUserFeedWithCount:(NSInteger)count
                       minId:(NSString *)minId
                       maxId:(NSString *)maxId
                  completion:(CompletionBlock)completion
{
    self.loading = YES;
    
    NSMutableDictionary* parameters = [self baseParams];
    [parameters setObject:@(count) forKey:@"count"];
    if (minId) [parameters setObject:minId forKey:@"min_id"];
    if (maxId) [parameters setObject:maxId forKey:@"max_id"];
    
    __weak KMDataCacheRequestManager *self_ = self;
    [[KMInstagramRequestClient sharedClient] getPath:@"users/self/feed"
                                          parameters:parameters
                                             success:^(AFHTTPRequestOperation *opertaion, NSDictionary *response) {
                                                 
                                                 __block NSManagedObjectContext *localContext = nil;
                                                 __block CDPagination *paging = nil;
                                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                     
                                                     localContext  = [NSManagedObjectContext MR_contextForCurrentThread];
                                                     
                                                     paging = [CDPagination MR_createInContext:localContext];
                                                     [paging setWithDictionary:[response objectForKey:@"pagination"]];
                                                     
                                                     NSArray *responseObjects = [response objectForKey:@"data"];
                                                     [responseObjects enumerateObjectsUsingBlock:^(NSDictionary *object, NSUInteger idx, BOOL *stop){
                                                         CDFeed *feed = [CDFeed MR_createInContext:localContext];
                                                         [feed setWithDictionary:object];
                                                     }];
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         self_.loading = NO;
                                                         self_.lastUpdateDate = [NSDate date];
                                                         
                                                         [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL sucess, NSError *error){
                                                             if (sucess) {
                                                                 NSLog(@"GOOD");
                                                                 if (completion)
                                                                     completion(@(YES), nil);
                                                             }else {
                                                                 NSLog(@"ERROR");
                                                                 if (completion)
                                                                     completion(nil, error);
                                                             }
                                                         }];
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
