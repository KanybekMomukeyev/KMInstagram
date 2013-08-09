//
//  CDCommandModel.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/8/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDCommandModel : NSManagedObject

@property (nonatomic, retain) NSNumber * method;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * feedId;
@property (nonatomic, retain) NSNumber * sortIndex;

@end
