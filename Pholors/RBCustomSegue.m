//
//  RBCustomSegue.m
//  Pholors
//
//  Created by Rafael Padilha on 23/10/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "RBCustomSegue.h"
#import "ViewController.h"
#import "GameOverViewController.h"

@implementation RBCustomSegue

- (void) perform {
    ViewController *src = (ViewController *) self.sourceViewController;
    GameOverViewController *dst = (GameOverViewController *) self.destinationViewController;
    [UIView transitionWithView:src.navigationController.view duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}

@end
