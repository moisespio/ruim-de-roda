//
//  MapViewController.h
//  Ruim de Roda
//
//  Created by Henrique Velloso on 5/4/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface MapViewController : UIViewController <CLLocationManagerDelegate , MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapVIew;

@end
