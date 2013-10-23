//
//  LevelTableCell.h
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIImageView *colorImage;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;

@end
