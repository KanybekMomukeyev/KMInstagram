//
//  CDTag.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CDEditingProtocol.h"

@class CDFeed;

@interface CDTag : NSManagedObject<CDEditingProtocol>

@property (nonatomic, retain) NSString * tagName;
@property (nonatomic, retain) CDFeed *feed;

@end
