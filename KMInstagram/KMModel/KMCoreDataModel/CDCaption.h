//
//  CDCaption.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CDEditingProtocol.h"

@class CDFeed, CDUser;

@interface CDCaption : NSManagedObject<CDEditingProtocol>

@property (nonatomic, retain) NSDate * created_time;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * captionId;
@property (nonatomic, retain) CDUser *user;
@property (nonatomic, retain) CDFeed *feed;

@end
