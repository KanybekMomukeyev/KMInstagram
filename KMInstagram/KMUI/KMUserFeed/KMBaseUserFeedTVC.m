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
#import "KMLoadingTVCell.h"

@interface KMBaseUserFeedTVC ()
- (void)insertIndexPaths:(NSArray *)indexPathsArray;
- (void)stopAnimatingLoadingCellForRow:(NSUInteger )row;
@end

@implementation KMBaseUserFeedTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", @"")
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(logOut:)];
    self.navigationItem.rightBarButtonItem = doneBarItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (void)stopAnimatingLoadingCellForRow:(NSUInteger )row
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    KMLoadingTVCell *loadingCell = (KMLoadingTVCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [loadingCell.indicatorView stopAnimating];
    loadingCell.indicatorView.hidden = YES;
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
