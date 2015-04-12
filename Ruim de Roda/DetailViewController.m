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

@interface DetailViewController ()

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
        _lblDate.text = [self formatDate:_report.createdAt withFormat:@"dd/MM/yyyy"];
        _lblHour.text = [self formatDate:_report.createdAt withFormat:@"hh:mm"];
        [_imgPhoto setImageWithURL:[NSURL URLWithString:_report.photo]  placeholderImage:[UIImage imageNamed:@"placeholder"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

@end
