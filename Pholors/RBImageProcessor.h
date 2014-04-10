//
//  GameLogic.h
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//


//Class responsable for every image processing done in the game

#import <Foundation/Foundation.h>

@interface RBImageProcessor : NSObject

+ (UIColor*) getDominantColor:(UIImage*)image;
+ (float) cossineSimilarityFrom:(UIColor*)color1 to:(UIColor*)color2;
+ (UIColor*) randomColor;
+ (int) convertDistanceToPoints:(float)dist;
+ (int) convertLABDistanceToPoints:(float)dist;
+ (int) convertPointstoStars:(int)points;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (double) labDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2;
+(double) LMSDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2;
+ (int) convertLMSDistanceToPoints:(float)dist;

@end

