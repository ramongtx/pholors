//
//  ViewController.h
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

//GameVC is the ViewController of the gamescreen for both Challenge and
//TimeAttack mode, so it contains methods for both game modes

#import <UIKit/UIKit.h>
#import "CameraVC.h"
#import "RBImageProcessor.h"
#import "RBGame.h"
#import "RBTimer.h"
#import "EndGameVC.h"
#import "RBSharedFunctions.h"
#define STARS YES

@interface GameVC : CameraVC <GalleryViewProtocol, RBTimerProtocol>

@property(weak, nonatomic) IBOutlet UIImageView* imagePreview;
@property(weak, nonatomic) IBOutlet UIImageView* color;
@property(weak, nonatomic) IBOutlet UIImageView* targetPreview;
@property(weak, nonatomic) IBOutlet UIImageView* stars;

@property(weak, nonatomic) IBOutlet UILabel* colorNameLabel;
@property(weak, nonatomic) IBOutlet UILabel* timerLabel;
@property(weak, nonatomic) IBOutlet UILabel* averageLabel;

@property(weak, nonatomic) IBOutlet UIBarButtonItem* stopButton;

@property(strong, nonatomic) IBOutlet UIBarButtonItem* nextButton;

@property(strong, nonatomic) RBTimer* timerController;
@property(strong, nonatomic) RBLevel* level;
@property BOOL highscore;

@property(nonatomic) NSInteger time, timelock, totalPoints;

@end
