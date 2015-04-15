//
//  InappropriateViewController.h
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 15/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Inappropriate.h"

@interface InappropriateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString *reportID;

@end