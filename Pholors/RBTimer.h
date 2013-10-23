//
//  RBTimer.h
//  Pholors
//
//  Created by Rafael Padilha on 23/10/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RBTimerProtocol <NSObject>
@required
-(void) onTick;
@end

@interface RBTimer : NSObject
@property (strong,nonatomic) id <RBTimerProtocol> timerDelegate;
@property (strong,nonatomic) NSTimer* timer;
- (RBTimer*)initWithTimer:(int)time andDelegate:(id<RBTimerProtocol>)delegate;
@end
