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
#import "CDTag.h"

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

- (void)setWithDictionary:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSNull class]])
    {
        self.feedId = [dict objectForKey:@"id"];
        self.user_has_liked = @([[dict objectForKey:@"user_has_liked"] boolValue]);
        self.link = [dict objectForKey:@"link"];
        self.created_time = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"created_time"] doubleValue]];
        NSDictionary *imagesDict = [dict objectForKey:@"images"];
        NSDictionary *standard_resolutionDic = [imagesDict objectForKey:@"standard_resolution"];
        self.imageLink  = [standard_resolutionDic objectForKey:@"url"];
        
        NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
        CDCaption *caption = [CDCaption MR_createInContext:localContext];
        [caption setWithDictionary:[dict objectForKey:@"caption"]];
        
        __weak CDFeed *self_ = self;
        NSArray *tags = [dict objectForKey:@"tags"];
        [tags enumerateObjectsUsingBlock:^(NSString *tagName, NSUInteger idx, BOOL *stop){
            CDTag *tag = [CDTag MR_createInContext:localContext];
            tag.tagName = tagName;
            [self_ addTagsObject:tag];
        }];
        
        NSDictionary *commentsDict = [dict objectForKey:@"comments"];
        self.commentsCount = [commentsDict objectForKey:@"count"];
        NSArray *commentsArr = [commentsDict objectForKey:@"data"];
        [commentsArr enumerateObjectsUsingBlock:^(NSDictionary *commObj, NSUInteger idx, BOOL *stop){
            CDComment *comment = [CDComment MR_createInContext:localContext];
            [comment setWithDictionary:commObj];
            [self_ addCommentsObject:comment];
        }];
        
        CDUser *user = [CDUser MR_createInContext:localContext];
        [user setWithDictionary:[dict objectForKey:@"user"]];
        
        NSDictionary *likesDict = [dict objectForKey:@"likes"];
        self.likesCount = [likesDict objectForKey:@"count"];
        
        NSArray *likes = [likesDict objectForKey:@"data"];
        [likes enumerateObjectsUsingBlock:^(NSDictionary *likeObj, NSUInteger idx, BOOL *stop){
            CDUser *user = [CDUser MR_createInContext:localContext];
            [self_ addLikesObject:user];
        }];
    }
}
@end
