//
//  KMUserFeedTVC.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMUserFeedTVC.h"
#import "KMLoginVC.h"
#import "KMAPIController.h"
#import "KMUserAuthManager.h"
#import "KMUserFeedsTVCell.h"
#import "KMFeedRequestManager.h"
#import "KMFeedDetailContainerVC.h"
#import "KMLoadingTVCell.h"
#import "KMPagination.h"
#define kKMInstagramFeedPageCount 20

@interface KMBaseRefreshTVC ()
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, getter = isRefreshInProgress) BOOL refreshInProgress;
@property (nonatomic, retain) NSDate *lastUpdateDate;
- (void)attachPullToRefreshHeader;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end


@interface KMUserFeedTVC ()
@property (nonatomic, strong) NSMutableArray *feedsArray;
@property (nonatomic, copy) CompletionBlock refreshHandler;
@property (nonatomic, copy) CompletionBlock pagingHandler;
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
    [self attachPullToRefreshHeader];
    [self registerCellsWithReuses:@[[KMUserFeedsTVCell reuseIdentifier], [KMLoadingTVCell reuseIdentifier]]];
    
    __weak KMUserFeedTVC *self_ = self;
    self.refreshHandler = ^(NSArray *array, NSError *error) {
        if (error) {
            [self_ showAlertWithError:error];
            [super doneLoadingTableViewData];
        } else {
            [self_.feedsArray removeAllObjects];
            [self_.tableView reloadData];
            [self_.feedsArray addObjectsFromArray:array];
            [self_ doneLoadingTableViewData];
        }
    };
    
    self.pagingHandler = ^(NSArray *oldFeeds, NSError *error) {
        if (error) {
            [self_ showAlertWithError:error];
            [self_ stopAnimatingLoadingCell];
        }else
        {
            NSMutableArray *indexPathsArray = [NSMutableArray new];
            for (NSUInteger index = self_.feedsArray.count; index < self_.feedsArray.count + oldFeeds.count; index ++) {
                [indexPathsArray  addObject:[NSIndexPath indexPathForRow:index inSection:0]];
            }   
            [self_.feedsArray addObjectsFromArray:oldFeeds];
            [self_.tableView beginUpdates];
            [self_.tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationTop];
            [self_.tableView endUpdates];
        }
    };
    
    
    [self reloadTableViewDataSource];
    [self.refreshHeaderView setState:[[[KMAPIController sharedInstance] feedRequestManager] isLoading] ? EGOOPullRefreshLoading : EGOOPullRefreshNormal];
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", @"")
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(logOut:)];
    self.navigationItem.rightBarButtonItem = doneBarItem;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[[KMAPIController sharedInstance] feedRequestManager] isLoading]) {
        [self.tableView setContentOffset:CGPointMake(0.0, -54.0) animated:animated];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)logOut:(id)sender
{
    [[[KMAPIController sharedInstance] userAuthManager] logOut];
    KMLoginVC *loginVC = [[KMLoginVC alloc] initWithIphoneFromNib];
    [self.navigationController setViewControllers:@[loginVC] animated:YES];
}


#pragma mark -
- (void)doneLoadingTableViewData
{
    self.lastUpdateDate = [[[KMAPIController sharedInstance] feedRequestManager] lastUpdateDate];
    [self.refreshHeaderView refreshLastUpdatedDate];
    [super doneLoadingTableViewData];

    NSMutableArray *indexPathsArray = [NSMutableArray new];
    for (NSUInteger index = 0; index < self.feedsArray.count + 1; index ++) {
        [indexPathsArray  addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

#pragma mark - Refresh
- (void)reloadTableViewDataSource {
    [super reloadTableViewDataSource];
    [[[KMAPIController sharedInstance] feedRequestManager] getUserFeedWithCount:kKMInstagramFeedPageCount
                                                                          minId:nil
                                                                          maxId:nil
                                                                     completion:self.refreshHandler];
}

- (void)fetchOldFeeds
{
    NSString *nextMaxId = [[KMAPIController sharedInstance] feedRequestManager].pagination.next_max_id;
    if (nextMaxId) {
        [[[KMAPIController sharedInstance] feedRequestManager] getUserFeedWithCount:kKMInstagramFeedPageCount
                                                                              minId:nil
                                                                              maxId:nextMaxId
                                                                         completion:self.pagingHandler];
    }else {
        [self stopAnimatingLoadingCell];
    }
}



#pragma mark -
- (void)stopAnimatingLoadingCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.feedsArray.count inSection:0];
    KMLoadingTVCell *loadingCell = (KMLoadingTVCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [loadingCell.indicatorView stopAnimating];
    loadingCell.indicatorView.hidden = YES;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.feedsArray.count)
    {
        return 408;
    }else {
        return 44;
    }
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
        cell.object = [self.feedsArray objectAtIndex:indexPath.row];
        [cell reloadData];
        return cell;
    }else
    {
        KMLoadingTVCell *cell = [tableView dequeueReusableCellWithIdentifier:[KMLoadingTVCell reuseIdentifier]];
        if (!cell) {
            cell = [[KMLoadingTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:[KMLoadingTVCell reuseIdentifier]];
        }
        cell.indicatorView.hidden = NO;
        [cell.indicatorView startAnimating];
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
