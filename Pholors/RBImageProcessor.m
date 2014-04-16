//
//  GameLogic.m
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//
#import "RBImageProcessor.h"
#import "UIColor+Named.h"

@interface RBImageProcessor ()
@end

@implementation RBImageProcessor

// Structs for each color space //
struct pixel {
    unsigned char r, g, b, a;
};

typedef struct _LABPixel {
    double x, y, z, ll, aa, bb;
} LABPixel;

typedef struct _LMSPixel {
    double l, m, s;
} LMSPixel;

typedef struct _YUVPixel {
    double y, u, v;
} YUVPixel;

#pragma mark - Common Methods
+ (UIColor*)getDominantColor:(UIImage*)image
{
    NSUInteger red = 0;
    NSUInteger green = 0;
    NSUInteger blue = 0;

    // Allocate a buffer big enough to hold all the pixels

    struct pixel* pixels = (struct pixel*)calloc(1, image.size.width * image.size.height * sizeof(struct pixel));
    if (pixels != nil) {
        CGContextRef context = CGBitmapContextCreate(
            (void*)pixels,
            image.size.width,
            image.size.height,
            8,
            image.size.width * 4,
            CGImageGetColorSpace(image.CGImage),
            (CGBitmapInfo)kCGImageAlphaPremultipliedLast);

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

            if (numberOfPixels == 0)
                numberOfPixels++;
            red /= numberOfPixels;
            green /= numberOfPixels;
            blue /= numberOfPixels;

            CGContextRelease(context);
        }

        free(pixels);
    }
    return [UIColor colorWithRed:red / 255.0f
                           green:green / 255.0f
                            blue:blue / 255.0f
                           alpha:1.0f];
}

+ (UIColor*)randomColor
{
    NSArray* colors = [UIColor getColorsData];
    NSDictionary* color = [colors objectAtIndex:arc4random() % [colors count]];
    UIColor* c = [UIColor colorWithRed:[[color objectForKey:@"r"] integerValue] / 255.0
                                 green:[[color objectForKey:@"g"] integerValue] / 255.0
                                  blue:[[color objectForKey:@"b"] integerValue] / 255.0
                                 alpha:1.0];
    return c;
}

+ (UIColor*)colorFromHexString:(NSString*)hexString
{
    unsigned rgbValue = 0;
    NSScanner* scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    float red = ((rgbValue & 0xFF0000) >> 16) / 255.0;
    float green = ((rgbValue & 0xFF00) >> 8) / 255.0;
    float blue = (rgbValue & 0xFF) / 255.0;
    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:1.0];
}

#pragma mark - Convertion methods
+ (int)convertPointstoStars:(int)points
{
    if (points < 50)
        return 0;
    if (points < 65)
        return 1;
    if (points < 85)
        return 2;
    return 3;
}

+ (int)convertDistanceToPoints:(float)dist
{
    return round(dist * 100);
}

+ (int)convertLABDistanceToPoints:(float)dist
{
    int n = round(dist);
    n = n - 10;
    n = 100 - n;
    if (n > 100)
        n = 100;
    else if (n < 0)
        n = 0;
    return n;
}

+ (int)convertLMSDistanceToPoints:(float)dist
{
    float points = 101.98744 - (83.00231115 * dist);
    NSLog(@"Points: %f   --  Dist: %f", points, dist);
    return round(points);
}
+ (int)convertWeightedDistanceToPoints:(float)dist
{
    NSLog(@"%f", round(dist));
    return round(dist);
}

#pragma mark - Distance Methods
+ (float)cossineSimilarityFrom:(UIColor*)color1 to:(UIColor*)color2
{
    const CGFloat* componentsColor1 = CGColorGetComponents([color1 CGColor]);
    const CGFloat* componentsColor2 = CGColorGetComponents([color2 CGColor]);

    float cossine, norm1, norm2;

    cossine = (componentsColor1[0] * componentsColor2[0]) + (componentsColor1[1] * componentsColor2[1]) + (componentsColor1[2] * componentsColor2[2]);
    norm1 = sqrt(pow(componentsColor1[0], 2) + pow(componentsColor1[1], 2) + pow(componentsColor1[2], 2));
    norm2 = sqrt(pow(componentsColor2[0], 2) + pow(componentsColor2[1], 2) + pow(componentsColor2[2], 2));

    cossine = cossine / (norm1 * norm2);
    NSLog(@"CS: %f", cossine);
    return cossine;
}

