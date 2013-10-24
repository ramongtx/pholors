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
    UIViewController *src = (UIViewController *) self.sourceViewController;
    [src presentViewController:[self destinationViewController] animated:YES completion:nil];
}

@end
