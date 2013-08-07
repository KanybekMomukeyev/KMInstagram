//
//  KMCaption.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMStoroableProtocol.h"
#import "KMUser.h"

@interface KMCaption : NSObject<KMStorableItemProtocol>
@property (readonly, nonatomic, strong) NSDate *created_time;
@property (readonly, nonatomic, strong) NSString *text;
@property (readonly, nonatomic, strong) NSString *captionId;
@property (readonly, nonatomic, strong) KMUser *user;
@end


/*
"caption": {
    "created_time": "1375785305",
    "text": "Радості немає меж :)",
    "id": "516447032101851681",
    "from": {
        "profile_picture": "http://images.ak.instagram.com/profiles/profile_472783859_75sq_1374282112.jpg",
        "username": "mister_werewolf",
        "id": "472783859",
        "full_name": "Віталій Ткачук"
    }
}
*/