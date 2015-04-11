//
//  ReportViewController.h
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 11/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ReportViewController : UIViewController <UIApplicationDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate> {
    CLLocationManager *locationManager;
}


@property UIImage *imageReport;

@property (weak, nonatomic) IBOutlet UIImageView *reportImage;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
