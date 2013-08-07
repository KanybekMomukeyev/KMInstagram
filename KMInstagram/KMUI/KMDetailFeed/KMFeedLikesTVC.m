//
//  KMFeedLikesTVC.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMFeedLikesTVC.h"
#import "KMAPIController.h"
#import "KMLikesCommentsReqManager.h"
#import "KMTableAnimatingHeaderView.h"
#import "UIView+NIB.h"
#import "KMCellFeedLikeTVCell.h"

@interface KMFeedLikesTVC ()
@property (nonatomic, strong) NSArray *likesArray;
@end

@implementation KMFeedLikesTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerCellsWithReuses:@[[KMCellFeedLikeTVCell reuseIdentifier]]];
    __weak KMFeedLikesTVC *self_ = self;
    [[[KMAPIController sharedInstance] likesCommentsReqManager] getLikesForFeedId:self.feedId
                                                                   withCompletion:^(NSArray *response, NSError *error){
                                                                       if (!error) {
                                                                            self_.likesArray = response;
                                                                            NSMutableArray *indexPathsArray = [NSMutableArray new];
                                                                            for (NSUInteger index = 0; index < self_.likesArray.count; index ++) {
                                                                                [indexPathsArray  addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                                                                            }
                                                                            [self_.tableView beginUpdates];
                                                                            [self_.tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationTop];
                                                                            [self_.tableView endUpdates];
                                                                       }else {
                                                                           [self_ showAlertWithError:error];
                                                                       }
                                                                   }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.likesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMCellFeedLikeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:[KMCellFeedLikeTVCell reuseIdentifier]];
    if (!cell) {
        cell = [[KMCellFeedLikeTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:[KMCellFeedLikeTVCell reuseIdentifier]];
    }
    cell.object = [self.likesArray objectAtIndex:indexPath.row];
    [cell reloadData];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

@end
