//
//  SearchViewController.m
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 11/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "ReportManager.h"
#import "DetailViewController.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *allReports;
    NSMutableArray *searchReports;
    BOOL isFiltered;
}


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    
    [self.tableView addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

    [self loadData:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [self loadData:nil];
}
- (void)loadData:(UIRefreshControl *)refreshControl {
    ReportManager *reportManager = [[ReportManager alloc] init];
    [reportManager requestReports:^(NSArray *resultReports, NSError *error) {
        
        if (resultReports) {
            
            allReports = [resultReports mutableCopy];
            [self performSelectorOnMainThread:@selector(updateTableView) withObject:refreshControl waitUntilDone:NO];
        }
    }];
}

#pragma mark - Methods of UITableView (Delegate)

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isFiltered)
        return [searchReports count];
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    Report *report = [searchReports objectAtIndex:indexPath.row];
    
    cell.addressLabel.text = report.address;
    cell.reportLabel.text = report.category.text;
    cell.dateLabel.text = [self formatDate:report.createdAt withFormat:@"dd/MM/yyyy"];
    cell.hourLabel.text = [self formatDate:report.createdAt withFormat:@"hh:mm"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Report *report = [searchReports objectAtIndex:indexPath.row];
    _selectedReport = report;
    
    [self performSegueWithIdentifier:@"detailSearch" sender:self];
    
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    if(text.length == 0) {
        isFiltered = FALSE;
    }
    else {
        isFiltered = true;
        searchReports = [[NSMutableArray alloc] init];
        for (int i = 0;i < [allReports count]; i++) {
            Report *report = [allReports objectAtIndex:i];
            
            
            NSRange plateRange = [report.plate rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(plateRange.location != NSNotFound) {
                [searchReports addObject:report];
            }
        }
    }
    
    [self.tableView reloadData];
}

-(void) updateTableView {
    [self.tableView reloadData];
}

- (void) keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, kbSize.height-44, 0);
    
    [UIView animateWithDuration:0.25f animations:^{
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }];
    
}
- (void) keyboardWillBeHidden:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, 0, 0);
    
    [UIView animateWithDuration:0.25f animations:^{
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }];
    
}

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}

-(NSString *)formatDate: (NSDate*)date withFormat:(NSString*)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
    
    return convertedString;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.report = _selectedReport;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
