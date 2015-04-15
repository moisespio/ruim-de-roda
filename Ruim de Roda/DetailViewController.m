//
//  DetailViewController.m
//  Ruim de Roda
//
//  Created by Henrique Velloso on 4/11/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImageView+WebCache.h"
#import "InappropriateViewController.h"

@interface DetailViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self.map setDelegate:self];
}

-(void) loadData {
    if (_report) {
        _lblCategory.text = _report.category.text;
        _lblPlate.text = _report.plate;
        _lblPlate.layer.cornerRadius = 3;
        _lblPlate.clipsToBounds = YES;
        _lblAddress.text = _report.address;
        _lblDate.text = [self formatDate:_report.createdAt withFormat:@"dd/MM/yyyy"];
        _lblHour.text = [self formatDate:_report.createdAt withFormat:@"hh:mm"];
        [_imgPhoto setImageWithURL:[NSURL URLWithString:_report.photo]  placeholderImage:[UIImage imageNamed:@"placeholder"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        MapAnnotation * pin = [[MapAnnotation alloc] init];
        pin.title = @"";
        pin.subtitle = @"";
        pin.coordinate = CLLocationCoordinate2DMake(_report.latitude.doubleValue, _report.longitude.doubleValue);
 
        [self.map addAnnotation:pin];
        
        // zoom the map into the users current location
          MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pin.coordinate, 6*METERS_MILE, 6*METERS_MILE);
         [[self map] setRegion:viewRegion animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addPins {
    for (MapAnnotation * pin in _locations) {
        [self.map addAnnotation:pin];
    }
}

-(NSString*) formatDate: (NSDate*)date withFormat:(NSString*)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];// here set format which you want...
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
    
    return convertedString;
}
- (IBAction)reportOption:(id)sender {
    UIActionSheet *actionButtonActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:@"Cancelar"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"Reportar abuso", nil];
    [actionButtonActionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"detailInappropriated" sender:nil];
    }
}

- (IBAction)backInappropriate:(UIStoryboardSegue *)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailInappropriated"]) {
        InappropriateViewController *ivc = segue.destinationViewController;
        ivc.reportID = _report.objectId;
    }
}

@end
