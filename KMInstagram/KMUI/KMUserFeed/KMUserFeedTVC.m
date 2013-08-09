//
//  KMUserFeedTVC.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMUserFeedTVC.h"
#import "KMAPIController.h"
#import "KMUserFeedsTVCell.h"
#import "KMDataCacheRequestManager.h"
#import "KMFeedDetailContainerVC.h"
#import "KMLikesCommentsReqManager.h"
#import "CDFeed.h"
#import "CDUser.h"
#import "CDCaption.h"
#import "CDPagination.h"
#import "KMDataStoreManager.h"
#import "FGPagingTableViewCell.h"
#import "KMDataStoreManager.h"
#import "KMSyncDataManager.h"

#define kKMInstagramFeedPageCount 5

@interface KMBaseRefreshTVC ()
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, getter = isRefreshInProgress) BOOL refreshInProgress;
@property (nonatomic, retain) NSDate *lastUpdateDate;
- (void)attachPullToRefreshHeader;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end

@interface KMBaseUserFeedTVC ()

- (NSArray *)getFeedsForCurrentPaging;
- (NSMutableArray *)indexPathsArrayFromStartIndex:(NSUInteger)startIndex withEndIndex:(NSUInteger)endIndex;
- (void)insertIndexPaths:(NSArray *)indexPathsArray;

- (FGPagingTableViewCell *)pagingCellWithType:(FGPagingCellType)pagedCellType;
- (void)removePagingCellForRow:(NSUInteger )row;

@end

@interface KMUserFeedTVC ()
@property (nonatomic, strong) NSMutableArray *feedsArray;
@property (nonatomic, copy) CompletionBlock refreshHandler;
@property (nonatomic, copy) CompletionBlock pagingHandler;
@property (nonatomic, copy) InfoBlock likePressHandler;
@end


@implementation KMUserFeedTVC

