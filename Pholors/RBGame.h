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

@property(strong, nonatomic) NSMutableArray* levels;
@property(nonatomic) NSInteger totalPoints;
@property(strong, nonatomic) NSUserDefaults* prefs;

- (void)createLevel;
- (void)createLevelSet;
- (void)saveLevels;
- (void)loadLevels;

+ (void)loadDefaultLevels;
+ (void)saveDefaultLevels;
+ (void)createDefaultSet;
+ (NSArray*)getDefaultLevels;
+ (NSInteger)allStars;
+ (NSInteger)maxStars;

+ (BOOL)updateRecord:(NSInteger)newRecord;
+ (void)loadRecords;
+ (NSInteger)getRecord;
+ (void)clearRecord;

+ (void)clearAll;

+ (void)increaseLevelPackCount;

+ (void)updateAchievements;

@end

static NSMutableArray* defaultLevels;