//
//  InappropriateViewController.m
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 15/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "InappropriateViewController.h"
#import "InappropriateTableViewCell.h"
#import "TabBarViewController.h"

@interface InappropriateViewController (){
    NSMutableArray *inappropriateOptions;
}


@end

@implementation InappropriateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    inappropriateOptions = [[NSMutableArray alloc] init];
    
    [self loadData:nil];
}
- (void)loadData:(UIRefreshControl *)refreshControl {
    
    Inappropriate *inappropriateControl = [[Inappropriate alloc] init];
    
    [inappropriateControl requestInappropriate:^(NSArray *allReports, NSError *error) {
        inappropriateOptions = [allReports mutableCopy];
        [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
    }];
}
- (void) updateTableView {
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [inappropriateOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InappropriateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inappropriateCell" forIndexPath:indexPath];
    
    Inappropriate *inappropriate = [inappropriateOptions objectAtIndex:indexPath.row];
    
    cell.inappropriateText.text = inappropriate.text;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Inappropriate *inappropriate = [inappropriateOptions objectAtIndex:indexPath.row];
    
    [inappropriate addInappropriateQuery:inappropriate.objectId toReportId:_reportID response:^(BOOL succeeded, NSError *error) {
        if (succeeded == YES) {
            [self performSelectorOnMainThread:@selector(successfulRequest) withObject:nil waitUntilDone:NO];
        } else {
            [self performSelectorOnMainThread:@selector(errorRequest) withObject:nil waitUntilDone:NO];
        }
    }];
    
}
- (void)successfulRequest {
    [self performSegueWithIdentifier:@"segueBackFeed" sender:self];
}

- (void)errorRequest {
    [self alertWithTitle:@"Erro!" message:@"Ocorreu um erro ao denunciar"];
}
- (void)alertWithTitle:(NSString *)_alertTitle message:(NSString *)_alertMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_alertTitle message:_alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
