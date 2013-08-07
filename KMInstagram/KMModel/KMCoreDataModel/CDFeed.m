//
//  CDFeed.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "CDFeed.h"
#import "CDCaption.h"
#import "CDComment.h"
#import "CDUser.h"


@implementation CDFeed

@dynamic feedId;
@dynamic user_has_liked;
@dynamic link;
@dynamic created_time;
@dynamic imageLink;
@dynamic commentsCount;
@dynamic likesCount;
@dynamic tags;
@dynamic comments;
@dynamic likes;
@dynamic caption;
@dynamic user;

- (void)setWithDictionary:(NSDictionary *)dict {
    
}

@end
