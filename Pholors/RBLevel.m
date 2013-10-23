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
        self.colorPlayed = nil;
        self.completed = NO;
    }
    return self;
}

-(id) initWithColor:(UIColor*)color{
    if(self = [super init]){
        self.imageUsed = nil;
        self.pointsScored = 0;
        self.color = color;
        self.colorPlayed = nil;
        self.completed = NO;
    }
    return self;
}


-(int) playImageOnLevel:(UIImage*)img{
    self.imageUsed = img;
    self.colorPlayed = [RBImage getDominantColor:img];
    self.pointsScored = 1 - [RBImage euclideanDistanceFrom:self.color to:self.colorPlayed];
    
    return self.pointsScored;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.imageUsed forKey:@"imageUsed"];
    [encoder encodeInteger:self.pointsScored forKey:@"pointsScored"];
    [encoder encodeObject:self.color forKey:@"color"];
    [encoder encodeObject:self.colorPlayed forKey:@"colorPlayed"];
    [encoder encodeBool:[self completed] forKey:@"completed"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if(self = [super init]){
        self.imageUsed = [decoder decodeObjectForKey:@"imageUsed"];
        self.pointsScored = [decoder decodeIntegerForKey:@"pointsScored"];
        self.color = [decoder decodeObjectForKey:@"color"];
        self.colorPlayed = [decoder decodeObjectForKey:@"colorPlayed"];
        self.completed = [decoder decodeObjectForKey:@"completed"];
    }
    
    return self;

}

@end
