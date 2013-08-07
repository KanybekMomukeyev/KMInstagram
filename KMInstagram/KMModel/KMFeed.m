//
//  KMFeed.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMFeed.h"
#import "KMTag.h"
#import "KMComment.h"

@implementation KMFeed

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSNull class]])
        {
            _feedId = [dict objectForKey:@"id"];
            _user_has_liked = [[dict objectForKey:@"user_has_liked"] boolValue];
            _link = [dict objectForKey:@"link"];
            _created_time = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"created_time"] doubleValue]];
            NSDictionary *imagesDict = [dict objectForKey:@"images"];
            NSDictionary *standard_resolutionDic = [imagesDict objectForKey:@"standard_resolution"];
            _imageLink  = [standard_resolutionDic objectForKey:@"url"];
            
            _caption = [[KMCaption alloc] initWithDictionary:[dict objectForKey:@"caption"]];
            
            _tagsArray = [NSMutableArray new];
            NSArray *tags = [dict objectForKey:@"tags"];
            [tags enumerateObjectsUsingBlock:^(NSString *tagName, NSUInteger idx, BOOL *stop){
                KMTag *tag = [[KMTag alloc] initWithString:tagName];
                [_tagsArray addObject:tag];
            }];
            
            _commentsArray = [NSMutableArray new];
            NSDictionary *commentsDict = [dict objectForKey:@"comments"];
            _commentsCount = [commentsDict objectForKey:@"count"];
            NSArray *commentsArr = [commentsDict objectForKey:@"data"];
            [commentsArr enumerateObjectsUsingBlock:^(NSDictionary *commObj, NSUInteger idx, BOOL *stop){
                KMComment *comment = [[KMComment alloc] initWithDictionary:commObj];
                [_commentsArray addObject:comment];
            }];
            
            _user = [[KMUser alloc] initWithDictionary:[dict objectForKey:@"user"]];
            
            _likesArray = [NSMutableArray new];
            NSDictionary *likesDict = [dict objectForKey:@"likes"];
            _likesCount = [likesDict objectForKey:@"count"];
            NSArray *likes = [likesDict objectForKey:@"data"];
            [likes enumerateObjectsUsingBlock:^(NSDictionary *likeObj, NSUInteger idx, BOOL *stop){
                KMUser *user = [[KMUser alloc] initWithDictionary:likeObj];
                [_likesArray addObject:user];
            }];
        }
    }
    return self;
}



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
