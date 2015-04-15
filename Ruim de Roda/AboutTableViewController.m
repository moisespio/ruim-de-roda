//
//  AboutTableViewController.m
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 13/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController () {
    NSArray *henriqueUrl;
    NSArray *matheusUrl;
    NSArray *moisesUrl;
}

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    henriqueUrl = [[NSArray alloc]initWithObjects:@"https://br.linkedin.com/in/henriquevelloso", @"https://twitter.com/HenriqVelloso", nil];
    matheusUrl = [[NSArray alloc]initWithObjects:@"https://www.linkedin.com/in/matheusfrozzi", nil];
    moisesUrl = [[NSArray alloc]initWithObjects:@"https://www.linkedin.com/in/moisespio", @"http://twitter.com/moisesopio", nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 1) {
        return 1;
    } else {
        return 2;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *siteUrl;
    if (indexPath.section == 0) {
        siteUrl=[henriqueUrl objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        siteUrl=[matheusUrl objectAtIndex:indexPath.row];
    } else {
        siteUrl=[moisesUrl objectAtIndex:indexPath.row];
    }

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:siteUrl]];
}
@end