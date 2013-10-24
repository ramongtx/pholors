//
//  RBCustomSegue.h
//  Pholors
//
//  Created by Rafael Padilha on 23/10/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBCustomSegue : UIStoryboardSegue

@property (strong,nonatomic) UIViewController* dstView;
@property (strong,nonatomic) UIViewController* returnView;
@property (strong,nonatomic) CATransition* transition;

@end
