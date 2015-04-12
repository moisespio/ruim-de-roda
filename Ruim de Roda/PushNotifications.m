//
//  PushNotifications.m
//  Ruim de Roda
//
//  Created by Henrique Velloso on 4/12/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "PushNotifications.h"
#import <Parse/Parse.h>

@implementation PushNotifications

- (void)associateDeviceWithCurrentUser {
    
    // Associate the device with a user for Push Notifications
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[@"user"] = [PFUser currentUser];
    [installation saveInBackground];
}
- (void)sendPushNotificationsWithMessage:(NSString *)pushMessage plate:(NSString *)plate {
    PlateManager *plateControl = [[PlateManager alloc] init];


    [plateControl requestUserIDbyPlate:plate response:^(NSString *userID, NSError *error) {
        if (!error) {
            NSString *user_id = userID;
//            NSLog(@"%@", user_id);
            
            // Create our Installation query
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"user" equalTo:[PFUser objectWithoutDataWithObjectId:user_id]];
            
            NSDictionary *data = @{
                                   @"alert" : pushMessage,
                                   @"plate": plate
                                   };
            
            // Send push notification to query
            PFPush *push = [[PFPush alloc] init];
            [push setQuery:pushQuery];
            [push setData:data];
            [push sendPushInBackground];
        }
    }];
}
//- (void)sendPushNotificationsWithMessage:(NSString *)pushMessage userId:(NSString *)userId {
//    [self sendPushNotificationsWithMessage:pushMessage pushType:nil objectId:nil userId:userId];
//}
//
//- (void)sendPushNotificationsWithMessage:(NSString *)pushMessage pushType:(NSString *)pushType objectId:(NSString *)objectId userId:(NSString *)userId {
//    
//    // Create our Installation query
//    PFQuery *pushQuery = [PFInstallation query];
//    [pushQuery whereKey:@"user" equalTo:[PFUser objectWithoutDataWithObjectId:userId]];
//    
//    NSDictionary *data = @{
//                           @"alert" : pushMessage,
//                           @"badge" : @"Increment",
//                           @"pushType" : pushType,
//                           @"pushTypeId": objectId
//                           };
//    
//    // Send push notification to query
//    PFPush *push = [[PFPush alloc] init];
//    [push setQuery:pushQuery];
//    [push setData:data];
//    [push sendPushInBackground];
//    
//}

// Push with Localized support
//- (void)sendPushLocKey:(NSString *)locKey fromPerfil:(NSString *)fromPerfil toPerfil:(NSString *)toPerfil pushType:(NSString *)pushType objectId:(NSString *)objectId userId:(NSString *)userId {
//    
//    // Create our Installation query
//    PFQuery *pushQuery = [PFInstallation query];
//    [pushQuery whereKey:@"user" equalTo:[PFUser objectWithoutDataWithObjectId:userId]];
//    
//    NSArray *values = [NSArray arrayWithObjects:fromPerfil, toPerfil, nil];
//    
//    NSDictionary *data = @{
//                           @"alert" : @{
//                                   @"loc-key" : locKey,
//                                   @"loc-args" : values
//                                   },
//                           @"badge" : @"Increment",
//                           @"pushType" : pushType,
//                           @"pushTypeId": objectId
//                           };
//    
//    // Send push notification to query
//    PFPush *push = [[PFPush alloc] init];
//    [push setQuery:pushQuery];
//    [push setData:data];
//    [push sendPushInBackground];
//}

@end
