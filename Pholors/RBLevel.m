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
        self.pointsScored = 0;
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
        self.pointsScored = 0;
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
        self.pointsScored = 0;
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
    int YUVpoints = [RBImageProcessor YUVPointsComparingColor:self.color
                                                      toColor:color];
    int LMSpoints = [RBImageProcessor LMSPointsComparingColor:self.color
                                                      toColor:color];
    int LABpoints = [RBImageProcessor LABPointsComparingColor:self.color
                                                      toColor:color];

    int points = (4 * YUVpoints + LMSpoints + LABpoints) / 6;

    NSLog(@"LMS:%d YUV:%d LAB:%d", LMSpoints, YUVpoints, LABpoints);
    NSLog(@"Average Points: %d", points);

    NSLog(@"Predicted stars: %d", [RBImageProcessor classifyColor:self.color
                                                     againstColor:color]);

    // ==========================================================================

    if (points > MAX(0, self.pointsScored)) {
        self.colorPlayed = color;
        self.pointsScored = MAX(points, self.pointsScored);
        self.completed = YES;
    }
    return points;
}

- (int)stars
{
    return [RBImageProcessor convertPointstoStars:self.pointsScored];
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeInteger:self.pointsScored
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
        self.pointsScored = (int)[decoder decodeIntegerForKey:@"pointsScored"];
        self.color = [decoder decodeObjectForKey:@"color"];
        self.colorPlayed = [decoder decodeObjectForKey:@"colorPlayed"];
        self.colorName = [decoder decodeObjectForKey:@"colorName"];
        self.completed = (BOOL)[decoder decodeObjectForKey : @"completed"];
    }

    return self;
}

@end
