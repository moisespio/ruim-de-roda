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
    
    [cell.imgPhoto setImageWithURL:[NSURL URLWithString:report.photo]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]
        usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    return cell;
}


-(NSString*) formatDate: (NSDate*)date withFormat:(NSString*)format {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];// here set format which you want...
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
    
    return convertedString;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
