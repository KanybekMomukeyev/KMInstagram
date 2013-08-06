//
//  KMBaseRefreshTVC.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMBaseRefreshTVC.h"

@interface KMBaseRefreshTVC ()<EGORefreshTableHeaderDelegate>
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, getter = isRefreshInProgress) BOOL refreshInProgress;
@property (nonatomic, retain) NSDate *lastUpdateDate;
- (void)attachPullToRefreshHeader;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end

@implementation KMBaseRefreshTVC

@synthesize refreshHeaderView = refreshHeaderView_;
@synthesize refreshInProgress = refreshInProgress_;
@synthesize lastUpdateDate = lastUpdateDate_;

- (void)dealloc {
    NSLog(@"[%@ %@];", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}

#pragma mark - EGORefreshTableHeaderView staff

- (void)attachPullToRefreshHeader {
    if (self.refreshHeaderView == nil) {
		self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		self.refreshHeaderView.delegate = self;
        self.refreshHeaderView.backgroundColor = [UIColor clearColor];
		[self.tableView addSubview:self.refreshHeaderView];
	}
    [self.refreshHeaderView refreshLastUpdatedDate];
}

- (void)reloadTableViewDataSource {
    self.refreshInProgress = YES;
    [self.refreshHeaderView setState:EGOOPullRefreshLoading];
}

- (void)doneLoadingTableViewData {
    self.refreshInProgress = NO;
	[self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0.0) {
        [self.refreshHeaderView refreshLastUpdatedDate];
    }
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return self.refreshInProgress;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return self.lastUpdateDate;
}

#pragma mark - Table cell selection style
+(UIView*)cellSelectionStyleView {
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:84.0f/255 green:65.0f/255 blue:134.0f/255 alpha:1.0f]];
    return bgColorView;
}

@end