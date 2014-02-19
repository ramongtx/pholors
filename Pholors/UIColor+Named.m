//
//  UIColor+Named.m
//  RGBSliders
//
//  Created by Gabriel Ribeiro on 05/12/13.
//  Copyright (c) 2013 Gabriel Ribeiro. All rights reserved.
//

#import "UIColor+Named.h"
#import <math.h>

@implementation UIColor (Named)

+ (NSArray *)getColorsData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Colors" ofType:@"json"];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSError *requestError = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&requestError];
    
    NSError *jsonParsingError = nil;
    NSArray *data = [NSJSONSerialization JSONObjectWithData:response
                                                    options:0 error:&jsonParsingError];
    
    return data;
}

+ (UIColor *) colorFromName:(NSString*)colorName
{
    NSArray *colors = [self getColorsData];
    NSDictionary* color;
    for(int i=0; i< [colors count]; i++){
        color = [colors objectAtIndex:i];
        if([[color objectForKey:@"label"] isEqualToString:colorName]){
            return [UIColor colorWithRed:[[color objectForKey:@"r"] floatValue]/255.0
                             green:[[color objectForKey:@"g"] floatValue]/255.0
                             blue:[[color objectForKey:@"b"] floatValue]/255.0
                             alpha:1.0];
        }
    }
    return nil;

}

+ (NSString *)colorNameFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    red = red * 255 / 1;
    green = green * 255 / 1;
    blue = blue * 255 / 1;
    
    NSArray *colors = [self getColorsData];
    
    int min = (int) NSIntegerMax;
    int min_idx = -1;
    int dist, last_result;
    
    NSDictionary *color;
    
    for (int i = 0; i < colors.count; i++) {
        color = [colors objectAtIndex:i];
        //NSLog(@"R: %@ G: %@ B: %@", [color objectForKey:@"r"], [color objectForKey:@"g"], [color objectForKey:@"b"]);
        
        NSNumber *numberOfR = [color objectForKey:@"r"];
        NSNumber *numberOfG = [color objectForKey:@"g"];
        NSNumber *numberOfB = [color objectForKey:@"b"];
        
        CGFloat r = numberOfR.floatValue;
        CGFloat g = numberOfG.floatValue;
        CGFloat b = numberOfB.floatValue;
        
        CGFloat x = abs(red - r);
        CGFloat y = abs(green - g);
        CGFloat z = abs(blue - b);
        
        dist = sqrt(x * x + y * y + z * z);
        
        if (dist < min)
        {
            min = dist;
            min_idx = i;
        }
    }
    
    last_result = min_idx;
    
    NSDictionary *trueColor = [colors objectAtIndex:last_result];
    
    return [trueColor objectForKey:@"label"];
}

@end
