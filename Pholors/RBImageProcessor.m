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
	double x, y, z, ll, aa, bb;
} LABPixel;

typedef struct _LMSPixel {
	double l, m, s;
} LMSPixel;

+ (UIColor *)getDominantColor:(UIImage *)image {
	NSUInteger red = 0;
	NSUInteger green = 0;
	NSUInteger blue = 0;


	// Allocate a buffer big enough to hold all the pixels

	struct pixel *pixels = (struct pixel *)calloc(1, image.size.width * image.size.height * sizeof(struct pixel));
	if (pixels != nil) {
		CGContextRef context = CGBitmapContextCreate(
		        (void *)pixels,
		        image.size.width,
		        image.size.height,
		        8,
		        image.size.width * 4,
		        CGImageGetColorSpace(image.CGImage),
		        (CGBitmapInfo)kCGImageAlphaPremultipliedLast
		        );

		if (context != NULL) {
			// Draw the image in the bitmap

			CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), image.CGImage);

			// Now that we have the image drawn in our own buffer, we can loop over the pixels to
			// process it. This simple case simply counts all pixels that have a pure red component.

			// There are probably more efficient and interesting ways to do this. But the important
			// part is that the pixels buffer can be read directly.

			NSUInteger numberOfPixels = image.size.width * image.size.height;
			for (int i = 0; i < numberOfPixels; i++) {
				red += pixels[i].r; //* pixels[i].a;
				green += pixels[i].g; // * pixels[i].a;
				blue += pixels[i].b; // * pixels[i].a;
			}

			if (numberOfPixels == 0) numberOfPixels++;
			red /= numberOfPixels;
			green /= numberOfPixels;
			blue /= numberOfPixels;


			CGContextRelease(context);
		}

		free(pixels);
	}
	return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1.0f];
}

+ (UIColor *)randomColor {
	NSArray *colors = [UIColor getColorsData];
	NSDictionary *color = [colors objectAtIndex:arc4random() % [colors count]];
	UIColor *c = [UIColor colorWithRed:[[color objectForKey:@"r"] integerValue] / 255.0
	                             green:[[color objectForKey:@"g"] integerValue] / 255.0
	                              blue:[[color objectForKey:@"b"] integerValue] / 255.0 alpha:1.0];
	return c;
}

+ (int)convertDistanceToPoints:(float)dist {
	return round(dist * 100);
}

