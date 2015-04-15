//
//  Report.h
//  Flockr
//
//  Created by Matheus Frozzi Alberton on 06/04/15.
//  Copyright (c) 2015 DevMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Report.h"

#import <Parse/Parse.h>

@interface Inappropriate : NSObject

- (void)addInappropriateQuery:(NSString *)optionID toReportId:(NSString *)reportID response:(void (^)(BOOL succeeded, NSError *error))response;
- (void)requestInappropriate:(void (^)(NSArray *allReports, NSError *error))response;

@property (strong, nonatomic) PFObject *pfObject;

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) Report *report;
@property (strong ,nonatomic) NSDate *createdAt;

@end