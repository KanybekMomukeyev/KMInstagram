//
//  CDFeed.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CDEditingProtocol.h"

@class CDCaption, CDComment, CDUser;

@interface CDFeed : NSManagedObject<CDEditingProtocol>

@property (nonatomic, retain) NSString * feedId;
@property (nonatomic, retain) NSNumber * user_has_liked;
@property (nonatomic, retain) NSNumber * pagingIndex;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSDate * created_time;
@property (nonatomic, retain) NSString * imageLink;
@property (nonatomic, retain) NSString * commentsCount;
@property (nonatomic, retain) NSString * likesCount;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) CDCaption *caption;
@property (nonatomic, retain) CDUser *user;
@end

@interface CDFeed (CoreDataGeneratedAccessors)

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (void)addCommentsObject:(CDComment *)value;
- (void)removeCommentsObject:(CDComment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addLikesObject:(CDUser *)value;
- (void)removeLikesObject:(CDUser *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

@end
