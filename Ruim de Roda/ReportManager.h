//
//  ReportManager.h
//  Ruim de Roda
//
//  Created by Henrique Velloso on 4/11/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Report.h"
#import "CategoryReport.h"
#import <Parse/Parse.h>

@import UIKit;

@interface ReportManager : NSObject

- (void)postReport:(Report *)report forCategory:(NSString*)categoryId photoImage:(UIImage *)photoImage response:(void (^)(BOOL success, Report *repID, NSError *error))response ;

- (void)requestReports:(void (^)(NSArray *resultReports, NSError *error))response;
- (void)requestReportByReportID:(NSString *)reportID response:(void (^)(Report *report, NSError *error))response;

@end
