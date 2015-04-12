//
//  NewPlateTableViewController.m
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 12/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import "NewPlateTableViewController.h"
#import "PlateManager.h"
#import "UserManager.h"

@interface NewPlateTableViewController ()

@end

@implementation NewPlateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (IBAction)newPlate:(id)sender {
    if (self.plateText.text.length == 7) {
        Plate *plate = [[Plate alloc] init];

        plate.plate = self.plateText.text;

        PlateManager *plateControl = [[PlateManager alloc] init];
        UserManager *userControl = [[UserManager alloc] init];

        [plateControl savePlate:plate forUser:[userControl getUserDefaults] response:^(BOOL success, NSError *error) {
            if (success) {
                [self performSelectorOnMainThread:@selector(successfulRequest) withObject:nil waitUntilDone:NO];
            } else {
                [self performSelectorOnMainThread:@selector(errorRequest) withObject:nil waitUntilDone:NO];
            }
        }];
    } else {
        [self alertWithTitle:@"Ops!" message:@"Sua placa deve ter 7 digitos"];
    }
}
- (void)successfulRequest {
    [self performSegueWithIdentifier:@"backPlaca" sender:self];
}

- (void)errorRequest {
    [self alertWithTitle:@"Ops!" message:@"Ocorreu um erro ao salvar placa"];
}
- (void)alertWithTitle:(NSString *)_alertTitle message:(NSString *)_alertMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_alertTitle message:_alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
