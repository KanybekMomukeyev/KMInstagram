//
//  KMPagination.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//


#import "KMStoroableProtocol.h"
@interface KMPagination : NSObject <KMStorableItemProtocol>
@property (readonly, nonatomic, strong) NSString *nextUrl;
@property (readonly, nonatomic, strong) NSString *next_max_id;
@end
