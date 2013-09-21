//
//  Play.h
//  test
//
//  Created by mp on 13-9-12.
//  Copyright (c) 2013年 mp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Play : NSManagedObject

@property (nonatomic, retain) NSString * bigcover;
@property (nonatomic, retain) NSNumber * play_id;
@property (nonatomic, retain) NSNumber * show_time;
@property (nonatomic, retain) NSString * show_url;
@property (nonatomic, retain) NSNumber * update_time;
@property (nonatomic, retain) NSNumber * vol;
@property (nonatomic, retain) Album *album;

@end
