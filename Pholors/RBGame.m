//
//  RBGame.m
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "RBGame.h"

@implementation RBGame


-(id) init
{
    if(self = [super init]){
        self.levels = [[NSMutableArray alloc] init];
        self.totalPoints = 0 ;
        
    }
    return self;
}

-(void) createLevel
{
    RBLevel * newLevel = [[RBLevel alloc] init];
    [self.levels addObject:newLevel];
    
    // maybe remove this
    [self saveLevels];
        
}

-(void) saveLevels
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.levels];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"mylevels"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



-(void) loadLevels
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"mylevels"];
    NSArray *levels = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.levels = [NSMutableArray arrayWithArray:levels];
}



@end
