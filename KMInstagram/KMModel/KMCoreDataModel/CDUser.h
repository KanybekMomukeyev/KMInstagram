//
//  CDUser.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CDEditingProtocol.h"

@class CDFeed;

@interface CDUser : NSManagedObject<CDEditingProtocol>

@property (nonatomic, retain) NSString * profile_picture;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * full_name;
@property (nonatomic, retain) NSManagedObject *caption;
@property (nonatomic, retain) NSManagedObject *comment;
@property (nonatomic, retain) CDFeed *feedComments;
@property (nonatomic, retain) CDFeed *feed;

@end
