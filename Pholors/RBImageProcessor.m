//
//  GameLogic.m
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "RBImageProcessor.h"
#import "UIColor+Named.h"

@implementation RBImageProcessor


struct pixel {
    unsigned char r, g, b, a;
};

typedef struct _LABPixel {
    double x,y,z,ll,aa,bb;
} LABPixel;

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
            
            if(numberOfPixels == 0) numberOfPixels++;
            red /= numberOfPixels;
            green /= numberOfPixels;
            blue/= numberOfPixels;
            
            
            CGContextRelease(context);
        }
        
        free(pixels);
    }
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}

+ (UIColor*) randomColor
{
    NSArray* colors = [UIColor getColorsData];
    NSDictionary* color = [colors objectAtIndex:arc4random() % [colors count]];
    UIColor *c = [UIColor colorWithRed:[[color objectForKey:@"r"] integerValue]/255.0
                                     green:[[color objectForKey:@"g"] integerValue]/255.0
                                      blue:[[color objectForKey:@"b"] integerValue]/255.0 alpha:1.0];
    return c;
}

+ (int) convertDistanceToPoints:(float)dist{
    return round(dist * 100);
}

+ (int) convertPointstoStars:(int)points{
    if(points < 45) return 0;
    if(points < 60) return 1;
    if(points < 80) return 2;
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

#pragma mark - Weighted RGB Distance

+ (float) weightedDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2
{
    const CGFloat* componentsColor1 = CGColorGetComponents([c1 CGColor]);
    const CGFloat* componentsColor2 = CGColorGetComponents([c2 CGColor]);
    CGFloat rr = componentsColor1[0]-componentsColor2[0];
        CGFloat gg = componentsColor1[1]-componentsColor2[1];
        CGFloat bb = componentsColor1[2]-componentsColor2[2];
    float colorDiff = (30*(rr))*(30*(rr)) + (59*(gg))*(59*(gg)) + (11*(bb))*(11*(bb));
    return colorDiff;

}

+ (int) convertWeightedDistanceToPoints:(float)dist
{
    return round(dist);
}

#pragma mark - Cossine Distance

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

#pragma mark - LAB Distance

+(double) labDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2
{
    const CGFloat* componentsColor1 = CGColorGetComponents([c1 CGColor]);
    const CGFloat* componentsColor2 = CGColorGetComponents([c2 CGColor]);
    LABPixel p1 = [RBImageProcessor getLABPixelWithR:componentsColor1[0] G:componentsColor1[1] B:componentsColor1[2]];
    LABPixel p2 = [RBImageProcessor getLABPixelWithR:componentsColor2[0] G:componentsColor2[1] B:componentsColor2[2]];
    return [RBImageProcessor distanceFromLAB:p1 to:p2];
}

+(LABPixel) getLABPixelWithR:(float)r G:(float)g B:(float)b
{
    LABPixel p;
    
    p.x = 0.4755678*r + 0.3396722*g + 0.1489800*b;
    p.y = 0.2551812*r + 0.6725693*g + 0.0722496*b;
    p.z = 0.0184697*r + 0.1133771*g + 0.6933632*b;
    p.x = p.x/(0.4755678 + 0.3396722 + 0.1489800);
    p.y = p.y/(0.2551812 + 0.6725693 + 0.0722496);
    p.z = p.z/(0.0184697 + 0.1133771 + 0.6933632);
    
    double fx = [RBImageProcessor fFunction:p.x];
    double fy = [RBImageProcessor fFunction:p.y];
    double fz = [RBImageProcessor fFunction:p.z];
    
    p.ll = 116*fy-16;
    p.aa = 500*(fx-fy);
    p.bb = 200*(fy-fz);
    return p;
}

+(double)fFunction:(double)t
{
    if (t>pow((6.0/29.0),3)) return pow(t,(1.0/3.0));
    else return (t/3.0)*(29.0/6.0)*(29.0/6.0)+(4.0/29.0);
}

+(double) distanceFromLAB:(LABPixel)p1 to:(LABPixel)p2
{
    double res = 0;
    res = (p2.ll-p1.ll)*(p2.ll-p1.ll)+(p2.aa-p1.aa)*(p2.aa-p1.aa)+(p2.bb-p1.bb)*(p2.bb-p1.bb);
    res = sqrt(res);
    return res;
}

+ (int) convertLABDistanceToPoints:(float)dist
{
    int n = round(dist);
    n = n-10;
    n = 100-n;
    if (n > 100) n = 100;
    else if (n < 0) n = 0;
    return n;
}


@end
