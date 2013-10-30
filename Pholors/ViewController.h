//
//  ViewController.h
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryViewController.h"
#import "RBImage.h"
#import "RBGame.h"
#import "RBTimer.h"
#import "RBCustomSegue.h"
#import "GameOverViewController.h"
#define STARS YES

@interface ViewController : GalleryViewController <GalleryViewProtocol,RBTimerProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UIImageView *color;
@property (weak, nonatomic) IBOutlet UIImageView *targetPreview;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stars;

@property (strong, nonatomic) RBTimer* timerController;
@property (strong,nonatomic) RBLevel* level;

@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;
@property int time;
@end
