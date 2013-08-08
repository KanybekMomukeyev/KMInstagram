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
#import "KMDataStoreManager.h"

#define kKMLastSavedDate @"kKMLastSavedDate"

@interface KMBaseRequestManager()
@property (readwrite, nonatomic, strong) NSDate *lastUpdateDate;
@end

@interface KMDataCacheRequestManager()
@property (nonatomic) NSUInteger pagingIndex;
@end

@implementation KMDataCacheRequestManager

- (void)getUserFeedWithCount:(NSInteger)count
                  completion:(CompletionBlock)completion
{
    self.loading = YES;
    
    NSMutableDictionary* parameters = [self baseParams];
    [parameters setObject:@(count) forKey:@"count"];
    
    __weak KMDataCacheRequestManager *self_ = self;
    [[KMInstagramRequestClient sharedClient] getPath:@"users/self/feed"
                                          parameters:parameters
                                             success:^(AFHTTPRequestOperation *opertaion, NSDictionary *response) {
                                                 
                                                 [[[KMAPIController sharedInstance] dataStoreManager] deleteAllFeeds];
                                                 [[[KMAPIController sharedInstance] dataStoreManager] deleteAllPagination];
                                                 self_.pagingIndex = 0;
                                                 
                                                 __block NSManagedObjectContext *localContext = nil;
                                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                     
                                                     localContext  = [NSManagedObjectContext MR_contextForCurrentThread];
                                                     
                                                     CDPagination *paging = [CDPagination MR_createInContext:localContext];
                                                     [paging setWithDictionary:[response objectForKey:@"pagination"]];
                                                     
                                                     NSArray *responseObjects = [response objectForKey:@"data"];
                                                     [responseObjects enumerateObjectsUsingBlock:^(NSDictionary *object, NSUInteger idx, BOOL *stop){
                                                         CDFeed *feed = [CDFeed MR_createInContext:localContext];
                                                         feed.pagingIndex = @(self_.pagingIndex);
                                                         [feed setWithDictionary:object];
                                                     }];
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         self_.loading = NO;
                                                         self_.lastUpdateDate = [NSDate date];
                                                         [[NSUserDefaults standardUserDefaults] setValue:self_.lastUpdateDate forKey:kKMLastSavedDate];
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
                                             failure:^(AFHTTPRequestOperation *opertaion, NSError *error) {
                                                 self_.lastUpdateDate  = [[NSUserDefaults standardUserDefaults] objectForKey:kKMLastSavedDate];
                                                 self_.loading = NO;
                                                 if (completion) {
                                                     completion(nil, error);
                                                 }
                                             }];
}


- (void)pagingUserFeedWithCount:(NSInteger)count
                          minId:(NSString *)minId
                          maxId:(NSString *)maxId
                     completion:(CompletionBlock)completion
{
    NSMutableDictionary* parameters = [self baseParams];
    [parameters setObject:@(count) forKey:@"count"];
    if (minId) [parameters setObject:minId forKey:@"min_id"];
    if (maxId) [parameters setObject:maxId forKey:@"max_id"];
    
    __weak KMDataCacheRequestManager *self_ = self;
    [[KMInstagramRequestClient sharedClient] getPath:@"users/self/feed"
                                          parameters:parameters
                                             success:^(AFHTTPRequestOperation *opertaion, NSDictionary *response) {
                                                 
                                                 self_.pagingIndex ++;
                                                 self_.nextMaxId = [[response objectForKey:@"pagination"] objectForKey:@"next_max_id"];
                                                
                                                 __block NSManagedObjectContext *localContext = nil;
                                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                                                     localContext  = [NSManagedObjectContext MR_contextForCurrentThread];
                                                     NSArray *responseObjects = [response objectForKey:@"data"];
                                                     [responseObjects enumerateObjectsUsingBlock:^(NSDictionary *object, NSUInteger idx, BOOL *stop){
                                                         CDFeed *feed = [CDFeed MR_createInContext:localContext];
                                                         feed.pagingIndex = @(self_.pagingIndex);
                                                         [feed setWithDictionary:object];
                                                     }];
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         if (completion)
                                                         {
                                                             [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL sucess, NSError *error){
                                                                 if (sucess) {
                                                                    NSLog(@"GOOD");
                                                                    completion(@(YES), nil);
                                                                 }else {
                                                                    NSLog(@"ERROR");
                                                                    completion(nil, error);
                                                                 }
                                                             }];
                                                         }
                                                     });
                                                 });
                                             }
                                             failure:^(AFHTTPRequestOperation *opertaion, NSError *error) {
                                                 if (completion) {
                                                     completion(nil, error);
                                                 }
                                             }];
}


@end
