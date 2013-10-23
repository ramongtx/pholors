//
//  RBLevel.h
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBImage.h"

@interface RBLevel : NSObject


@property(strong, nonatomic) UIImage* imageUsed;
@property(nonatomic) int pointsScored;
@property(strong, nonatomic) UIColor * color;
@property(strong, nonatomic) UIColor * colorPlayed;

-(id) initWithColor:(UIColor*)color;


@end
