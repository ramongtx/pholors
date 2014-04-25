//
//  RBCustomSegue.m
//  Pholors
//
//  Created by Felix Dumit on 4/25/14.
//  Copyright (c) 2014 Rock Bottom. All rights reserved.
//

#import "RBCustomSegue.h"

@implementation RBCustomSegue

- (void)perform
{
    
    UIViewController* sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController* destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition* transition = [CATransition animation];
    transition.duration = .25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController
                                                         animated:NO];
}
@end
