//
//  GameLogic.h
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameLogic : NSObject

+ (UIColor *)averageColor:(UIImage*)image;
+ (UIColor*) getDominantColor:(UIImage*)image;

@end

