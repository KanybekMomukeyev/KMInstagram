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
#import "KMLoadingTVCell.h"
#import "KMLikesCommentsReqManager.h"
#import "CDFeed.h"
#import "CDUser.h"
#import "CDCaption.h"
#import "CDPagination.h"
#import "KMDataStoreManager.h"

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

- (void)insertIndexPaths:(NSArray *)indexPathsArray;
- (UITableViewCell *)loadingCell;
- (void)stopAnimatingLoadingCell;

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

#pragma mark -

- (NSArray *)getFeedsForCurrentPaging
{
    NSUInteger pagingIndex = [[[KMAPIController sharedInstance] cachedRequestManager] pagingIndex];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pagingIndex == %@", @(pagingIndex)];
    return [CDFeed MR_findAllSortedBy:@"created_time" ascending:NO withPredicate:predicate];
}

- (void)setUpBlocks
{
    __weak KMUserFeedTVC *self_ = self;
    self.refreshHandler = ^(NSNumber *sucess, NSError *error) {
        if (error) {
            [self_ showAlertWithError:error];
        }
        
        CDPagination *pagination = [[CDPagination MR_findAll] lastObject];
        [[[KMAPIController sharedInstance] cachedRequestManager] setNextMaxId:pagination.next_max_id];
        
        [self_.feedsArray removeAllObjects];
        [self_.tableView reloadData];
        [self_.feedsArray addObjectsFromArray:[self_ getFeedsForCurrentPaging]];
        [self_ doneLoadingTableViewData];
    };
    
    self.pagingHandler = ^(NSNumber *sucess, NSError *error) {
        if (error) {
            [self_ showAlertWithError:error];
            [self_ stopAnimatingLoadingCell];
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
            [[[KMAPIController sharedInstance] likesCommentsReqManager] removeLikeForFeedId:feed.feedId
                                                                             withCompletion:^(id response, NSError *error){
                                                                                 if (!error)
                                                                                 {
                                                                                     NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
                                                                                     NSPredicate *taskPredicate = [NSPredicate predicateWithFormat:@"feedId == %@", feed.feedId];
                                                                                     CDFeed *toChangeFeed = [[self_.feedsArray filteredArrayUsingPredicate:taskPredicate] lastObject];
                                                                                     NSLog(@"%@",toChangeFeed.user.username);
                                                                                     toChangeFeed.user_has_liked = @(NO);
                                                                                     [localContext MR_saveToPersistentStoreAndWait];
                                                                                 }
                                                                             }];
        }else {
            [[[KMAPIController sharedInstance] likesCommentsReqManager] postLikeForFeedId:feed.feedId
                                                                           withCompletion:^(id response, NSError *error) {
                                                                               if (!error)
                                                                               {
                                                                                   NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];    
                                                                                   NSPredicate *taskPredicate = [NSPredicate predicateWithFormat:@"feedId == %@", feed.feedId];
                                                                                   CDFeed *toChangeFeed = [[self_.feedsArray filteredArrayUsingPredicate:taskPredicate] lastObject];
                                                                                   NSLog(@"%@",toChangeFeed.user.username);
                                                                                   toChangeFeed.user_has_liked = @(YES);
                                                                                   [localContext MR_saveToPersistentStoreAndWait];
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

#pragma mark - Did refreshed
- (void)doneLoadingTableViewData
{
    if ([[[KMAPIController sharedInstance] cachedRequestManager] lastUpdateDate]) {
        self.lastUpdateDate = [[[KMAPIController sharedInstance] cachedRequestManager] lastUpdateDate];
        [self.refreshHeaderView refreshLastUpdatedDate];
    }
    [super doneLoadingTableViewData];
    NSMutableArray *indexPathsArray = [NSMutableArray new];
    for (NSUInteger index = 0; index < self.feedsArray.count + 1; index ++) {
        [indexPathsArray  addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    [self insertIndexPaths:indexPathsArray];
}

- (void)fetchOldFeeds
{
    NSString *nextMaxId = [[KMAPIController sharedInstance] cachedRequestManager].nextMaxId;
    if (nextMaxId) {
        [[[KMAPIController sharedInstance] cachedRequestManager] pagingUserFeedWithCount:kKMInstagramFeedPageCount
                                                                                   minId:nil
                                                                                   maxId:nextMaxId
                                                                              completion:self.pagingHandler];
    }else {
        [self stopAnimatingLoadingCell];
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.feedsArray.count)
        return 408;
    else
        return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.feedsArray.count == 0) {
        return 0;
    }else {
        return self.feedsArray.count + 1;
    }
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
        [self fetchOldFeeds];
        return [self loadingCell];
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
