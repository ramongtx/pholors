//
//  RBSharedFunctions.h
//  Pholors
//
//  Created by Felix Dumit on 10/30/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface RBSharedFunctions : NSObject

+(void) playSound:(NSString*)soundName withExtension:(NSString*) extension;

@end
