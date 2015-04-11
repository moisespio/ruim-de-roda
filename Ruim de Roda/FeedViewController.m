//
//  FeedViewController.m
//  Ruim de Roda
//
//  Created by Henrique Velloso on 4/11/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"
#import "Report.h"
#import "ReportManager.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"



#import "UIImageView+WebCache.h"



@interface FeedViewController ()

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self loadData:nil];
}


- (void)loadData:(UIRefreshControl *)refreshControl {
    ReportManager *reportManager = [[ReportManager alloc] init];
    [reportManager requestReports:^(NSArray *resultReports, NSError *error) {
        
        if (resultReports) {
            
            _arrayReports = [resultReports mutableCopy];
            [self.tableView reloadData];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_arrayReports count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    Report *report = [_arrayReports objectAtIndex:indexPath.row];
    
    cell.lblCategory.text = report.category.text;
    cell.lblPlate.text = report.plate;
    cell.lblDate.text = [self formatDate:report.createdAt withFormat:@"dd/MM/yyyy"];
    cell.lblHour.text = [self formatDate:report.createdAt withFormat:@"hh:mm"];
    [cell.viewPostIcon setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:45.0/255.0 blue:100.0/255.0 alpha: 1]];
    cell.viewPostIcon.layer.cornerRadius = cell.viewPostIcon.frame.size.width / 2;
    cell.viewPostIcon.clipsToBounds = YES;
    cell.viewPostIcon.layer.borderWidth = 5;
    cell.viewPostIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    
    cell.viewImgPhoto.layer.cornerRadius = 6;
    cell.imgPhoto.layer.cornerRadius = 3;
    cell.imgPhoto.clipsToBounds = YES;
    
    [cell.imgPhoto setImageWithURL:[NSURL URLWithString:report.photo]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]
        usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    return cell;
}


-(NSString*) formatDate: (NSDate*)date withFormat:(NSString*)format {
    
    /*
    NSString *str = @"2012-10-30"; /// here this is your date with format yyyy-MM-dd
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:format]; //// here set format of date which is in your output date (means above str with format)
    
    NSDate *date = [dateFormatter dateFromString: str]; // here you can fetch date from string with define format
    */
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];// here set format which you want...
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
    //NSLog(@"Converted String : %@",convertedString);
    
    
    return convertedString;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
