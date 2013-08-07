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


/*
"user": {
    "profile_picture": "http://images.ak.instagram.com/profiles/profile_472783859_75sq_1374282112.jpg",
    "username": "mister_werewolf",
    "id": "472783859",
    "full_name": "Віталій Ткачук",
}
*/