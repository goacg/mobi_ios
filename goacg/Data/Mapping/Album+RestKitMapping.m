//
//  Album+RestKitMapping.m
//  test
//
//  Created by mp on 13-9-12.
//  Copyright (c) 2013年 mp. All rights reserved.
//

#import "Album+RestKitMapping.h"
#import "Play+RestKitMapping.h"
#import <RestKit/RestKit.h>

@implementation Album (RestKitMapping)
+ (RKObjectMapping*) mapping
{
    RKManagedObjectStore* managedObjectStore = [[RKObjectManager sharedManager] managedObjectStore];
    NSAssert(managedObjectStore != nil, @"managedObjectStore != nil");
    
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:@"Album" inManagedObjectStore:managedObjectStore];
    [mapping addAttributeMappingsFromArray:@[@"id", @"title", @"icon_32x32", @"bigcover", @"sub", @"start_time", @"update_time"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"plays" mapping:[Play mapping]];
    
    RKRelationshipMapping* rm = [mapping mappingForSourceKeyPath:@"plays"];
    rm.assignmentPolicy = RKAssignmentPolicyUnion;
    return mapping;
}
@end
