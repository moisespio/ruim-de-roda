//
//  CategoryReport.h
//  Ruim de Roda
//
//  Created by Henrique Velloso on 4/11/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryReport : NSObject

@property (strong, nonatomic) NSString* objectId;
@property (strong, nonatomic) NSString* text;

@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSDate *createdAt;

@end
