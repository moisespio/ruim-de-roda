//
//  Plate.h
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 12/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Plate : NSObject

@property (strong, nonatomic) NSString* objectId;
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) NSString* plate;

@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSDate *createdAt;

@end