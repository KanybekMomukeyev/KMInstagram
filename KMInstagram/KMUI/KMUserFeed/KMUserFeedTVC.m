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
@property (nonatomic, copy) CompletionBlock completionHandler;
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
    [self registerCellsWithReuses:@[[KMUserFeedsTVCell reuseIdentifier]]];
    
    __weak KMUserFeedTVC *self_ = self;
    self.completionHandler = ^(NSArray *array, NSError *error) {
        if (error) {
            [self_ showAlertWithError:error];
            [super doneLoadingTableViewData];
        } else {
            [self_.feedsArray removeAllObjects];
            [self_.feedsArray addObjectsFromArray:array];
            [self_ doneLoadingTableViewData];
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
    KMLoginVC *loginVC = [[KMLoginVC alloc] initWithIphoneFromNib];
    [self.navigationController setViewControllers:@[loginVC] animated:YES];
    [[[KMAPIController sharedInstance] userAuthManager] logOut];
}


#pragma mark -
- (void)doneLoadingTableViewData
{
    self.lastUpdateDate = [[[KMAPIController sharedInstance] feedRequestManager] lastUpdateDate];
    [self.refreshHeaderView refreshLastUpdatedDate];
    [super doneLoadingTableViewData];
    [self.tableView reloadData];
}

#pragma mark - Refresh
- (void)reloadTableViewDataSource {
    [super reloadTableViewDataSource];
    [[[KMAPIController sharedInstance] feedRequestManager] getUserFeedWithCount:23
                                                                          minId:nil
                                                                          maxId:nil
                                                                     completion:self.completionHandler];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 408;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMUserFeedsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:[KMUserFeedsTVCell reuseIdentifier]];
    if (!cell) {
        cell = [[KMUserFeedsTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:[KMUserFeedsTVCell reuseIdentifier]];
    }
    
    cell.object = [self.feedsArray objectAtIndex:indexPath.row];
    [cell reloadData];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
