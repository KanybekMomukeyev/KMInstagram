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

#pragma mark - setup blocks
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

#pragma mark - Did get objects
- (void)doneLoadingTableViewData
{
    if ([[[KMAPIController sharedInstance] cachedRequestManager] lastUpdateDate]) {
        self.lastUpdateDate = [[[KMAPIController sharedInstance] cachedRequestManager] lastUpdateDate];
        [self.refreshHeaderView refreshLastUpdatedDate];
    }
    [super doneLoadingTableViewData];
    [self insertIndexPaths:[self indexPathsArrayFromStartIndex:0 withEndIndex:(self.feedsArray.count + 1)]];
}

#pragma mark - Get older feeds
- (void)fetchOldFeeds
{
    NSString *nextMaxId = [[KMAPIController sharedInstance] cachedRequestManager].nextMaxId;
    if (nextMaxId) {
        [[[KMAPIController sharedInstance] cachedRequestManager] pagingUserFeedWithCount:kKMInstagramFeedPageCount
                                                                                   minId:nil
                                                                                   maxId:nextMaxId
                                                                              completion:self.pagingHandler];
    }else {
        [self showAlertWithTitle:@"ALL USER FEEDS DOWNLOADED, NO MORE FOUND"];
        [self removePagingCellForRow:self.feedsArray.count];
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
        NSLog(@"NEEDED = SECTION = %d  ROW = %d", indexPath.section, indexPath.row);
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