+ (float)weightedDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2
{
    const CGFloat* componentsColor1 = CGColorGetComponents([c1 CGColor]);
    const CGFloat* componentsColor2 = CGColorGetComponents([c2 CGColor]);
    CGFloat rr = componentsColor1[0] - componentsColor2[0];
    CGFloat gg = componentsColor1[1] - componentsColor2[1];
    CGFloat bb = componentsColor1[2] - componentsColor2[2];
    float colorDiff = (30 * (rr)) * (30 * (rr)) + (59 * (gg)) * (59 * (gg)) + (11 * (bb)) * (11 * (bb));
    return colorDiff;
}

+ (double)LABDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2
{
    const CGFloat* componentsColor1 = CGColorGetComponents([c1 CGColor]);
    const CGFloat* componentsColor2 = CGColorGetComponents([c2 CGColor]);
    LABPixel p1 = [RBImageProcessor getLABPixelWithR:componentsColor1[0]
                                                   G:componentsColor1[1]
                                                   B:componentsColor1[2]];
    LABPixel p2 = [RBImageProcessor getLABPixelWithR:componentsColor2[0]
                                                   G:componentsColor2[1]
                                                   B:componentsColor2[2]];
    return [RBImageProcessor distanceFromLAB:p1
                                          to:p2];
}

+ (double)YUVDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2
{
    const CGFloat* componentsColor1 = CGColorGetComponents([c1 CGColor]);
    const CGFloat* componentsColor2 = CGColorGetComponents([c2 CGColor]);
    YUVPixel p1 = [RBImageProcessor getYUVPixelWithR:componentsColor1[0]
                                                   G:componentsColor1[1]
                                                   B:componentsColor1[2]];
    YUVPixel p2 = [RBImageProcessor getYUVPixelWithR:componentsColor2[0]
                                                   G:componentsColor2[1]
                                                   B:componentsColor2[2]];
    return [RBImageProcessor distanceFromYUV:p1
                                          to:p2];
}

+ (double)LMSDistanceFromColor:(UIColor*)c1 to:(UIColor*)c2
{
    const CGFloat* componentsColor1 = CGColorGetComponents([c1 CGColor]);
    const CGFloat* componentsColor2 = CGColorGetComponents([c2 CGColor]);
    LMSPixel p1 = [RBImageProcessor getLMSPixelWithR:componentsColor1[0]
                                                   G:componentsColor1[1]
                                                   B:componentsColor1[2]];
    LMSPixel p2 = [RBImageProcessor getLMSPixelWithR:componentsColor2[0]
                                                   G:componentsColor2[1]
                                                   B:componentsColor2[2]];
    return [RBImageProcessor distanceFromLMS:p1
                                          to:p2];
}

#pragma mark - Neural Network Methods
+ (void)writeToLearningLog:(UIColor* const)color1 To:(UIColor* const)color2 Stars:(double const)stars
{
    [RBImageProcessor writeStringToFile:[RBImageProcessor configurationToLMSStringFrom:color1
                                                                                    To:color2
                                                                                 Stars:stars]];
}

+ (void)writeStringToFile:(NSString*)aString
{
    // Build the path, and create if needed.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"learningLog.txt"];

    // create if needed
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSData data] writeToFile:path
                        atomically:YES];
    }

    // append
    NSFileHandle* handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[aString dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString*)colorToLMSString:(UIColor* const)color
{
    const CGFloat* componentsColor = CGColorGetComponents([color CGColor]);
    LMSPixel lmspix = [RBImageProcessor getLMSPixelWithR:componentsColor[0]
                                                       G:componentsColor[1]
                                                       B:componentsColor[2]];
    return [NSString stringWithFormat:@"%f;%f;%f", lmspix.l, lmspix.m, lmspix.s];
}

+ (NSString*)configurationToLMSStringFrom:(UIColor* const)color1 To:(UIColor* const)color2 Stars:(double const)stars
{
    float YUVdist, LABdist, LMSdist;
    YUVdist = [RBImageProcessor YUVDistanceFromColor:color1
                                                  to:color2];
    LABdist = [RBImageProcessor LABDistanceFromColor:color1
                                                  to:color2];
    LMSdist = [RBImageProcessor LMSDistanceFromColor:color1
                                                  to:color2];

    return [NSString stringWithFormat:@"%f;%f;%f;%f\n", YUVdist, LABdist, LMSdist, stars];
}

