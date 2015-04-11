//
//  ReportViewController.m
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 11/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportManager.h"

@interface ReportViewController ()

@end

@implementation ReportViewController {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    self.reportImage.image = self.imageReport;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }

    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];

    self.mapView.delegate = self;
//    locationManager = [[CLLocationManager alloc] init];
//    [locationManager setDelegate:self];
//    [locationManager setDistanceFilter:kCLDistanceFilterNone];
//    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];

    [self.mapView setShowsUserLocation:YES];

    // Override point for customization after application launch.
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    
    if (currentLocation != nil) {
        _latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _longitude= [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }

    [locationManager stopUpdatingLocation];

    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            self.addressLabel.text = [NSString stringWithFormat:@"%@, %@\n %@ - %@",
                                 placemark.thoroughfare, placemark.subThoroughfare,
                                 placemark.locality, placemark.administrativeArea];
            
            NSString *street = placemark.thoroughfare;
            NSString *number = placemark.subThoroughfare;
            NSString *city = placemark.locality;
            NSString *state = placemark.administrativeArea;
            
            _address = [NSString stringWithFormat:@"%@, %@\n %@, %@", street, number, city, state];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.initialLocation) {
        self.initialLocation = userLocation.location;
        MKCoordinateRegion mapRegion;
        mapRegion.center = mapView.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.01;
        mapRegion.span.longitudeDelta = 0.01;

        [mapView setRegion:mapRegion animated: YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendReport:(id)sender {
    Report *report = [[Report alloc] init];
    
    NSString *plateLetter = self.plateLetters.text;
    NSString *plateNumber = self.plateNumbers.text;
    
    _plate = [NSString stringWithFormat:@"%@%@", plateLetter, plateNumber];

    report.plate = _plate;
    report.address = _address;
    report.latitude = _latitude;
    report.longitude = _longitude;

    ReportManager *reportControl = [[ReportManager alloc] init];
    
    _imageCrop = _reportImage.image;
    _imageCrop = [self adjustImageSizeWhenCropping:_imageCrop];

    [reportControl postReport:report forCategory:_categoryID photoImage:_imageCrop response:^(BOOL success, NSError *error) {
        if (success) {
            [self performSelectorOnMainThread:@selector(successfulRequest) withObject:nil waitUntilDone:NO];
        } else {
            [self performSelectorOnMainThread:@selector(errorRequest) withObject:nil waitUntilDone:NO];
        }
    }];
}
-(UIImage *)adjustImageSizeWhenCropping:(UIImage *)image {
    float actualHeight = image.size.height;
    
    float actualWidth = image.size.width;
    
    float ratio=300/actualWidth;
    actualHeight = actualHeight*ratio;
    
    CGRect rect = CGRectMake(0.0, 0.0, 300, actualHeight);
    // UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
- (void)successfulRequest {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)errorRequest {
    [self alertWithTitle:@"Erro!" message:@"Ocorreu um erro ao salvar report"];
}
- (void)alertWithTitle:(NSString *)_alertTitle message:(NSString *)_alertMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_alertTitle message:_alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)cancelReport:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)selectCategory:(id)sender {
    [self performSegueWithIdentifier:@"showCategory" sender:sender];
}
- (IBAction)backCategory:(UIStoryboardSegue *)sender {
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
