//
//  AppDelegate.m
//  test
//
//  Created by mp on 13-7-16.
//  Copyright (c) 2013年 mp. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>
#import "GetAlbumsResponse.h"
#import "DataManager.h"

@implementation AppDelegate

- (void)initDataService
{
    [[DataManager alloc] init];
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSError* error = nil;
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    if (! success) {
        RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    }
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Store.sqlite"];
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if (! persistentStore) {
        RKLogError(@"Failed adding persistent store at path '%@': %@", path, error);
    }
    [managedObjectStore createManagedObjectContexts];
    
    RKObjectManager *om = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://121.199.44.23"]];
    om.managedObjectStore = managedObjectStore;
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initDataService];
    
//    [GetAlbumsResponse asyncRequest:@"3"
//                          afterTime:[NSDate dateWithTimeIntervalSince1970:0]
//                          beforeTime:[NSDate dateWithTimeIntervalSince1970:INT_MAX]
//                              block:^(GetAlbumsResponse* response){
//                                    if ( response != nil )
//                                    {
//                                        NSLog(@"request success---->%@", response);
//                                    }
//                                    else
//                                    {
//                                        NSLog(@"request failed");
//                                    }
//                                }];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

