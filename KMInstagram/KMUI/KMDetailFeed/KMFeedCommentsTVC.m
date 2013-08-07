//
//  KMFeedCommentsTVC.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMFeedCommentsTVC.h"
#import "KMAPIController.h"
#import "KMLikesCommentsReqManager.h"
#import "KMCommentTVCell.h"
#import "CDComment.h"

@interface KMFeedCommentsTVC ()
@property (nonatomic, strong) NSArray *comments;
@end

@implementation KMFeedCommentsTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerCellsWithReuses:@[[KMCommentTVCell reuseIdentifier]]];
    __weak KMFeedCommentsTVC *self_ = self;
    [[[KMAPIController sharedInstance] likesCommentsReqManager] getCommentsForFeedId:self.feedId
                                                                      withCompletion:^(NSArray *response, NSError *error){
                                                                          if (!error) {
                                                                              self_.comments = response;
                                                                              NSMutableArray *indexPathsArray = [NSMutableArray new];
                                                                              for (NSUInteger index = 0; index < self_.comments.count; index ++) {
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

#define PADDING 10
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDComment *comment = [self.comments objectAtIndex:indexPath.row];
    NSString *text = [NSString stringWithFormat:@"%@",comment.text];
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:12]
                       constrainedToSize:CGSizeMake(270 - PADDING * 3, 1000.0f)];
    CGFloat height = 41 + textSize.height;
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMCommentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:[KMCommentTVCell reuseIdentifier]];
    if (!cell) {
        cell = [[KMCommentTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:[KMCommentTVCell reuseIdentifier]];
    }
    cell.object = [self.comments objectAtIndex:indexPath.row];
    [cell reloadData];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

@end
