//
//  PushNotifications.h
//  Ruim de Roda
//
//  Created by Henrique Velloso on 4/12/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlateManager.h"

@interface PushNotifications : NSObject

- (void)associateDeviceWithCurrentUser;
//- (void)sendPushNotificationsWithMessage:(NSString *)pushMessage userId:(NSString *)userId;
//- (void)sendPushNotificationsWithMessage:(NSString *)pushMessage pushType:(NSString *)pushType objectId:(NSString *)objectId userId:(NSString *)userId;

- (void)sendPushNotificationsWithMessage:(NSString *)pushMessage plate:(NSString *)plate;

@end