//
//  LevelsViewController.h
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBGame.h"
#import "LevelTableCell.h"
#import "RBCustomSegue.h"
#import "ViewController.h"

@interface LevelsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) RBLevel* level;

@end
