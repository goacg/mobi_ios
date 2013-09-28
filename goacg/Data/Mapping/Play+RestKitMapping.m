//
//  Play+RestKitMapping.m
//  test
//
//  Created by mp on 13-9-12.
//  Copyright (c) 2013年 mp. All rights reserved.
//

#import "Play+RestKitMapping.h"
#import <RestKit/RestKit.h>

@implementation Play (RestKitMapping)
+ (RKObjectMapping*) mapping
{
    RKManagedObjectStore* managedObjectStore = [[RKObjectManager sharedManager] managedObjectStore];
    NSAssert(managedObjectStore != nil, @"managedObjectStore != nil");
    
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:@"Play" inManagedObjectStore:managedObjectStore];
    [mapping addAttributeMappingsFromArray:@[@"play_id", @"vol", @"show_time", @"show_url", @"bigcover", @"update_time"]];
    mapping.identificationAttributes = @[@"play_id"];
    return mapping;
}
@end
