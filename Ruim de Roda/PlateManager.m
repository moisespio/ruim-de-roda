//
//  PlateManager.m
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 12/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "PlateManager.h"

@implementation PlateManager

- (void)savePlate:(Plate *)plate forUser:(NSString*)userID response:(void (^)(BOOL success, NSError *error))response {
    PFObject *pfPlate = [PFObject objectWithClassName:@"Plate"];
    
    [pfPlate setObject:plate.plate forKey:@"plate"];

    [pfPlate setObject:[PFUser objectWithoutDataWithObjectId:[[PFUser currentUser] objectId]] forKey:@"userID"];
    
    [pfPlate saveInBackgroundWithBlock:^(BOOL succeed, NSError *error) {
        response(succeed, error);
    }];
}
- (void)requestPlates:(void (^)(NSArray *resultPlates, NSError *error))response {
    PFQuery *query = [PFQuery queryWithClassName:@"Plate"];
    
    [query includeKey:@"userID"];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *resultPlates, NSError *error) {
        if (!resultPlates) {
            response(nil, error);
        }
        else {
            NSMutableArray *reports = [[NSMutableArray alloc] init];
            
            for (PFObject *resultPlate in resultPlates)
            {
                
                Plate *plate = [[Plate alloc] init];
                
                plate.objectId = resultPlate.objectId;
                plate.plate = [resultPlate objectForKey:@"plate"];

                [reports addObject:plate];
            }

            response([reports copy], nil);
        }
    }];
}

- (void)requestPlate:(void (^)(NSArray *resultPlates, NSError *error))response plate:(NSString*) plate {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Plate"];
    [query whereKey:@"plate" equalTo:plate];
    
    [query includeKey:@"userID"];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *resultPlates, NSError *error) {
        if (!resultPlates) {
            response(nil, error);
        }
        else {
            NSMutableArray *reports = [[NSMutableArray alloc] init];
            
            for (PFObject *resultPlate in resultPlates)
            {
                
                Plate *plate = [[Plate alloc] init];
                
                plate.objectId = resultPlate.objectId;
                plate.plate = [resultPlate objectForKey:@"plate"];
                
                [reports addObject:plate];
            }
            
            response([reports copy], nil);
        }
    }];
}

- (void)removePlate:(NSString *)objectId response:(void (^)(BOOL succeeded, NSError *error))response {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Plate"];
    [query whereKey:@"objectId" equalTo:objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (PFObject *object in objects) {
            
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                }

                response(succeeded, error);
                
            }];
        }
        
    }];
}
@end