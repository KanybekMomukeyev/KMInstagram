//
//  CDUser.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "CDUser.h"
#import "CDFeed.h"


@implementation CDUser

@dynamic profile_picture;
@dynamic username;
@dynamic userId;
@dynamic full_name;
@dynamic caption;
@dynamic comment;
@dynamic feedComments;
@dynamic feed;

- (void)setWithDictionary:(NSDictionary *)dict {
    
}

/*
 "user": {
 "profile_picture": "http://images.ak.instagram.com/profiles/profile_472783859_75sq_1374282112.jpg",
 "username": "mister_werewolf",
 "id": "472783859",
 "full_name": "Віталій Ткачук",
 }
 */

@end
