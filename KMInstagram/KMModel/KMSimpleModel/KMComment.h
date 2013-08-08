//
//  KMComment.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMStoroableProtocol.h"
#import "KMUser.h"

@interface KMComment : NSObject<KMStorableItemProtocol>
@property (readonly, nonatomic, strong) NSDate *created_time;
@property (readonly, nonatomic, strong) NSString *text;
@property (readonly, nonatomic, strong) NSString *commentId;
@property (readonly, nonatomic, strong) KMUser *user;
@end
