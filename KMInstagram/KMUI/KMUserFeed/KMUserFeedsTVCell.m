//
//  KMUserFeedsTVCell.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMUserFeedsTVCell.h"
#import "KMFeed.h"
#import "KMUser.h"
#import "KMCaption.h"
#import "KMTag.h"
#import "KMComment.h"
#import "UIImageView+AFNetworking.h"
#import "NSDateFormatter+Extensions.h"

@interface KMUserFeedsTVCell()
@property (nonatomic, strong) IBOutlet UIImageView *userImageView;
@property (nonatomic, strong) IBOutlet UIImageView *mainImageView;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *postDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *likesCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *commentsCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *captionCommentLabel;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@end

@implementation KMUserFeedsTVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)reloadData
{
    KMFeed *feed = (KMFeed *)self.object;
    [self.userImageView setImageWithURL:[NSURL URLWithString:feed.user.profile_picture] placeholderImage:nil];
    [self.mainImageView setImageWithURL:[NSURL URLWithString:feed.imageLink] placeholderImage:[UIImage imageNamed:@"background"]];
    self.userNameLabel.text = feed.user.username;
    self.postDateLabel.text = [NSDateFormatter VK_formattedStringFromDate:feed.created_time];
    self.likesCountLabel.text = [NSString stringWithFormat:@"%@ likes",feed.likesCount];
    self.commentsCountLabel.text = [NSString stringWithFormat:@"%@ comments",feed.commentsCount];
    self.captionCommentLabel.text = feed.caption.text;
    if (feed.user_has_liked) {
        [self.likeButton setSelected:YES];
    }else {
        [self.likeButton setSelected:NO];
    }
}

- (IBAction)likeButtonDidPressed:(UIButton *)sender
{
    if (sender.isSelected)
        [sender setSelected:NO];
    else
        [sender setSelected:YES];
    
    if (self.likeButtonPressHandler)
    {
        KMFeed *feed = (KMFeed *)self.object;
        self.likeButtonPressHandler(feed);
    }
}

@end
