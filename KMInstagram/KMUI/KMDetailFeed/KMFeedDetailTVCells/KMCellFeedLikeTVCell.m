//
//  KMCellFeedLikeTVCell.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMCellFeedLikeTVCell.h"
#import "CDUser.h"
#import "UIImageView+AFNetworking.h"

@interface KMCellFeedLikeTVCell()
@property (nonatomic, strong) IBOutlet UIImageView *userImageView;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *userFullNameLabel;
@end

@implementation KMCellFeedLikeTVCell

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
    CDUser *user = (CDUser *)self.object;
    self.userNameLabel.text = user.username;
    self.userFullNameLabel.text = user.full_name;
    if (user.profile_picture) {
        [self.userImageView setImageWithURL:[NSURL URLWithString:user.profile_picture] placeholderImage:nil];
    }
}

@end