+ (int)convertPointstoStars:(int)points {
	if (points < 45) return 0;
	if (points < 55) return 1;
	if (points < 80) return 2;
	return 3;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
	unsigned rgbValue = 0;
	NSScanner *scanner = [NSScanner scannerWithString:hexString];
	[scanner setScanLocation:1]; // bypass '#' character
	[scanner scanHexInt:&rgbValue];
	float red = ((rgbValue & 0xFF0000) >> 16) / 255.0;
	float green = ((rgbValue & 0xFF00) >> 8) / 255.0;
	float blue = (rgbValue & 0xFF) / 255.0;
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

#pragma mark - Weighted RGB Distance

+ (float)weightedDistanceFromColor:(UIColor *)c1 to:(UIColor *)c2 {
	const CGFloat *componentsColor1 = CGColorGetComponents([c1 CGColor]);
	const CGFloat *componentsColor2 = CGColorGetComponents([c2 CGColor]);
	CGFloat rr = componentsColor1[0] - componentsColor2[0];
	CGFloat gg = componentsColor1[1] - componentsColor2[1];
	CGFloat bb = componentsColor1[2] - componentsColor2[2];
	float colorDiff = (30 * (rr)) * (30 * (rr)) + (59 * (gg)) * (59 * (gg)) + (11 * (bb)) * (11 * (bb));
	return colorDiff;
}

+ (int)convertWeightedDistanceToPoints:(float)dist {
	NSLog(@"%d", round(dist));
	return round(dist);
}

#pragma mark - Cossine Distance

+ (float)cossineSimilarityFrom:(UIColor *)color1 to:(UIColor *)color2 {
	const CGFloat *componentsColor1 = CGColorGetComponents([color1 CGColor]);
	const CGFloat *componentsColor2 = CGColorGetComponents([color2 CGColor]);

	float cossine, norm1, norm2;

	cossine = (componentsColor1[0] * componentsColor2[0]) + (componentsColor1[1] * componentsColor2[1]) + (componentsColor1[2] * componentsColor2[2]);
	norm1 = sqrt(pow(componentsColor1[0], 2) + pow(componentsColor1[1], 2) + pow(componentsColor1[2], 2));
	norm2 = sqrt(pow(componentsColor2[0], 2) + pow(componentsColor2[1], 2) + pow(componentsColor2[2], 2));

	cossine = cossine / (norm1 * norm2);
	NSLog(@"CS: %f", cossine);
	return cossine;
}

#pragma mark - LAB Distance

+ (double)labDistanceFromColor:(UIColor *)c1 to:(UIColor *)c2 {
	const CGFloat *componentsColor1 = CGColorGetComponents([c1 CGColor]);
	const CGFloat *componentsColor2 = CGColorGetComponents([c2 CGColor]);
	LABPixel p1 = [RBImageProcessor getLABPixelWithR:componentsColor1[0] G:componentsColor1[1] B:componentsColor1[2]];
	LABPixel p2 = [RBImageProcessor getLABPixelWithR:componentsColor2[0] G:componentsColor2[1] B:componentsColor2[2]];
	return [RBImageProcessor distanceFromLAB:p1 to:p2];
}

+ (LABPixel)getLABPixelWithR:(float)r G:(float)g B:(float)b {
	LABPixel p;

	p.x = 0.4755678 * r + 0.3396722 * g + 0.1489800 * b;
	p.y = 0.2551812 * r + 0.6725693 * g + 0.0722496 * b;
	p.z = 0.0184697 * r + 0.1133771 * g + 0.6933632 * b;
	p.x = p.x / (0.4755678 + 0.3396722 + 0.1489800);
	p.y = p.y / (0.2551812 + 0.6725693 + 0.0722496);
	p.z = p.z / (0.0184697 + 0.1133771 + 0.6933632);

	double fx = [RBImageProcessor fFunction:p.x];
	double fy = [RBImageProcessor fFunction:p.y];
	double fz = [RBImageProcessor fFunction:p.z];

	p.ll = 116 * fy - 16;
	p.aa = 500 * (fx - fy);
	p.bb = 200 * (fy - fz);
	return p;
}

+ (double)fFunction:(double)t {
	if (t > pow((6.0 / 29.0), 3)) return pow(t, (1.0 / 3.0));
	else return (t / 3.0) * (29.0 / 6.0) * (29.0 / 6.0) + (4.0 / 29.0);
}

+ (double)distanceFromLAB:(LABPixel)p1 to:(LABPixel)p2 {
	double res = 0;
	res = (p2.ll - p1.ll) * (p2.ll - p1.ll) + (p2.aa - p1.aa) * (p2.aa - p1.aa) + (p2.bb - p1.bb) * (p2.bb - p1.bb);
	res = sqrt(res);
	return res;
}

+ (int)convertLABDistanceToPoints:(float)dist {
	int n = round(dist);
	n = n - 10;
	n = 100 - n;
	if (n > 100) n = 100;
	else if (n < 0) n = 0;
	return n;
}

#pragma mark - LMS
+ (LMSPixel)getLMSPixelWithR:(float)r G:(float)g B:(float)b {
	LMSPixel p;

	p.l = (17.8824 * r + 43.5161 * g + 4.1193 * b) / (17.8824 + 43.5161 + 4.1193);
	p.m = (3.4557 * r + 27.1554 * g + 3.8671 * b) / (3.4557 + 27.1554 + 3.8671);
	p.s = (0.02996 * r + 0.18431 * g + 1.4670 * b) / (0.02996 + 0.18431 + 1.4670);

	return p;
}

+ (double)distanceFromLMS:(LMSPixel)p1 to:(LMSPixel)p2 {
	double res = 0;
	res = (p2.l - p1.l) * (p2.l - p1.l) + (p2.m - p1.m) * (p2.m - p1.m) + (p2.s - p1.s) * (p2.s - p1.s);
	res = sqrt(res);
	return res;
}

+ (double)LMSDistanceFromColor:(UIColor *)c1 to:(UIColor *)c2 {
	const CGFloat *componentsColor1 = CGColorGetComponents([c1 CGColor]);
	const CGFloat *componentsColor2 = CGColorGetComponents([c2 CGColor]);
	LMSPixel p1 = [RBImageProcessor getLMSPixelWithR:componentsColor1[0] G:componentsColor1[1] B:componentsColor1[2]];
	LMSPixel p2 = [RBImageProcessor getLMSPixelWithR:componentsColor2[0] G:componentsColor2[1] B:componentsColor2[2]];
	return [RBImageProcessor distanceFromLMS:p1 to:p2];
}

+ (float)LMScossineSimilarityFrom:(LMSPixel)p1 to:(LMSPixel)p2 {
	float cossine, norm1, norm2;

	cossine = (p1.l * p2.l) + (p1.m * p2.m) + (p1.s * p2.s);
	norm1 = sqrt(pow(p1.l, 2) + pow(p1.m, 2) + pow(p1.s, 2));
	norm2 = sqrt(pow(p2.l, 2) + pow(p2.m, 2) + pow(p2.s, 2));

	cossine = cossine / (norm1 * norm2);
	NSLog(@"CS: %f", cossine);
	return cossine;
}

// TO DO!
+ (int)convertLMSDistanceToPoints:(float)dist {
	float points = 101.98744 - (84.00231115 * dist);
	NSLog(@"Points: %f   --  Dist: %f", points, dist);

	/* Linear Regression formula created by the values bellow

	    10 --- 0.094848
	   9.5 --- 0.145446
	   9.5 --- 0.083935
	   9.5 --- 0.187528
	   9.5 --- 0.27558
	   9 --- 0.312092
	   9 --- 0.260951
	   8.5 --- 0.286962
	   8 --- 0.432276
	   7 --- 0.547384
	   7 --- 0.427549
	   7 --- 0.368862
	   6 --- 0.638282
	   6 --- 0.760043
	   6 --- 0.41599
	   5 --- 0.2684
	   5 --- 0.788321
	   5 --- 0.601
	   3 --- 0.577453
	   2 --- 0.759054
	   2 --- 0.777
	   1 --- 0.618466
	   0 --- 1.474908
	   0 --- 0.774361
	   0 --- 1.273971
	 */
	return round(points);
}

+ (NSString *)colorToLMSString:(UIColor *const)color {
	const CGFloat *componentsColor = CGColorGetComponents([color CGColor]);
	LMSPixel lmspix = [RBImageProcessor getLMSPixelWithR:componentsColor[0] G:componentsColor[1] B:componentsColor[2]];
	return [NSString stringWithFormat:@"%f;%f;%f", lmspix.l, lmspix.m, lmspix.s];
}

+ (NSString *)configurationToLMSStringFrom:(UIColor *const)color1 To:(UIColor *const)color2 Stars:(int const)stars {
	return [NSString stringWithFormat:@"%@;%@;%d\n", [RBImageProcessor colorToLMSString:color1], [RBImageProcessor colorToLMSString:color2], stars];
}

+ (void)writeStringToFile:(NSString *)aString {
	// Build the path, and create if needed.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"learningLog.txt"];

	// create if needed
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		[[NSData data] writeToFile:path atomically:YES];
	}

	// append
	NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
	[handle truncateFileAtOffset:[handle seekToEndOfFile]];
	[handle writeData:[aString dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (void)writeToLearningLog:(UIColor *const)color1 To:(UIColor *const)color2 Stars:(int const)stars {
	[RBImageProcessor writeStringToFile:[RBImageProcessor configurationToLMSStringFrom:color1 To:color2 Stars:stars]];
}

@end
