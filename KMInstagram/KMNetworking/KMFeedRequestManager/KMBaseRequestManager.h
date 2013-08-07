//
//  KMBaseRequestManager.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KMPagination;

@interface KMBaseRequestManager : NSObject
@property (nonatomic, getter = isLoading) BOOL loading;
@property (nonatomic, strong, readonly) NSDate *lastUpdateDate;
@property (nonatomic, strong, readonly) KMPagination *pagination;
- (NSMutableDictionary *)baseParams;

@end
