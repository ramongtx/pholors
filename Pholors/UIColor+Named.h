//
//  UIColor+Named.h
//  RGBSliders
//
//  Created by Gabriel Ribeiro on 05/12/13.
//  Copyright (c) 2013 Gabriel Ribeiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Named)

/**
 *  Retrieves color name from RGB
 *
 *  @param red   Red pigment value
 *  @param green Green pigment value
 *  @param blue  Blue pigment value
 *
 *  @return color label string
 */
+ (NSString *)colorNameFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (UIColor *) colorFromName:(NSString*)colorName;

+ (NSArray *)getColorsData;


@end
