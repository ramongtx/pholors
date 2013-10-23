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
        
}



@end
