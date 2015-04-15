//
//  DetailViewController.h
//  Ruim de Roda
//
//  Created by Henrique Velloso on 4/11/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Report.h"
@import MapKit;
#import "MapAnnotation.h"

#define METERS_MILE 109.344
#define METERS_FEET 3.28084

@interface DetailViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblPlate;
@property (weak, nonatomic) IBOutlet UILabel *lblHour;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (unsafe_unretained, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) NSMutableArray *locations;

@property (strong, nonatomic) Report* report;

@end