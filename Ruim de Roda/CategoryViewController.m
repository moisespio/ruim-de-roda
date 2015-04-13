//
//  CategoryViewController.m
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 11/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"
#import "ReportViewController.h"
#import "CategoryReportManager.h"
#import <Parse/Parse.h>

@interface CategoryViewController () {
    NSMutableArray *categoryArray;
}

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


    categoryArray = [[NSMutableArray alloc] init];
    
    [self loadCategory];
}

-(void) loadCategory {
    CategoryReportManager *categoryControl = [[CategoryReportManager alloc] init];
    
    [categoryControl requestCategory:^(NSArray *resultCategories, NSError *error) {
        categoryArray = [resultCategories mutableCopy];

        [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
    }];
}

- (void)updateTableView {
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categoryArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    
    CategoryReport *crm = [categoryArray objectAtIndex:indexPath.row];

    cell.categoryName.text = crm.text;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryReport *crm = [categoryArray objectAtIndex:indexPath.row];
    
    _categoryID = crm.objectId;
    _categoryText = crm.text;
   
    [self performSegueWithIdentifier:@"segueBackCategory" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ReportViewController *rpv = [segue destinationViewController];
    rpv.categoryID = _categoryID;
    rpv.categoryText.text = _categoryText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
