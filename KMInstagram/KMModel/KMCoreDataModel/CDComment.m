//
//  CDComment.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "CDComment.h"
#import "CDFeed.h"
#import "CDUser.h"


@implementation CDComment

@dynamic created_time;
@dynamic text;
@dynamic commentId;
@dynamic user;
@dynamic feed;

- (void)setWithDictionary:(NSDictionary *)dict {
    
}

/*
 "comments": {
 "count": 1,
 "data": [
     {
     "created_time": "1375785454",
     "text": "#swissmade #swisswatches #watches",
     "id": "516448281123639873",
     "from": {
     "profile_picture": "http://images.ak.instagram.com/profiles/profile_472783859_75sq_1374282112.jpg",
     "username": "mister_werewolf",
     "id": "472783859",
     "full_name": "Віталій Ткачук"
     }
 }
 ]
 }
 */

@end
