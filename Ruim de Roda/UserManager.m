//
//  UserManager.m
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 11/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

- (void)createUser:(void (^)(NSString *objectID, NSError *error))response {

    //[self requestNumReports:^(NSInteger numReports, NSError *error) {
        PFUser *user = [PFUser user];
        user.username =  [[NSUUID UUID] UUIDString]; //[NSString stringWithFormat:@"ruimderoda%ld", (long)numReports+1];
        user.password = @"123";

        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                PushNotifications *pushNotifications = [[PushNotifications alloc] init];
                [pushNotifications associateDeviceWithCurrentUser];
                response(nil, error);
            } else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@", errorString);
            }

            response(user.objectId, error);
        }];

  //  }];
    
    }

-(void)setUserDefaults:(NSString *)objectID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:objectID forKey:@"userObjectID"];

    [userDefaults synchronize];
}

- (NSString *)getUserDefaults {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userObjectID"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"userObjectID"];
    } else {
        return nil;
    }
}

- (void)requestNumReports:(void (^)(NSInteger numReports, NSError *error))response {
    
    PFQuery *query = [PFUser query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *resultReports, NSError *error) {
        if (!resultReports) {
            response(0, error);
        } else {
            response([resultReports count], nil);
        }
    }];
}
     
@end
