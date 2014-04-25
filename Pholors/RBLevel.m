//
//  RBLevel.m
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "RBLevel.h"

@implementation RBLevel

- (id)init
{
    if (self = [super init]) {
        self.starsScored = 0;
        self.color = [RBImageProcessor randomColor];
        self.colorName = self.color.description;
        self.colorPlayed = nil;
        self.completed = NO;
        self.isTimeAttack = NO;
    }
    return self;
}

- (id)initWithName:(NSString*)name red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    if (self = [super init]) {
        self.starsScored = 0;
        self.color = [UIColor colorWithRed:red / 255.0
                                     green:green / 255.0
                                      blue:blue / 255.0
                                     alpha:1.0];
        self.colorName = name;
        self.colorPlayed = nil;
        self.completed = NO;
        self.isTimeAttack = NO;
    }
    return self;
}

- (id)initWithColor:(NSString*)colorHex name:(NSString*)name
{
    if (self = [super init]) {
        self.starsScored = 0;
        self.color = [RBImageProcessor colorFromHexString:colorHex];
        self.colorName = name;
        self.colorPlayed = nil;
        self.completed = NO;
        self.isTimeAttack = NO;
    }
    return self;
}

- (void)changeColor
{
    self.color = [RBImageProcessor randomColor];
}

- (int)playImageOnLevel:(UIImage*)img
{
    UIColor* color = [RBImageProcessor getDominantColor:img];

    // CURRENTLY USING AN AVERAGE OF LAB, LMS AND YUV METHODS ===================

    int stars = [RBImageProcessor classifyColor:self.color
                                   againstColor:color];

    //stars = [RBImageProcessor convertPointstoStars:[RBImageProcessor YUVPointsComparingColor:self.color
    //                                                                                 toColor:color]];
    // ==========================================================================

    if (stars > MAX(0, self.starsScored)) {
        self.colorPlayed = color;
        self.starsScored = MAX(stars, self.starsScored);
        self.completed = YES;
    }
    return stars;
}

- (int)stars
{
    return self.starsScored; //[RBImageProcessor convertPointstoStars:self.starsScored];
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeInteger:self.starsScored
                    forKey:@"pointsScored"];
    [encoder encodeObject:self.color
                   forKey:@"color"];
    [encoder encodeObject:self.colorPlayed
                   forKey:@"colorPlayed"];
    [encoder encodeObject:self.colorName
                   forKey:@"colorName"];
    [encoder encodeBool:[self completed]
                 forKey:@"completed"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init]) {
        self.starsScored = (int)[decoder decodeIntegerForKey:@"pointsScored"];
        self.color = [decoder decodeObjectForKey:@"color"];
        self.colorPlayed = [decoder decodeObjectForKey:@"colorPlayed"];
        self.colorName = [decoder decodeObjectForKey:@"colorName"];
        self.completed = (BOOL)[decoder decodeObjectForKey : @"completed"];
    }

    return self;
}

@end
