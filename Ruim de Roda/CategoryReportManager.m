//
//  CategoryReportManager.m
//  Ruim de Roda
//
//  Created by Henrique Velloso on 4/11/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "CategoryReportManager.h"

@implementation CategoryReportManager


- (void)requestCategory:(void (^)(NSArray *resultCategories, NSError *error))response {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Category"];
    
    [query orderByAscending:@"text"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *resultCategories, NSError *error) {
        
        
        if (!resultCategories) {
            response(nil, error);
        }
        else {
            NSMutableArray *categories = [[NSMutableArray alloc] init];
            
            for (PFObject *resultCategory in resultCategories)
            {
                
                
                CategoryReport *category = [[CategoryReport alloc] init];
                
                category.objectId = resultCategory.objectId;
                category.text = [resultCategory objectForKey:@"text"];
                category.createdAt = resultCategory.createdAt;
                category.updatedAt = resultCategory.updatedAt;
       
                [categories addObject:category];
                
            }
            
            response([categories copy], nil);
        }
    }];
    
}


@end
