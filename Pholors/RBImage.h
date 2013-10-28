//
//  GameLogic.h
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBImage : NSObject

+ (UIColor *)averageColor:(UIImage*)image;
+ (UIColor*) getDominantColor:(UIImage*)image;
+ (float) LABeuclideanDistance:(UIColor*)color1 to:(UIColor*)color2;
+ (NSMutableArray*) RGBtoLAB:(UIColor*)color;
+ (UIColor*) randomColor;
+ (int) convertDistanceToPoints:(float)dist;
+ (int) convertPointstoStars:(int)points;

@end

