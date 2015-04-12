//
//  UserManager.h
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 11/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "PushNotifications.h"

@interface UserManager : NSObject

- (void)createUser:(void (^)(NSString *objectID, NSError *error))response;
- (void)setUserDefaults:(NSString *)objectID;
- (NSString *)getUserDefaults;
- (void)requestNumReports:(void (^)(NSInteger numReports, NSError *error))response;

@end
