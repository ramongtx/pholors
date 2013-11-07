//
//  RBLevel.h
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBImageProcessor.h"

@interface RBLevel : NSObject <NSCoding>

@property(nonatomic) int pointsScored;
@property(strong, nonatomic) UIColor * color;
@property(strong, nonatomic) UIColor * colorPlayed;
@property(strong, nonatomic) NSString* colorName;
@property(nonatomic)BOOL completed;
@property(nonatomic) BOOL isTimeAttack;

-(id) init;
-(id) initWithColor:(NSString*)colorHex name:(NSString*)name;
-(int) stars;

-(void) changeColor;
-(int) playImageOnLevel:(UIImage*)img;


@end
