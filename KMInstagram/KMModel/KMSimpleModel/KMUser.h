//
//  KMUser.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMStoroableProtocol.h"

@interface KMUser : NSObject<KMStorableItemProtocol>
@property (readonly, nonatomic, strong) NSString *profile_picture;
@property (readonly, nonatomic, strong) NSString *username;
@property (readonly, nonatomic, strong) NSString *userId;
@property (readonly, nonatomic, strong) NSString *full_name;
@end
