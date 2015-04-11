//
//  SearchViewController.m
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 11/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *searchResponse;
    NSMutableArray *profileUser;
    BOOL isFiltered;
    
    BOOL searchUsedForGA;
}


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)loadData:(UIRefreshControl *)refreshControl {

}

#pragma mark - Methods of UITableView (Delegate)

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isFiltered)
        return [searchResponse count];
    else
        return 0;
}


//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
//
//    return cell;
//}
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

@end
