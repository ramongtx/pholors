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

+ (float) euclideanDistanceFrom:(UIColor*)color1 to:(UIColor*)color2{
    
    const CGFloat* componentsColor1 = CGColorGetComponents([color1 CGColor]);
    const CGFloat* componentsColor2 = CGColorGetComponents([color2 CGColor]);
    
    float dist = 0;
    
    for(int i=0; i<3; i++){
        dist += pow((componentsColor1[i] - componentsColor2[i]),2);
        NSLog(@"%f %f",componentsColor1[i],componentsColor2[i]);
    }
    NSLog(@"EuclidDist: %f",sqrt(dist));
    
    NSLog(@"%d",[RBImage convertDistanceToPoints:sqrt(dist)]);
    
    return sqrt(dist);
}

+ (float) YUVeuclideanDistanceFrom:(UIColor*)color1 to:(UIColor*)color2{
    
    const CGFloat* componentsColor1 = CGColorGetComponents([color1 CGColor]);
    const CGFloat* componentsColor2 = CGColorGetComponents([color2 CGColor]);
    
    float y1, y2,u1,u2,v1,v2;
    y1 = 0.299 * componentsColor1[0] + 0.587 * componentsColor1[1] + 0.114 * componentsColor1[2];
    y2 = 0.299 * componentsColor2[0] + 0.587 * componentsColor2[1] + 0.114 * componentsColor2[2];
    
    u1 = -0.14713 * componentsColor1[0] + (-0.28886) * componentsColor1[1] + 0.436 * componentsColor1[2];
    u2 = -0.14713 * componentsColor2[0] + (-0.28886) * componentsColor2[1] + 0.436 * componentsColor2[2];
    
    v1 = 0.615 * componentsColor1[0] + (-0.51499) * componentsColor1[1] + (-0.10001) * componentsColor1[2];
    v2 = 0.615 * componentsColor2[0] + (-0.51499) * componentsColor2[1] + (-0.10001) * componentsColor2[2];
    
    float dist = 0;
    
    dist += pow((y1-y2),2) + pow((u1-u2),2) + pow((v1-v2),2);
    
    NSLog(@"EuclidDist: %f",sqrt(dist));
    
    NSLog(@"%d",[RBImage convertDistanceToPoints:sqrt(dist)]);
    
    return sqrt(dist);
}

+ (float) XYZeuclideanDistanceFrom:(UIColor*)color1 to:(UIColor*)color2{
    
    const CGFloat* componentsColor1 = CGColorGetComponents([color1 CGColor]);
    const CGFloat* componentsColor2 = CGColorGetComponents([color2 CGColor]);
    
    
    float x1, x2,y1,y2,z1,z2;
    float auxFloat = 1/0.17697;
//    x1 = auxFloat *( 0.49 * componentsColor1[0] + 0.31 * componentsColor1[1] + 0.2 * componentsColor1[2]);
    x1 = auxFloat *( 0.49 + 0.31 + 0.2);
    y1 = auxFloat *( 0.17697  + 0.8124 + 0.01063);

    z1 = auxFloat;

    
    x2 = auxFloat *( 0.49 * componentsColor2[0] + 0.31 * componentsColor2[1] + 0.2 * componentsColor2[2]);
    
//    y1 = auxFloat *( 0.17697 * componentsColor1[0] + 0.8124 * componentsColor1[1] + 0.01063 * componentsColor1[2]);
    y2 = auxFloat *( 0.17697 * componentsColor2[0] + 0.8124 * componentsColor2[1] + 0.01063 * componentsColor2[2]);
//    z1 = auxFloat *( 0 * componentsColor1[0] + 0.01 * componentsColor1[1] + 0.99 * componentsColor1[2]);
    z2 = auxFloat *( 0 * componentsColor2[0] + 0.01 * componentsColor2[1] + 0.99 * componentsColor2[2]);
    
    float dist = 0;
    
    dist += pow((y1-y2),2) + pow((x1-x2),2) + pow((z1-z2),2);
    
    NSLog(@"%f %f",x1,x2);
    NSLog(@"%f %f",y1,y2);
    NSLog(@"%f %f",z1,z2);
    
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
    //euclideanDist sqrt(3.0)
    //XYZeuclid 5.650675
    
    int temp = ceil( 100 * (5.650675 - dist) / 5.650675);
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
