//
//  CDCaption.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "CDCaption.h"
#import "CDFeed.h"
#import "CDUser.h"


@implementation CDCaption

@dynamic created_time;
@dynamic text;
@dynamic captionId;
@dynamic user;
@dynamic feed;

- (void)setWithDictionary:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSNull class]])
    {
        if ([dict objectForKey:@"created_time"]) {
            self.created_time = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"created_time"] doubleValue]];
            self.text = [dict objectForKey:@"text"];
            self.captionId = [dict objectForKey:@"id"];
            
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            CDUser *user = [CDUser MR_createInContext:localContext];
            [user setWithDictionary:[dict objectForKey:@"from"]];
            self.user = user;
        }
    }
}

@end
