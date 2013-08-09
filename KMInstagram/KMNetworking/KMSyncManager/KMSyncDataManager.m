//
//  KMSyncDataManager.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/8/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMSyncDataManager.h"
#import "CDCommandModel.h"
#import "KMAPIController.h"
#import "KMLikesCommentsReqManager.h"
#import "Sequencer.h"

@interface KMSyncDataManager()
@property (nonatomic) BOOL syncingDB;
@end

@implementation KMSyncDataManager

- (void)syncWithRemoteService
{
    if (self.syncingDB) return;
    
    self.syncingDB = YES;
    
    NSArray *commandsArray = [CDCommandModel MR_findAllSortedBy:@"sortIndex" ascending:YES];
    [commandsArray enumerateObjectsUsingBlock:^(CDCommandModel *commandModel, NSUInteger idx, BOOL *stop) {
        NSLog(@"commandModel.sortIndex = %@", commandModel.sortIndex);
        NSLog(@"commandModel.method    = %@", commandModel.method);
        NSLog(@"commandModel.feedId    = %@", commandModel.feedId);
        NSLog(@" ");
    }];
    if (commandsArray.count == 0) {
        self.syncingDB = NO;
        return;
    }
    [self runSequncerWithArray:commandsArray];
}

- (void)runSequncerWithArray:(NSArray *)array
{
    __weak KMSyncDataManager *self_ = self;
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    Sequencer *sequencer = [Sequencer new];
    [array enumerateObjectsUsingBlock:^(CDCommandModel *commandModel, NSUInteger idx, BOOL *stop) {        
        /* add block of code, to run synchronously */
        [sequencer enqueueStep:^(NSNumber *sucess, SequencerCompletion sequencerCompletion) {
            
            if ([sucess integerValue] == kKMSuccessDoneLikeMethod)
            {
                if ([commandModel.method integerValue] == KMDeleteSyncCommand)
                {
                    NSLog(@"  ____ chekPoint = %@  method = %@_____  ", commandModel.sortIndex, commandModel.method);
                    [[[KMAPIController sharedInstance] likesCommentsReqManager] removeLikeForFeedId:commandModel.feedId
                                                                                     withCompletion:^(id response, NSError *error) {
                                                                                         if (!error) {
                                                                                             [commandModel MR_deleteInContext:localContext];
                                                                                             [localContext MR_saveToPersistentStoreAndWait];
                                                                                             sequencerCompletion(@(kKMSuccessDoneLikeMethod));
                                                                                         }else {
                                                                                             sequencerCompletion(nil);
                                                                                         }
                                                                                     }];
                }else if([commandModel.method integerValue] == KMPostSyncCommand)
                {
                    NSLog(@"  ____ chekPoint = %@  method = %@_____  ", commandModel.sortIndex, commandModel.method);
                    [[[KMAPIController sharedInstance] likesCommentsReqManager] postLikeForFeedId:commandModel.feedId
                                                                                   withCompletion:^(id response, NSError *error) {
                                                                                       if (!error) {
                                                                                           [commandModel MR_deleteInContext:localContext];
                                                                                           [localContext MR_saveToPersistentStoreAndWait];
                                                                                           sequencerCompletion(@(kKMSuccessDoneLikeMethod));
                                                                                       }else {
                                                                                           sequencerCompletion(nil);
                                                                                       }
                                                                                   }];
                }
            }
            else {
                NSLog(@"   ERROR HAPPENED IN HTTP REQUEST DELETE OR POST ");
                sequencerCompletion(nil);
            }
        }];
    }];
    
    [sequencer enqueueStep:^(NSNumber *sucess, SequencerCompletion completion) {
        self_.syncingDB = NO;
        NSLog(@" THE LAST STEP ");
        completion(nil);
    }];
    
    [sequencer run];
}

- (void)addSyncModelWithMethod:(KMSyncCommandType)method httpPath:(NSString *)path feedId:(NSString *)feedId
{
    NSManagedObjectContext *localContext  = [NSManagedObjectContext MR_contextForCurrentThread];
    CDCommandModel *commandModel = [CDCommandModel MR_createInContext:localContext];
    commandModel.method = @(method);
    commandModel.sortIndex = @([CDCommandModel MR_countOfEntities]);
    commandModel.feedId = feedId;
    commandModel.path = path;
    [localContext MR_saveToPersistentStoreAndWait];
}

@end
