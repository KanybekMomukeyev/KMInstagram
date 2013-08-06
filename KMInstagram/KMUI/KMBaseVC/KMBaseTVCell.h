//
//  KMBaseTVCell.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMBaseTVCell : UITableViewCell

@property (nonatomic, strong) id object;

- (void)reloadData;

- (NSString *)reuseIdentifier;
+ (NSString *)reuseIdentifier;

@end
