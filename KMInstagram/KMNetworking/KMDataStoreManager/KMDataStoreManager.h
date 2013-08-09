//
//  KMDataStoreManager.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMBaseDataStoreManager.h"

@interface KMDataStoreManager : KMBaseDataStoreManager

- (void)deleteAllFeeds;
- (void)deleteAllCommands;
- (void)deleteAllFeedsWherePageIndexIsNotZero;
- (void)deleteAllPagination;

@end
