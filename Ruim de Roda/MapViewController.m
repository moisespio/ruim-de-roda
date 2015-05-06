//
//  MapViewController.m
//  Ruim de Roda
//
//  Created by Henrique Velloso on 5/4/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "MapViewController.h"
#import "ReportManager.h"
#import "Report.h"

@interface MapViewController () {
    
    
    CLLocationManager *locationManager;
    
}

@end

@implementation MapViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _activityindicator.hidesWhenStopped = true;
    [_activityindicator stopAnimating];
    
    _mapVIew.delegate = self;
    
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-header"]];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    
    [self addPins];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshMap:(id)sender {
    
    [self addPins];
}

-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        _mapVIew.showsUserLocation = YES;
        

        [_mapVIew setCenterCoordinate:locationManager.location.coordinate animated:YES];
        _mapVIew.camera.altitude = pow(4.3, 11);
        
        [locationManager startUpdatingLocation];
        
        
    }

}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [locationManager stopUpdatingLocation];
    
    [_mapVIew setCenterCoordinate:locationManager.location.coordinate animated:YES];
    _mapVIew.camera.altitude =  pow(4.3, 11);
    
}







-(void) addPins {
    
    
    [_activityindicator startAnimating];
    
    ReportManager *reportManager = [[ReportManager alloc] init];
    [reportManager requestReports:^(NSArray *resultReports, NSError *error) {
        if (resultReports) {
            
            [_mapVIew removeAnnotations:_mapVIew.annotations];
            
            for (Report *report in resultReports) {
                
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = CLLocationCoordinate2DMake([report.latitude doubleValue], [report.longitude doubleValue]);
                point.title = report.category.text;

                [_mapVIew addAnnotation:point];
            }
            
            [_activityindicator stopAnimating];
            
            
        }
    }];
    
    
//    var point = MKPointAnnotation();
//    point.coordinate = CLLocationCoordinate2DMake(37.331507, -122.033354)
//    point.title = "Nice Restaurant"
//    point.subtitle = "Very close to you."
//    
//    mapView.addAnnotation(point)
//    mapView.showAnnotations([point], animated: true)
    
    
}



@end
