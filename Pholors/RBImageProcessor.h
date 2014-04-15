//
//  GameLogic.h
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

//Class responsable for every image processing done in the game

#import <Foundation/Foundation.h>
#import "MLPNeuralNet.h"

@interface RBImageProcessor : NSObject

+ (UIColor*)getDominantColor:(UIImage*)image;
+ (float)cossineSimilarityFrom:(UIColor*)color1 to:(UIColor*)color2;
+ (UIColor*)randomColor;
+ (int)convertDistanceToPoints:(float)dist;
+ (int)convertLABDistanceToPoints:(float)dist;
+ (int)convertPointstoStars:(int)points;
+ (UIColor*)colorFromHexString:(NSString*)hexString;

+ (double)labDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2;
+ (double)LMSDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2;
+ (int)convertLMSDistanceToPoints:(float)dist;

+ (double)YUVDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2;

+ (float)weightedDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2;
+ (int)convertWeightedDistanceToPoints:(float)dist;

+ (void)writeToLearningLog:(UIColor* const)color1 To:(UIColor* const)color2 Stars:(double const)stars;

+ (MLPNeuralNet*)nnetModel;
+ (double)classifyColor:(UIColor*)color againstColor:(UIColor*)targetColor;

+ (int)YUVPointsComparingColor:(UIColor*)color toColor:(UIColor*)targetColor;
+ (int)LMSPointsComparingColor:(UIColor*)color toColor:(UIColor*)targetColor;
+ (int)LABPointsComparingColor:(UIColor*)color toColor:(UIColor*)targetColor;

@end
