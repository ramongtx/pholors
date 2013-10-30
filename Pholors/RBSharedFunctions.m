//
//  RBSharedFunctions.m
//  Pholors
//
//  Created by Felix Dumit on 10/30/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "RBSharedFunctions.h"

@implementation RBSharedFunctions

+(void) playSound:(NSString*)soundName withExtension:(NSString*) extension
{
    SystemSoundID sound1;
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:soundName
                                              withExtension:extension];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound1);
    AudioServicesPlaySystemSound(sound1);
}

@end
