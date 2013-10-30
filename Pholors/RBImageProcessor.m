//
//  GameLogic.m
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "RBImageProcessor.h"

@implementation RBImageProcessor


+ (UIColor *)averageColor:(UIImage*)image {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}

struct pixel {
    unsigned char r, g, b, a;
};

+ (UIColor*) getDominantColor:(UIImage*)image
{
    NSUInteger red = 0;
    NSUInteger green = 0;
    NSUInteger blue = 0;
    
    
    // Allocate a buffer big enough to hold all the pixels
    
    struct pixel* pixels = (struct pixel*) calloc(1, image.size.width * image.size.height * sizeof(struct pixel));
    if (pixels != nil)
    {
        
        CGContextRef context = CGBitmapContextCreate(
                                                     (void*) pixels,
                                                     image.size.width,
                                                     image.size.height,
                                                     8,
                                                     image.size.width * 4,
                                                     CGImageGetColorSpace(image.CGImage),
                                                     (CGBitmapInfo)kCGImageAlphaPremultipliedLast
                                                     );
        
        if (context != NULL)
        {
            // Draw the image in the bitmap
            
            CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), image.CGImage);
            
            // Now that we have the image drawn in our own buffer, we can loop over the pixels to
            // process it. This simple case simply counts all pixels that have a pure red component.
            
            // There are probably more efficient and interesting ways to do this. But the important
            // part is that the pixels buffer can be read directly.
            
            NSUInteger numberOfPixels = image.size.width * image.size.height;
            for (int i=0; i<numberOfPixels; i++) {
                red += pixels[i].r ;//* pixels[i].a;
                green += pixels[i].g;// * pixels[i].a;
                blue += pixels[i].b;// * pixels[i].a;
            }
            
            
            red /= numberOfPixels;
            green /= numberOfPixels;
            blue/= numberOfPixels;
            
            
            CGContextRelease(context);
        }
        
        free(pixels);
    }
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}

+ (float) euclideanDistanceFrom:(UIColor*)color1 to:(UIColor*)color2{
    const CGFloat* componentsColor1 = CGColorGetComponents([color1 CGColor]);
    const CGFloat* componentsColor2 = CGColorGetComponents([color2 CGColor]);
    
    float dist = 0;
    
    dist = pow(componentsColor1[0] - componentsColor2[0],2) + pow(componentsColor1[1] - componentsColor2[1],2) + pow(componentsColor1[2] - componentsColor2[2],2);
    NSLog(@"Euclidean Dist: %f",sqrt(dist));
    return sqrt(dist);
}

+ (float) cossineSimilarityFrom:(UIColor*)color1 to:(UIColor*)color2{
    const CGFloat* componentsColor1 = CGColorGetComponents([color1 CGColor]);
    const CGFloat* componentsColor2 = CGColorGetComponents([color2 CGColor]);
    
    float cossine, norm1, norm2;
    
    cossine = (componentsColor1[0] * componentsColor2[0]) + (componentsColor1[1] * componentsColor2[1]) + (componentsColor1[2] * componentsColor2[2]);
    norm1 = sqrt(pow(componentsColor1[0],2) + pow(componentsColor1[1], 2) + pow(componentsColor1[2],2));
    norm2 = sqrt(pow(componentsColor2[0],2) + pow(componentsColor2[1], 2) + pow(componentsColor2[2],2));
    
    cossine = cossine / (norm1 * norm2);
    NSLog(@"CS: %f",cossine);
    return cossine;
}

+ (UIColor*) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

+ (int) convertDistanceToPoints:(float)dist{
//    int temp = ceil( 100 * (sqrt(3.0) - dist) / sqrt(3.0));
//    if (temp <= 50) temp = floor(exp(temp/14.0));
//    else if (temp > 60)
//    {
//        temp = temp-60;
//        temp = (60*temp-temp*temp)/25;
//        temp = temp+60;
//    }
//    return temp;
    return round(dist * 100);
}

+ (int) convertPointstoStars:(int)points{
//    int maxStars = 3;
//    return round(points * maxStars / 100);
    if(points < 60) return 0;
    if(points < 75) return 1;
    if(points < 95) return 2;
    return 3;

}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    float red = ((rgbValue & 0xFF0000) >> 16)/255.0;
    float green = ((rgbValue & 0xFF00) >> 8)/255.0;
    float blue = (rgbValue & 0xFF)/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


@end