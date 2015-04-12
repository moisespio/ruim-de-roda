//
//  PlateManager.h
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 12/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plate.h"
#import <Parse/Parse.h>

@import UIKit;

@interface PlateManager : NSObject

- (void)savePlate:(Plate *)plate forUser:(NSString*)userID response:(void (^)(BOOL success, NSError *error))response;
- (void)requestPlates:(void (^)(NSArray *resultPlates, NSError *error))response;
- (void)requestUserIDbyPlate:(NSString *)plate response:(void (^)(NSString *userID, NSError *error))response;
- (void)removePlate:(NSString *)objectId response:(void (^)(BOOL succeeded, NSError *error))response;

@end
