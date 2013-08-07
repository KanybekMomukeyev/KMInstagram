//
//  KMCommentTVCell.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMCommentTVCell.h"
#import "CDUser.h"
#import "CDComment.h"
#import "UIImageView+AFNetworking.h"

@interface KMCommentTVCell()
@property (nonatomic, strong) IBOutlet UIImageView *userImageView;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@end

@implementation KMCommentTVCell

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

#define PADDING 10
- (void)reloadData
{
    CDComment *comment = (CDComment *)self.object;
    if (comment.user.profile_picture) {
        [self.userImageView setImageWithURL:[NSURL URLWithString:comment.user.profile_picture] placeholderImage:nil];
    }
    self.userNameLabel.text = comment.user.username;
    
    NSString *text = [NSString stringWithFormat:@"%@",comment.text];
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:12]
                       constrainedToSize:CGSizeMake(270 - PADDING * 3, 1000.0f)];
    CGFloat height = 41 + textSize.height;
    self.textView.frame = CGRectMake(50, 21, 270, height);
    self.textView.text = text;
}


@end
