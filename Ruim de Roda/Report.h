//
//  Report.h
//  Ruim de Roda
//
//  Created by Henrique Velloso on 4/11/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryReport.h"

@interface Report : NSObject

@property (strong, nonatomic) NSString* objectId;
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) CategoryReport* category;
@property (strong, nonatomic) NSString* latitude;
@property (strong, nonatomic) NSString* longitude;
@property (strong, nonatomic) NSString* photo;
@property (strong, nonatomic) NSString* plate;


@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSDate *createdAt;



@end
