//
//  ReportManager.m
//  Ruim de Roda
//
//  Created by Henrique Velloso on 4/11/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "ReportManager.h"


@implementation ReportManager

- (void)postReport:(Report *)report forCategory:(NSString*)categoryId photoImage:(UIImage *)photoImage response:(void (^)(BOOL success, Report *repID, NSError *error))response {
    
    PFObject *pfReport = [PFObject objectWithClassName:@"Report"];
    
    [pfReport setObject:report.address forKey:@"address"];
    [pfReport setObject:report.latitude forKey:@"latitude"];
    [pfReport setObject:report.longitude forKey:@"longitude"];
    [pfReport setObject:report.plate forKey:@"plate"];
    
    
    [pfReport setObject:[PFObject objectWithoutDataWithClassName:@"Category" objectId:categoryId]forKey:@"categoryID"];
    
    if (photoImage)
    {
        NSData *imageData = UIImageJPEGRepresentation(photoImage, 0.6);
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpg", categoryId]
                                            data:imageData];
        [pfReport setObject:imageFile forKey:@"photo"];
    }
    
    [pfReport saveInBackgroundWithBlock:^(BOOL succeed, NSError *error) {
        NSLog(@"%@", [pfReport objectId]);
        [self requestReportByReportID:[pfReport objectId] response:^(Report *reportS, NSError *error) {
            if (!error) {
                response(succeed, reportS, error);
            }
        }];
    }];
    
}

- (void)requestReports:(void (^)(NSArray *resultReports, NSError *error))response {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Report"];
    
    [query includeKey:@"categoryID"];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *resultReports, NSError *error) {
        
        
        if (!resultReports) {
            response(nil, error);
        }
        else {
            NSMutableArray *reports = [[NSMutableArray alloc] init];
            
            for (PFObject *resultReport in resultReports)
            {
                
                Report *report = [[Report alloc] init];
                
                report.objectId = resultReport.objectId;
                report.address = [resultReport objectForKey:@"address"];
                report.latitude = [resultReport objectForKey:@"latitude"];
                report.longitude = [resultReport objectForKey:@"longitude"];
                report.plate = [resultReport objectForKey:@"plate"];
                report.createdAt = resultReport.createdAt;
                report.updatedAt = resultReport.updatedAt;
                
                //Category
                CategoryReport *category = [[CategoryReport alloc] init];
                PFObject *pfCategory = resultReport[@"categoryID"];
                
                category.objectId = pfCategory.objectId;
                category.text = [pfCategory objectForKey:@"text"];
                category.createdAt = pfCategory.createdAt;
                category.updatedAt = pfCategory.updatedAt;
                
                report.category = category;
                
                
                //Photo
                if ([resultReport objectForKey:@"photo"])
                {
                    PFFile *pfFile = [resultReport objectForKey:@"photo"];
                    report.photo = pfFile.url;
                }
                
                
                [reports addObject:report];
                
            }
            
            response([reports copy], nil);
        }
    }];
    
}
- (void)requestReportByReportID:(NSString *)reportID response:(void (^)(Report *report, NSError *error))response; {
    PFQuery *query = [PFQuery queryWithClassName:@"Report"];
    [query whereKey:@"objectId" equalTo:reportID];
    
    [query includeKey:@"categoryID"];

    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *resultPlates, NSError *error) {
        if (!resultPlates) {
            response(nil, error);
        }
        else {
            NSMutableArray *reports = [[NSMutableArray alloc] init];
            
            Report *rep;
            
            for (PFObject *resultPlate in resultPlates)
            {
                
                rep = [[Report alloc] init];
                
                rep.objectId = resultPlate.objectId;
                rep.address = [resultPlate objectForKey:@"address"];
                rep.latitude = [resultPlate objectForKey:@"latitude"];
                rep.longitude = [resultPlate objectForKey:@"longitude"];
                rep.plate = [resultPlate objectForKey:@"plate"];
                rep.createdAt = resultPlate.createdAt;
                rep.updatedAt = resultPlate.updatedAt;
                
                
                //Category
                CategoryReport *category = [[CategoryReport alloc] init];
                PFObject *pfCategory = resultPlate[@"categoryID"];
                
                category.objectId = pfCategory.objectId;
                category.text = [pfCategory objectForKey:@"text"];
                category.createdAt = pfCategory.createdAt;
                category.updatedAt = pfCategory.updatedAt;
                
                rep.category = category;
                
                
                //Photo
                if ([resultPlate objectForKey:@"photo"]) {
                    PFFile *pfFile = [resultPlate objectForKey:@"photo"];
                    rep.photo = pfFile.url;
                }
                
                

                [reports addObject:rep];
            }
            
            response(rep, nil);
        }
    }];
}
@end
