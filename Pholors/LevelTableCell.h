//
//  LevelTableCell.h
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

// LevelTableCell represents each cell of the level selection screen

#import <UIKit/UIKit.h>
#import "RBLevel.h"
#import <BRFlabbyTableViewCell.h>

@interface LevelTableCell : BRFlabbyTableViewCell
@property(weak, nonatomic) IBOutlet UILabel* cellLabel;
@property(strong, nonatomic) IBOutlet UIImageView* colorImage;
@property(weak, nonatomic) IBOutlet UIImageView* starImage;
@property(strong, nonatomic) RBLevel* level;

@end
