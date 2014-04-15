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

// Common methods //
+ (UIColor*)getDominantColor:(UIImage*)image;
+ (UIColor*)randomColor;
+ (UIColor*)colorFromHexString:(NSString*)hexString;

// Distance methods //
+ (float)cossineSimilarityFrom:(UIColor*)color1 to:(UIColor*)color2;
+ (float)weightedDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2;
+ (double)YUVDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2;
+ (double)LABDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2;
+ (double)LMSDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2;

// Convertion methods //
+ (int)convertWeightedDistanceToPoints:(float)dist;
+ (int)convertLMSDistanceToPoints:(float)dist;
+ (int)convertDistanceToPoints:(float)dist;
+ (int)convertLABDistanceToPoints:(float)dist;
+ (int)convertPointstoStars:(int)points;

// Comparison between colors //
+ (int)YUVPointsComparingColor:(UIColor*)color toColor:(UIColor*)targetColor;
+ (int)LMSPointsComparingColor:(UIColor*)color toColor:(UIColor*)targetColor;
+ (int)LABPointsComparingColor:(UIColor*)color toColor:(UIColor*)targetColor;

// Neural Network Learning Methods... TO BE DELETED //
+ (void)writeToLearningLog:(UIColor* const)color1 To:(UIColor* const)color2 Stars:(double const)stars;

+ (MLPNeuralNet*)nnetModel;
+ (int)classifyColor:(UIColor*)color againstColor:(UIColor*)targetColor;

//+ (double)classifyColor:(UIColor*)color againstColor:(UIColor*)targetColor;

@end
