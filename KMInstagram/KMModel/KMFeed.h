//
//  KMFeed.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMStoroableProtocol.h"
#import "KMCaption.h"
#import "KMUser.h"

@interface KMFeed : NSObject <KMStorableItemProtocol>

@property (readonly, nonatomic, strong) NSMutableArray *tagsArray;
@property (readonly, nonatomic, strong) NSMutableArray *commentsArray;
@property (readonly, nonatomic, strong) NSMutableArray *likesArray;

@property (readonly, nonatomic, strong) NSString *feedId;
@property (readonly, nonatomic, strong) NSString *link;
@property (readonly, nonatomic, strong) NSDate *created_time;
@property (readonly, nonatomic, strong) NSString *imageLink;
@property (readonly, nonatomic, strong) NSString *commentsCount;
@property (readonly, nonatomic, strong) NSString *likesCount;

@property (readonly, nonatomic, strong) KMCaption *caption;
@property (readonly, nonatomic, strong) KMUser *user;



/*
"id": "516511948466284326_46466272",
"user_has_liked": false,
"link": "http://instagram.com/p/crBOFqk-cm/",
"created_time": "1375785263",
 
"tags": [
         "beautiful",
         "fashion",
         ],
"type": "image",

"images": {
    "thumbnail": {
        "url": "http://distilleryimage6.s3.amazonaws.com/e04ef13efe9511e2ba1722000a1faed2_5.jpg",
        "width": 150,
        "height": 150
    },
    "low_resolution": {
        "url": "http://distilleryimage6.s3.amazonaws.com/e04ef13efe9511e2ba1722000a1faed2_6.jpg",
        "width": 306,
        "height": 306
    },
    "standard_resolution": {
        "url": "http://distilleryimage6.s3.amazonaws.com/e04ef13efe9511e2ba1722000a1faed2_7.jpg",
        "width": 612,
        "height": 612
    }
},

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
},

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

"user": {
    "profile_picture": "http://images.ak.instagram.com/profiles/profile_46466272_75sq_1373028975.jpg",
    "username": "akhmedullova",
    "id": "46466272",
    "full_name": "'-Akhmedullova Regina-'",
}

"likes": {
    "count": 19,
    "data": [
             {
                 "profile_picture": "http://images.ak.instagram.com/profiles/profile_13927899_75sq_1371534595.jpg",
                 "username": "chrisxpurifoy",
                 "id": "13927899",
                 "full_name": "Chris Purifoy"
             }]
}
*/




@end
