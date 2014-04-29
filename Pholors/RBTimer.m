//
//  RBTimer.m
//  Pholors
//
//  Created by Rafael Padilha on 23/10/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "RBTimer.h"

@implementation RBTimer {
    int myTime;
    bool isStopped;
}
- (RBTimer*)initWithTimer:(int)time andDelegate:(id<RBTimerProtocol>)delegate
{
    myTime = time;
    self.timerDelegate = delegate;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:myTime
                                                  target:self.timerDelegate
                                                selector:@selector(onTick)
                                                userInfo:nil
                                                 repeats:YES];
    
    isStopped = NO;
    return self;
}

- (void)start
{
    if (isStopped) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:myTime
                                                      target:self.timerDelegate
                                                    selector:@selector(onTick)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)stop
{
    [self.timer invalidate];
    isStopped = YES;
}

@end
