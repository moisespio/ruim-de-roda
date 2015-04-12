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

- (void)sendPushNotificationsWithMessage:(NSString *)pushMessage plate:(NSString *)plate {
    
    
    NSString *userId = @"";
    
    
    
    
    
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" equalTo:[PFUser objectWithoutDataWithObjectId:userId]];
    
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

@end
