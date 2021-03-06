//
//  KMBaseTableVC.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMBaseTableVC : UITableViewController

- (BOOL)currentDeviceIsIphone;

- (id)initWithIphoneFromNib;
- (id)initWithIpadFromNib;

- (void)registerCellsWithReuses:(NSArray *)reuses;

- (void)showAlertWithError:(NSError *)error;
- (void)showAlertWithTitle:(NSString *)title;

@end
