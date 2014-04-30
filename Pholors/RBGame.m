//
//  RBGame.m
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "RBGame.h"
#import "UIColor+Named.h"
#import <GameKit/GameKit.h>

@implementation RBGame

static long int timeRecord;
static long int levelPackCount = 2;

- (id)init
{
    if (self = [super init]) {
        self.levels = defaultLevels;
        self.totalPoints = 0;
    }
    return self;
}

- (void)createLevel
{
    RBLevel* newLevel = [[RBLevel alloc] init];
    [self.levels addObject:newLevel];
    
    // maybe remove this
    [self saveLevels];
}

- (void)createLevelSet
{
    for (int i = 0; i < 10; i++)
        [self createLevel];
}

- (void)saveLevels
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.levels];
    [[NSUserDefaults standardUserDefaults] setObject:data
                                              forKey:@"mylevels"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    defaultLevels = self.levels;
}

- (void)loadLevels
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"mylevels"];
    NSArray* levels = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.levels = [NSMutableArray arrayWithArray:levels];
    defaultLevels = self.levels;
}

+ (void)loadDefaultLevels
{
    defaultLevels = [[NSMutableArray alloc] init];
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"levels"];
    defaultLevels = [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void)saveDefaultLevels
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:defaultLevels];
    [[NSUserDefaults standardUserDefaults] setObject:data
                                              forKey:@"levels"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)createDefaultSet
{
    //    NSDictionary* colors = @{@"Air Force Blue": @"#5d8aa8",
    //                             @"Apple green": @"#8db600",
    //                             @"AuroMetalSaurus": @"#6e7f80",
    //                             @"Banana yellow": @"#ffe135",
    //                             @"Bittersweet": @"#fe6f5e",
    //                             @"Bubble gum": @"#ffc1cc",
    //                             @"Bubbles": @"#e7feff",
    //                             @"Capri": @"#00bfff",
    //                             @"Cinnamon": @"#d2691e",
    //                             @"Cofee": @"#6f4e37",
    //                             @"Ferrari Red": @"#ff2800",
    //                             @"Electric Purple": @"#bf00ff",
    //                             @"Grullo": @"#a99a86",
    //                             @"Inchworm": @"#b2ec5d",
    //                             @"Navy Blue": @"#000080",
    //                             @"Pastel Yellow": @"#fdfd96",
    //                             @"Pumpkin": @"#ff7518",
    //                             @"Purple pizzazz": @"#fe4eda",
    //                             @"Wine" : @"#722f37",
    //                             @"White Smoke": @"#f5f5f5",
    //                             @"Smoky Black": @"#100c08",
    //                             @"Sand": @"#c2b280",
    //                             @"Ruby": @"#e0115f",
    //                             @"Mango Tango": @"#ff8243"
    //                             };
    NSArray* colors = [UIColor getColorsData];
    
    if (defaultLevels == NULL) {
        defaultLevels = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < [colors count]; i++) {
        
        if (i % 40 < levelPackCount) {
            NSDictionary* color = [colors objectAtIndex:i];
            
            RBLevel* newLevel = [[RBLevel alloc] initWithName:[color objectForKey:@"label"]
                                                          red:[[color objectForKey:@"r"] integerValue]
                                                        green:[[color objectForKey:@"g"] integerValue]
                                                         blue:[[color objectForKey:@"b"] integerValue]];
            if (![RBGame isColorOnGame:newLevel.colorName])
                [defaultLevels addObject:newLevel];
        }
    }
    
    [self saveDefaultLevels];
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:@"levelset"];
}

+ (BOOL)isColorOnGame:(NSString*)color
{
    for (RBLevel* level in defaultLevels) {
        if ([level.colorName isEqualToString:color])
            return YES;
    }
    
    return NO;
}

+ (NSArray*)getDefaultLevels
{
    return defaultLevels;
}

+ (long)allStars
{
    long i = 0;
    for (RBLevel* l in defaultLevels) {
        i += [l stars];
    }
    return i;
}

+ (long)maxStars
{
    return 3 * [defaultLevels count];
}

+ (BOOL)updateRecord:(int)newRecord
{
    if (newRecord > timeRecord) {
        [[NSUserDefaults standardUserDefaults] setInteger:newRecord
                                                   forKey:@"timeRecord"];
        timeRecord = newRecord;
        
        GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:@"TIME_ATTACK_BEST"];
        score.value = timeRecord;
        
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error)
         {
             if (error != nil) {
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
        
        return YES;
    }
    return NO;
}

+ (void)loadRecords
{
    timeRecord = [[NSUserDefaults standardUserDefaults] integerForKey:@"timeRecord"];
}

+ (long int)getRecord
{
    return timeRecord;
}

+ (void)clearRecord
{
    timeRecord = 0;
    [RBGame updateRecord:0];
    defaultLevels = nil;
}

+ (void)clearAll
{
    [RBGame clearRecord];
    [RBGame createDefaultSet];
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:@"levelset"];
}

+ (void)increaseLevelPackCount
{
    levelPackCount = 3;
    //levelPackCount += 1;
    [RBGame createDefaultSet];
}

+ (void)updateAchievements
{
    NSString* achievementIdentifier;
    float progressPercentage = 0.0;
    
    GKAchievement* scoreAchievement = nil;
    
    int currentStars = [RBGame allStars];
    
    if (currentStars <= 5) {
        progressPercentage = currentStars * 100 / 5;
        achievementIdentifier = @"5_Challenge_Stars";
    }
    
    scoreAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
    scoreAchievement.percentComplete = progressPercentage;
    
    [GKAchievement reportAchievements:@[scoreAchievement] withCompletionHandler:^(NSError *error)
     {
         if (error != nil) {
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
}

@end