- (NSMutableArray *)feedsArray
{
    if (!_feedsArray) {
        _feedsArray = [NSMutableArray new];
    }
    return _feedsArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpBlocks];
    [self attachPullToRefreshHeader];
    [self reloadTableViewDataSource];
    [self.refreshHeaderView setState:[[[KMAPIController sharedInstance] cachedRequestManager] isLoading] ? EGOOPullRefreshLoading : EGOOPullRefreshNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[[KMAPIController sharedInstance] cachedRequestManager] isLoading]) {
        [self.tableView setContentOffset:CGPointMake(0.0, -54.0) animated:animated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)seedTableViewWithStoredData
{
    [self.feedsArray removeAllObjects];
    [self.tableView reloadData];
    [self.feedsArray addObjectsFromArray:[self getFeedsForCurrentPaging]];
    [self insertIndexPaths:[self indexPathsArrayFromStartIndex:0 withEndIndex:(self.feedsArray.count + 1)]];
}

#pragma mark - setup blocks
- (void)setUpBlocks
{
    __weak KMUserFeedTVC *self_ = self;
    self.refreshHandler = ^(NSNumber *sucess, NSError *error) {
        
        CDPagination *pagination = [[CDPagination MR_findAll] lastObject];
        [[[KMAPIController sharedInstance] cachedRequestManager] setNextMaxId:pagination.next_max_id];
        [self_ doneLoadingTableViewData];
        
        if (error) {
            [self_ showAlertWithError:error];
            if (self_.feedsArray.count == 0) {
                [[[KMAPIController sharedInstance] dataStoreManager] deleteAllFeedsWherePageIndexIsNotZero];
                [self_ seedTableViewWithStoredData];
            }
        }else {
            [self_ seedTableViewWithStoredData];
        }
    };
    
    self.pagingHandler = ^(NSNumber *sucess, NSError *error) {
        if (error) {
            [self_ showAlertWithError:error];
            [self_ removePagingCellForRow:self_.feedsArray.count];
        }else
        {
            NSArray *oldFeeds = [self_ getFeedsForCurrentPaging];
            NSMutableArray *indexPathsArray = [NSMutableArray new];
            for (NSUInteger index = self_.feedsArray.count; index < self_.feedsArray.count + oldFeeds.count; index ++) {
                [indexPathsArray  addObject:[NSIndexPath indexPathForRow:index inSection:0]];
            }
            [self_.feedsArray addObjectsFromArray:oldFeeds];
            [self_ insertIndexPaths:indexPathsArray];
        }
    };
    
    self.likePressHandler = ^(CDFeed *feed) {
        
        if ([feed.user_has_liked boolValue]) {
            [self_ updateFeedCellLikeCountWithIncreaseLike:NO toFeed:feed];
            [[[KMAPIController sharedInstance] likesCommentsReqManager] removeLikeForFeedId:feed.feedId
                                                                             withCompletion:^(id response, NSError *error){
                                                                                 if (!error) {
                                                                                 
                                                                                 }else {
                                                                                    [[[KMAPIController sharedInstance] syncDataManager] addSyncModelWithMethod:KMDeleteSyncCommand
                                                                                                                                                      httpPath:@"likes"
                                                                                                                                                        feedId:feed.feedId];
                                                                                 }
                                                                             }];
        }else {
            [self_ updateFeedCellLikeCountWithIncreaseLike:YES toFeed:feed];
            [[[KMAPIController sharedInstance] likesCommentsReqManager] postLikeForFeedId:feed.feedId
                                                                           withCompletion:^(id response, NSError *error) {
                                                                               if (!error){
                                                                               
                                                                               }else {
                                                                                   [[[KMAPIController sharedInstance] syncDataManager] addSyncModelWithMethod:KMPostSyncCommand
                                                                                                                                                     httpPath:@"likes"
                                                                                                                                                       feedId:feed.feedId];
                                                                               }
                                                                             }];
        }
    };
}


#pragma mark - Refresh
- (void)reloadTableViewDataSource {
    [super reloadTableViewDataSource];
    [[[KMAPIController sharedInstance] cachedRequestManager] getUserFeedWithCount:kKMInstagramFeedPageCount
                                                                       completion:self.refreshHandler];
}

#pragma mark - Update header date label
- (void)doneLoadingTableViewData
{
    self.lastUpdateDate = [[[KMAPIController sharedInstance] cachedRequestManager] lastUpdateDate];
    [self.refreshHeaderView refreshLastUpdatedDate];
    [super doneLoadingTableViewData];
}

#pragma mark - Update KMUserFeedsTVCell likes count
- (void)updateFeedCellLikeCountWithIncreaseLike:(BOOL)shoulIncrease toFeed:(CDFeed *)feed
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    feed.user_has_liked = @(shoulIncrease);
    NSInteger minusOrPlus  = shoulIncrease ? 1: -1;
    feed.likesCount = [NSString stringWithFormat:@"%d",([feed.likesCount integerValue] + minusOrPlus)];
    [localContext MR_saveToPersistentStoreAndWait];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows]
                           withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Get older feeds
- (void)fetchOldFeeds
{
    if ([[KMAPIController sharedInstance] cachedRequestManager].nextMaxId) {
        [[[KMAPIController sharedInstance] cachedRequestManager] pagingUserFeedWithCount:kKMInstagramFeedPageCount
                                                                                   minId:nil
                                                                                   maxId:[[KMAPIController sharedInstance] cachedRequestManager].nextMaxId
                                                                              completion:self.pagingHandler];
    }else {
        __weak KMUserFeedTVC *self_ = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
            [self_ showAlertWithTitle:@"ALL USER FEEDS DOWNLOADED, NO MORE FOUND"];
            [self_ removePagingCellForRow:self.feedsArray.count];
        });
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row < self.feedsArray.count) ? 408 : 78;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.feedsArray.count == 0) ? 0 : (self.feedsArray.count + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.feedsArray.count)
    {
        KMUserFeedsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:[KMUserFeedsTVCell reuseIdentifier]];
        if (!cell) {
            cell = [[KMUserFeedsTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:[KMUserFeedsTVCell reuseIdentifier]];
        }
        cell.likeButtonPressHandler = self.likePressHandler;
        cell.object = [self.feedsArray objectAtIndex:indexPath.row];
        [cell reloadData];
        return cell;
    }else
    {
        FGPagingTableViewCell *cell = [self pagingCellWithType:FGPagingCellTypeRetrieving];
        [self fetchOldFeeds];
        return cell;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.feedsArray.count)
    {
        KMFeedDetailContainerVC *detailVC = [[KMFeedDetailContainerVC alloc] initWithIphoneFromNib];
        detailVC.feed = [self.feedsArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
