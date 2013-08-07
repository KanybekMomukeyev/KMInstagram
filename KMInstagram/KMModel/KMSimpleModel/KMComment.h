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


/*
"comments": {
    "count": 1,
    "data": [
             {
                 "created_time": "1375782180",
                 "text": "Nice flashback :)",
                 "id": "516420819999936713",
                 "from": {
                     "profile_picture": "http://images.ak.instagram.com/profiles/profile_254650461_75sq_1374748953.jpg",
                     "username": "state_of_love",
                     "id": "254650461",
                     "full_name": "Kik: Hero.Of.Love"
                 }
             }
             ]
}*/