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
#import "DetailViewController.h"
#import "UserManager.h"
#import "TabBarViewController.h"
#import "Reachability.h"

@interface FeedViewController () {
    Reachability *internetReachableFoo;
}

@end

@implementation FeedViewController

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testInternetConnection];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-header"]];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    UserManager *userManager = [[UserManager alloc] init];
    
    if (![userManager getUserDefaults]) {
        [userManager createUser:^(NSString *objectID, NSError *error) {
            if (!error) {
                [userManager setUserDefaults:objectID];
            }
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    [self loadByPushNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self testInternetConnection];
    [self loadData:nil];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidDisappear:NO];
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake ) {
        [self.tabBarController setSelectedIndex:1];
    }
}

- (void) loadByPushNotification {
    TabBarViewController * tabBarController = (TabBarViewController*)self.tabBarController;
    
    if (tabBarController.report) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        vc.report = tabBarController.report;
        [self.navigationController pushViewController:vc animated:YES];
       // [self.tableView reloadData];
       // tabBarController.report = nil;
    }
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake ) {
    }
}

- (void)testInternetConnection {
    __weak typeof(self) weakSelf = self;

    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach) {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
//            weakSelf.tableView.hidden = NO;
//            weakSelf.internetAlert.hidden = YES;
            NSLog(@"tem internet");
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach) {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.tableView setHidden:NO];
//            weakSelf.tableView.hidden = YES;
//            weakSelf.internetAlert.hidden = NO;
            NSLog(@"nao tem internet");
        });
    };

    [internetReachableFoo startNotifier];
}

- (void)loadData:(UIRefreshControl *)refreshControl {
    ReportManager *reportManager = [[ReportManager alloc] init];
    [reportManager requestReports:^(NSArray *resultReports, NSError *error) {
        if (resultReports) {
            _arrayReports = [resultReports mutableCopy];
            [self performSelectorOnMainThread:@selector(updateTableView:) withObject:refreshControl waitUntilDone:NO];
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
    cell.lblPlate.layer.cornerRadius = 3;
    cell.lblPlate.clipsToBounds = YES;
    
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];// here set format which you want...
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
    
    return convertedString;
}

- (void)updateTableView:(UIRefreshControl *)refreshControl {
    if (refreshControl)
        [refreshControl endRefreshing];

    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Report *report = [_arrayReports objectAtIndex:indexPath.row];
    _selectedReport = report;
    
    [self performSegueWithIdentifier:@"segueDetail" sender:self];
}
- (IBAction)goConfig:(id)sender {
    [self performSegueWithIdentifier:@"configSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueDetail"]) {
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.report = _selectedReport;
    }
}

@end
