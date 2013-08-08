//
//  KMDataStoreManager.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMDataStoreManager.h"
#import "CDFeed.h"
#import "CDPagination.h"

@interface KMBaseDataStoreManager()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

@implementation KMDataStoreManager

- (void)deleteAllFeeds
{
    NSManagedObjectContext *localContext  = [NSManagedObjectContext MR_contextForCurrentThread];
    NSArray *feeds = [CDFeed MR_findAll];
    [feeds enumerateObjectsUsingBlock:^(CDFeed *feed, NSUInteger idx, BOOL *stop){
        [localContext deleteObject:feed];
    }];
    
    [localContext MR_saveToPersistentStoreAndWait];
}

- (void)deleteAllFeedsWherePageIndexIsNotZero
{
    NSManagedObjectContext *localContext  = [NSManagedObjectContext MR_contextForCurrentThread];
    NSArray *feeds = [CDFeed MR_findAll];
    [feeds enumerateObjectsUsingBlock:^(CDFeed *feed, NSUInteger idx, BOOL *stop){
        if ([feed.pagingIndex integerValue] != 0) {
            [localContext deleteObject:feed];
        }
    }];
    [localContext MR_saveToPersistentStoreAndWait];
}

- (void)deleteAllPagination
{
    NSManagedObjectContext *localContext  = [NSManagedObjectContext MR_contextForCurrentThread];
    NSArray *paginations = [CDPagination MR_findAll];
    [paginations enumerateObjectsUsingBlock:^(CDPagination *pagination, NSUInteger idx, BOOL *stop){
        [localContext deleteObject:pagination];
    }];
    
    [localContext MR_saveToPersistentStoreAndWait];
}

@end
