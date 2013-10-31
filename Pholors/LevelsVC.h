//
//  LevelsViewController.h
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.



// Class that represents the ViewController responsible for the Level Selection Screen

#import <UIKit/UIKit.h>
#import "RBGame.h"
#import "LevelTableCell.h"
#import "RBCustomSegue.h"
#import "GameVC.h"

@interface LevelsVC : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) RBLevel* selectedLevel;

@end
