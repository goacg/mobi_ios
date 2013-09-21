//
//  Album.h
//  test
//
//  Created by mp on 13-9-12.
//  Copyright (c) 2013年 mp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Play;

@interface Album : NSManagedObject

@property (nonatomic, retain) NSString * bigcover;
@property (nonatomic, retain) NSString * icon_32x32;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * start_time;
@property (nonatomic, retain) NSNumber * sub;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * update_time;
@property (nonatomic, retain) NSSet *plays;
@end

@interface Album (CoreDataGeneratedAccessors)

- (void)addPlaysObject:(Play *)value;
- (void)removePlaysObject:(Play *)value;
- (void)addPlays:(NSSet *)values;
- (void)removePlays:(NSSet *)values;

@end
