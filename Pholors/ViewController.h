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

@interface ViewController : GalleryViewController <GalleryViewProtocol,RBTimerProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UIImageView *color;
@property (weak, nonatomic) IBOutlet UIImageView *targetPreview;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (strong, nonatomic) RBTimer* timerController;
@property (strong,nonatomic) RBLevel* level;

- (IBAction)resetTimer:(id)sender;

@property int time;
@end
