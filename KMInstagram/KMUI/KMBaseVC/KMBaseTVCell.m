//
//  KMBaseTVCell.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMBaseTVCell.h"

@implementation KMBaseTVCell

- (void)dealloc {
    NSLog(@"[%@ %@];", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)reloadData {
    NSLog(@"[%@ %@]; Does nothing! Should be overriden in subclasses!!", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (NSString *)reuseIdentifier {
    return self.class.reuseIdentifier;
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self.class);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    [super willTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
        /*
         for (UIView *subview in self.subviews) {
         if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
         }
         }
         */
    }
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
    [super didTransitionToState:state];
    if (state == UITableViewCellStateShowingDeleteConfirmationMask || state == UITableViewCellStateDefaultMask) {
        /*
         for (UIView *subview in self.subviews) {
         if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
         }
         }*/
    }
}

@end
