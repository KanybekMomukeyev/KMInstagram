//
//  KMBaseUserFeedTVC.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMBaseUserFeedTVC.h"
#import "KMLoginVC.h"
#import "KMAPIController.h"
#import "KMUserAuthManager.h"
#import "KMUserFeedsTVCell.h"
#import "KMDataCacheRequestManager.h"
#import "CDFeed.h"
#import "FGPagingTableViewCell.h"


@interface KMBaseUserFeedTVC ()

- (NSArray *)getFeedsForCurrentPaging;
- (NSMutableArray *)indexPathsArrayFromStartIndex:(NSUInteger)startIndex withEndIndex:(NSUInteger)endIndex;
- (void)insertIndexPaths:(NSArray *)indexPathsArray;

- (FGPagingTableViewCell *)pagingCellWithType:(FGPagingCellType)pagedCellType;
- (void)removePagingCellForRow:(NSUInteger )row;

@property (nonatomic, strong, readwrite) FGPagingTableViewCell *pagingCell;
@end


@implementation KMBaseUserFeedTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerCellsWithReuses:@[[KMUserFeedsTVCell reuseIdentifier]]];
    [self.tableView registerNib:[UINib nibWithNibName:@"FGPagingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FGPagingTableViewCell"];
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", @"") style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(logOut:)];
    self.navigationItem.rightBarButtonItem = doneBarItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSArray *)getFeedsForCurrentPaging
{
    NSUInteger pagingIndex = [[[KMAPIController sharedInstance] cachedRequestManager] pagingIndex];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pagingIndex == %@", @(pagingIndex)];
    NSArray *array = [CDFeed MR_findAllSortedBy:@"created_time" ascending:NO withPredicate:predicate];
    return array;
}

- (NSArray *)indexPathsArrayFromStartIndex:(NSUInteger)startIndex withEndIndex:(NSUInteger)endIndex
{
    NSMutableArray *indexPathsArray = [NSMutableArray new];
    for (NSUInteger index = startIndex; index < startIndex + endIndex; index ++) {
        [indexPathsArray  addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    return [NSArray arrayWithArray:indexPathsArray];
}

#pragma mark -
- (void)logOut:(id)sender
{
    [[[KMAPIController sharedInstance] userAuthManager] logOut];
    KMLoginVC *loginVC = [[KMLoginVC alloc] initWithIphoneFromNib];
    [self.navigationController setViewControllers:@[loginVC] animated:YES];
}

- (void)insertIndexPaths:(NSArray *)indexPathsArray
{
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}


#pragma mark - Paging Cell
- (FGPagingTableViewCell *)pagingCellWithType:(FGPagingCellType)pagedCellType
{
	FGPagingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FGPagingTableViewCell"];
	cell.cellType = pagedCellType;
	self.pagingCell = cell;
	return cell;
}

- (void)removePagingCellForRow:(NSUInteger )row
{
    FGPagingTableViewCell *cell = (FGPagingTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell setCellType:FGPagingCellTypeContinue];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

@end
