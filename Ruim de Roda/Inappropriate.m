//
//  Report.m
//  Flockr
//
//  Created by Matheus Frozzi Alberton on 06/04/15.
//  Copyright (c) 2015 DevMac. All rights reserved.
//

#import "Inappropriate.h"

@implementation Inappropriate

- (void)addInappropriateQuery:(NSString *)optionID toReportId:(NSString *)reportID response:(void (^)(BOOL succeeded, NSError *error))response {
    PFObject *reportObject = [PFObject objectWithClassName:@"Inappropriate"];
    [reportObject setObject:[PFObject objectWithoutDataWithClassName:@"Report" objectId:reportID] forKey:@"report"];
    [reportObject setObject:[PFObject objectWithoutDataWithClassName:@"Inappropriate_option" objectId:optionID] forKey:@"option"];

    [reportObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            response(YES, nil);
        } else {
            response(NO, error);
        }
    }];
}

- (void)requestInappropriate:(void (^)(NSArray *allReports, NSError *error))response {
    PFQuery *inappropriateQuery = [PFQuery queryWithClassName:@"Inappropriate_option"];
    [inappropriateQuery orderByDescending:@"createdAt"];

    [inappropriateQuery findObjectsInBackgroundWithBlock:^(NSArray *resultsInappropriate, NSError *error) {
        if (!resultsInappropriate) {
            response(nil, error);
        }
        else {
            NSMutableArray *allInappropriate = [[NSMutableArray alloc] init];
            
            for (PFObject *resultInappropriate in resultsInappropriate) {
                // Report
                Inappropriate *inappropriate = [[Inappropriate alloc] init];
                inappropriate.objectId = resultInappropriate.objectId;
                inappropriate.text = [resultInappropriate objectForKey:@"text"];
                inappropriate.createdAt = resultInappropriate.createdAt;
                
                [allInappropriate addObject:inappropriate];
            }
            response([allInappropriate copy], nil);
        }
    }];
}

@end