//
//  KMBaseRefreshTVC.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "KMBaseTableVC.h"

@interface KMBaseRefreshTVC : KMBaseTableVC {
    EGORefreshTableHeaderView *refreshHeaderView_;
    BOOL refreshInProgress_;
    NSDate *lastUpdateDate_;
}

+(UIView*)cellSelectionStyleView;

@end