+ (int)classifyColor:(UIColor*)color againstColor:(UIColor*)targetColor
{
    double YUVdist = [RBImageProcessor YUVDistanceFromColor:color
                                                         to:targetColor];
    double LABdist = [RBImageProcessor LABDistanceFromColor:color
                                                         to:targetColor];
    double LMSdist = [RBImageProcessor LMSDistanceFromColor:color
                                                         to:targetColor];

    double sample[] = { YUVdist, LABdist, LMSdist };
    NSData* vector = [NSData dataWithBytes:sample
                                    length:sizeof(sample)];
    NSMutableData* prediction = [NSMutableData dataWithLength:4 * sizeof(double)];
    MLPNeuralNet* model = [RBImageProcessor nnetModel];
    [model predictByFeatureVector:vector
             intoPredictionVector:prediction];

    double* assessment = (double*)prediction.bytes;
    double max = 0.7;
    int nStars = -1;
    for (int i = 0; i < 4; i++) {
        if (assessment[i] > max) {
            max = assessment[i];
            nStars = i;
        }
    }
    NSLog(@"Model assessment is %f %f %f %f", assessment[0], assessment[1], assessment[2], assessment[3]);

    if (nStars == -1) {

        int YUVpoints = [RBImageProcessor YUVPointsComparingColor:color
                                                          toColor:targetColor];
        int LMSpoints = [RBImageProcessor LMSPointsComparingColor:color
                                                          toColor:targetColor];
        int LABpoints = [RBImageProcessor LABPointsComparingColor:color
                                                          toColor:targetColor];

        int points = (4 * YUVpoints + LMSpoints + LABpoints) / 6;
        nStars = [RBImageProcessor convertPointstoStars:points];
    }

    NSLog(@"Predicted Stars: %d", nStars);

    return nStars;
}

+ (MLPNeuralNet*)nnetModel
{
    static MLPNeuralNet* model;
    if (!model) {
        NSArray* netConfig = @[
            @3,
            @10,
            @4
        ];

        double wts[] = { -0.556851266936628, 0.293026033063906, -1.91327396436152, 0.259867670032901, -1.14562295818072, -10.422618236855, 0.0128345757523192, -3.75838135527207, -1.23079396469577, 1.30639940141542, -0.0164800899501483, 2.30873307824372, 54.9883038996933, -33.5004575070779, -6.68399115785366, -42.70386386685, 171.731599687175, -108.34573501997, -13.8038005505922, 58.852077231897, 4.54073883623663, -0.669212629601041, -15.7836120577111, 1.4625876001529, 0.612555865125939, 0.00244473868104622, -5.7967833201832, -0.357873440978774, 3.55730781062721, 0.66012275429115, 11.0073503305504, 1.54883987864954, -1.99091340551813, 0.839233201985869, -0.00613111424495405, 1.00724727638257, 12.1067630152521, -2.99427787388351, -11.3606468757449, -4.91320922529409, -1.63832606553512, -0.31675833734765, -181.582078018914, -20.8280226960934, -0.600372065848513, -66.5471477230564, -7.68096312157854, 0.647630991797671, -0.569790871196227, 57.7726219249286, 0.219351863825619, 0.56931883527014, -0.251591790926775, -19.9011727947049, 17.9231444773759, -0.339773879948471, -124.576118465526, -7.73670403697874, -0.191816386912276, 0.115183175565659, -45.9820656016295, -0.17727340912905, 7.09557919346396, -1.22916387345775, -41.0028981857338, 58.6539570047551, -25.513262311586, -0.393082203027824, -40.5075082367272, -5.94799634746729, 11.4376188576082, -233.478948337612, -19.925000522642, 8.08484513224204, -0.633164834112271, 18.8266871229323, 18.878829358578, 18.8361965439383, 1.47111676676709, -5.68483308255879, 3.7466184030173, 2.61484145498449, -126.409761521396, 13.6569154815589 };
        NSData* weights = [NSData dataWithBytes:wts
                                         length:sizeof(wts)];

        model = [[MLPNeuralNet alloc] initWithLayerConfig:netConfig
                                                  weights:weights
                                               outputMode:MLPClassification];
    }

    return model;
}

#pragma mark - Private Methods
#pragma mark - YUV
+ (double)distanceFromYUV:(YUVPixel)p1 to:(YUVPixel)p2
{
    double res = 0;
    res = 4 * (p2.y - p1.y) * (p2.y - p1.y) + (p2.u - p1.u) * (p2.u - p1.u) + (p2.v - p1.v) * (p2.v - p1.v);
    res = sqrt(res / 6);
    return res;
}

