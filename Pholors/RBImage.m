//
//  GameLogic.m
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "RBImage.h"

@implementation RBImage


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

+ (NSMutableArray*) RGBtoLAB:(UIColor*)color{
    const CGFloat* componentsColor = CGColorGetComponents([color CGColor]);
    
    float x, y, z;
    float xW, yW, zW;
    float auxFloat = 1/0.17697;
    
    xW = auxFloat *( 0.49 + 0.31 + 0.2);
    yW = auxFloat *( 0.17697  + 0.8124 + 0.01063);
    zW = auxFloat * (0 + 0.01 + 0.99);
    
    x = auxFloat *( 0.49 * componentsColor[0] + 0.31 * componentsColor[1] + 0.2 * componentsColor[2]);
    y = auxFloat *( 0.17697 * componentsColor[0] + 0.8124 * componentsColor[1] + 0.01063 * componentsColor[2]);
    z = auxFloat *( 0 * componentsColor[0] + 0.01 * componentsColor[1] + 0.99 * componentsColor[2]);
    
    float l, a, b;
    float Xrel = x/xW, Yrel = y/yW, Zrel = z/zW;
    float Fx, Fy, Fz;
    
    
    if(Xrel > 0.008856) Fx = pow(Xrel,1/3);
    else Fx = 7.787 * Xrel + 16/116;
    
    if(Yrel > 0.008856) Fy = pow(Yrel,1/3);
    else Fy = 7.787 * Yrel + 16/116;
    
    if(Zrel > 0.008856) Fz = pow(Zrel,1/3);
    else Fz = 7.787 * Zrel + 16/116;

    
    
    if(Yrel > 0.008856) l = 116 * pow(Yrel,1/3) - 16;
    else l = 903.3 * Yrel;
    
    a = 500 * (Fx - Fy);
    b = 200 * (Fy - Fz);

    NSMutableArray* labArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:l],[NSNumber numberWithFloat:a], [NSNumber numberWithFloat:b],nil];
    return labArray;
}

+ (float) euclideanDistanceFrom:(UIColor*)color1 to:(UIColor*)color2{
    
    
}


+ (float) LABeuclideanDistance:(UIColor*)color1 to:(UIColor*)color2{
    
    NSMutableArray* LABcolor1, *LABcolor2;
    
    LABcolor1 = [RBImage RGBtoLAB:color1];
    LABcolor2 = [RBImage RGBtoLAB:color2];
    
    NSLog(@"l1: %f, a1: %f, b1: %f", [LABcolor1[0] floatValue],[LABcolor1[1] floatValue],[LABcolor1[2] floatValue]);
    NSLog(@"l1: %f, a1: %f, b1: %f", [LABcolor1[0] floatValue],[LABcolor2[1] floatValue],[LABcolor2[2] floatValue]);
    float dist = 0;
    
    dist += pow(([LABcolor1[0] floatValue]-[LABcolor2[0] floatValue]),2) + pow(([LABcolor1[1] floatValue]-[LABcolor2[1] floatValue]),2) + pow(([LABcolor1[2] floatValue]-[LABcolor2[2] floatValue]),2);
    
    NSLog(@"EuclidDist: %f",sqrt(dist));
    
    NSLog(@"%d",[RBImage convertDistanceToPoints:sqrt(dist)]);
    
    return sqrt(dist);
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
    int temp = ceil( 100 * (sqrt(3.0) - dist) / sqrt(3.0));
    if (temp < 25) temp = temp*temp/25;
    else if (temp >75)
    {
        temp = temp-75;
        temp = (50*temp-temp*temp)/25;
        temp = temp+75;
    }
    return temp;
}

+ (int) convertPointstoStars:(int)points{
    int maxStars = 3;
    return round(points * maxStars / 100);
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
