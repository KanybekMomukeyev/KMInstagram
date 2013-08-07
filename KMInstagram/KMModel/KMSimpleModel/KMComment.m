//
//  KMComment.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMComment.h"

@implementation KMComment

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSNull class]])
        {
            if ([dict objectForKey:@"created_time"]) {
                _created_time = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"created_time"] doubleValue]];
            }
            _text = [dict objectForKey:@"text"];
            _commentId = [dict objectForKey:@"id"];
            _user = [[KMUser alloc] initWithDictionary:[dict objectForKey:@"from"]];
        }
    }
    return self;
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
