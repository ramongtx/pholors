//
//  MainViewController.h
//  Pholors
//
//  Created by Ramon Carvalho Maciel on 10/28/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

// Represents the Main/Menu View

#import <UIKit/UIKit.h>
#import "GameVC.h"
#import "RBSharedFunctions.h"

@interface MainVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *starsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
