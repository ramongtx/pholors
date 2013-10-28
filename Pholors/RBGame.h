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
-(void) createLevelSet;
-(void) saveLevels;
-(void) loadLevels;


+(void) loadDefaultLevels;
+(void) saveDefaultLevels;
+(void) createDefaultSet;
+(NSArray*) getDefaultLevels;
+(long) allStars;
+(long) maxStars;

+(BOOL) updateRecord:(int)newRecord;
+(void) loadRecords;
+(long int) getRecord;
+(void)clearRecord;

@end

static NSMutableArray* defaultLevels;
static long int timeRecord;