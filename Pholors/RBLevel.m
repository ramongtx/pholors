//
//  RBLevel.m
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "RBLevel.h"

@implementation RBLevel

-(id) init{
    if(self = [super init]){
        self.imageUsed = nil;
        self.pointsScored = 0;
        self.color = [RBImage randomColor];
    }
    return self;
}

-(id) initWithColor:(UIColor*)color{
    if(self = [super init]){
        self.imageUsed = nil;
        self.pointsScored = 0;
        self.color = color;
    }
    return self;
}


@end
