//
//  PlateViewController.m
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 11/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "PlateViewController.h"
#import "PlateManager.h"
#import "PlateTableViewCell.h"

@interface PlateViewController () {
    NSMutableArray *allPlates;
}

@end

@implementation PlateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    allPlates = [[NSMutableArray alloc] init];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData:nil];
}

- (void)loadData:(UIRefreshControl *)refreshControl {
    PlateManager *plateManager = [[PlateManager alloc] init];
    [plateManager requestPlates:^(NSArray *resultPlates, NSError *error) {
        if (resultPlates) {
            allPlates = [resultPlates mutableCopy];
            [self performSelectorOnMainThread:@selector(updateTableView) withObject:refreshControl waitUntilDone:NO];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allPlates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plateCell" forIndexPath:indexPath];
    
    Plate *plate = [allPlates objectAtIndex:indexPath.row];
    
    cell.plateNumber.text = plate.plate;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PlateManager *plateControl = [[PlateManager alloc] init];
        Plate *plate = [allPlates objectAtIndex:indexPath.row];
        
        [plateControl removePlate:plate.objectId response:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [allPlates removeObjectAtIndex:indexPath.row];
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self updateTableView];
            }
        }];
    } else {
        NSLog(@"Unhandled editing style!");
    }
}
- (IBAction)newPlate:(id)sender {
    [self performSegueWithIdentifier:@"newPlate" sender:self];
}
- (IBAction)backPlate:(UIStoryboardSegue *)sender {
}
- (void)updateTableView {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
