//
//  LevelCollectionCell.h
//  Pholors
//
//  Created by Felix Dumit on 4/25/14.
//  Copyright (c) 2014 Rock Bottom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBLevel.h"

@interface LevelCollectionCell : UICollectionViewCell

@property(weak, nonatomic) IBOutlet UILabel* cellLabel;
@property(strong, nonatomic) IBOutlet UIImageView* colorImage;
@property(weak, nonatomic) IBOutlet UIImageView* starImage;
@property(strong, nonatomic) RBLevel* level;

@end
