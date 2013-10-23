//
//  RBTimer.m
//  Pholors
//
//  Created by Rafael Padilha on 23/10/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "RBTimer.h"

@implementation RBTimer
- (RBTimer*)initWithTimer:(int)time andDelegate:(id<RBTimerProtocol>)delegate{
    self.timerDelegate = delegate;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:time target:self.timerDelegate selector:@selector(onTick:) userInfo:nil repeats:YES];
    return self;
}

@end
