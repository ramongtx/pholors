//
//  RBGame.h
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBLevel.h"

@interface RBGame : NSObject

@property (strong, nonatomic)NSMutableArray* levels;
@property (nonatomic) int totalPoints;
@property (strong, nonatomic)NSUserDefaults* prefs;
-(void) createLevel;
-(void) saveLevels;
-(void) loadLevels;


@end
