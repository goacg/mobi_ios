//
//  DataManager.m
//  test
//
//  Created by mp on 13-9-7.
//  Copyright (c) 2013年 mp. All rights reserved.
//

#import "DataManager.h"
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@implementation DataManager

static DataManager* s_sharedInstance = nil;

- (id) init
{
    if ( self = [super init] )
    {
        s_sharedInstance = self;
    }
    
    return self;
}

+ (DataManager*) sharedInstance
{
    return s_sharedInstance;
}

- (void)asyncQueryPlaysInTimeRange:(NSDate*)afterTime
                        beforeTime:(NSDate*)beforeTime
                        onComplete:(void(^)(NSArray*))onComplete
                            onFail:(void(^)(void))onFail
{
    NSManagedObjectContext *moc = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Play" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(show_time >= %d) AND (show_time < %d)", (int)[afterTime timeIntervalSince1970], (int)[beforeTime timeIntervalSince1970] ];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"show_time" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array != nil)
    {
        onComplete(array);
    }
    else
    {
        onFail();
    }
}

@end