+ (int)YUVPointsComparingColor:(UIColor*)color toColor:(UIColor*)targetColor
{
    double dist = [RBImageProcessor YUVDistanceFromColor:color
                                                      to:targetColor];
    return 100 * (1 - dist);
}

+ (YUVPixel)getYUVPixelWithR:(float)r G:(float)g B:(float)b
{
    YUVPixel p;

    p.y = (0.299 * r + 0.587 * g + 0.114 * b) / 1; //(0.299 + 0.587 + 0.114);
    p.u = (-0.14713 * r + -0.28886 * g + 0.436 * b) / 1; //(-0.14713 + -0.28886 + 0.436);
    p.v = (0.615 * r + -0.51499 * g + -0.10001 * b) / 1; //(0.615 + -0.51499 + -0.10001);

    return p;
}

#pragma mark - LMS

+ (int)LMSPointsComparingColor:(UIColor*)color toColor:(UIColor*)targetColor
{
    double dist = [RBImageProcessor LMSDistanceFromColor:color
                                                      to:targetColor];

    //return 100 * (1 - dist);
    return [RBImageProcessor convertLMSDistanceToPoints:dist];
}

+ (float)LMScossineSimilarityFrom:(LMSPixel)p1 to:(LMSPixel)p2
{
    float cossine, norm1, norm2;

    cossine = (p1.l * p2.l) + (p1.m * p2.m) + (p1.s * p2.s);
    norm1 = sqrt(pow(p1.l, 2) + pow(p1.m, 2) + pow(p1.s, 2));
    norm2 = sqrt(pow(p2.l, 2) + pow(p2.m, 2) + pow(p2.s, 2));

    cossine = cossine / (norm1 * norm2);
    //NSLog(@"CS: %f",cossine);
    return cossine;
}

+ (LMSPixel)getLMSPixelWithR:(float)r G:(float)g B:(float)b
{
    LMSPixel p;

    p.l = (17.8824 * r + 43.5161 * g + 4.1193 * b) / (17.8824 + 43.5161 + 4.1193);
    p.m = (3.4557 * r + 27.1554 * g + 3.8671 * b) / (3.4557 + 27.1554 + 3.8671);
    p.s = (0.02996 * r + 0.18431 * g + 1.4670 * b) / (0.02996 + 0.18431 + 1.4670);

    return p;
}

+ (double)distanceFromLMS:(LMSPixel)p1 to:(LMSPixel)p2
{
    double res = 0;
    res = (p2.l - p1.l) * (p2.l - p1.l) + (p2.m - p1.m) * (p2.m - p1.m) + (p2.s - p1.s) * (p2.s - p1.s);
    res = sqrt(res);
    return res;
}

#pragma mark - LAB

+ (int)LABPointsComparingColor:(UIColor*)color toColor:(UIColor*)targetColor
{
    double dist = [RBImageProcessor LABDistanceFromColor:color
                                                      to:targetColor];
    return [RBImageProcessor convertLABDistanceToPoints:dist];
}

+ (float)LABcossineSimilarityFrom:(LABPixel)p1 to:(LABPixel)p2
{
    float cossine, norm1, norm2;

    cossine = (p1.ll * p2.ll) + (p1.aa * p2.aa) + (p1.bb * p2.bb);
    norm1 = sqrt(pow(p1.ll, 2) + pow(p1.aa, 2) + pow(p1.bb, 2));
    norm2 = sqrt(pow(p2.ll, 2) + pow(p2.aa, 2) + pow(p2.bb, 2));

    cossine = cossine / (norm1 * norm2);
    //NSLog(@"CS: %f",cossine);
    return cossine;
}

+ (LABPixel)getLABPixelWithR:(float)r G:(float)g B:(float)b
{
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

+ (double)distanceFromLAB:(LABPixel)p1 to:(LABPixel)p2
{
    double res = 0;
    res = (p2.ll - p1.ll) * (p2.ll - p1.ll) + (p2.aa - p1.aa) * (p2.aa - p1.aa) + (p2.bb - p1.bb) * (p2.bb - p1.bb);
    res = sqrt(res);
    return res;
}

#pragma mark - Other Private Methods
+ (double)fFunction:(double)t
{
    if (t > pow((6.0 / 29.0), 3))
        return pow(t, (1.0 / 3.0));
    else
        return (t / 3.0) * (29.0 / 6.0) * (29.0 / 6.0) + (4.0 / 29.0);
}

@end
