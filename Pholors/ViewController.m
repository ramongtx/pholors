//
//  ViewController.m
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.color.layer.borderColor = [[UIColor blackColor] CGColor];
    self.color.layer.borderWidth = 2.0;
    self.color.layer.cornerRadius = 25;
    self.color.layer.masksToBounds = YES;
    
    if(self.level.colorPlayed){
        self.color.backgroundColor = self.level.colorPlayed;
        self.averageLabel.text = @"Last Played";
    }
    else
        self.averageLabel.text = @"Average Color";
    
    self.targetPreview.layer.borderColor = [[UIColor blackColor] CGColor];
    self.targetPreview.layer.borderWidth = 2.0;
    self.targetPreview.layer.cornerRadius = 25;
    self.targetPreview.layer.masksToBounds = YES;
    
    self.imagePreview.layer.borderColor = [[UIColor blackColor] CGColor];
    self.imagePreview.layer.borderWidth = 1.5;
    
    self.result.text = @"";
    self.timerLabel.hidden = YES;
    
    self.targetPreview.backgroundColor = self.level.color;
    
    if (self.level.isTimeAttack) {
        self.time = 10;
        self.timerController = [[RBTimer alloc]initWithTimer:1.0 andDelegate:self];
        self.timerLabel.text = [NSString stringWithFormat:@"%d",self.time];
        self.timerLabel.hidden = NO;
    }
    else self.time = -1;
}

- (IBAction)button:(id)sender {
    [self setGalleryDelegate:self];
    [self launchBrowser];
}

-(void) didFinishLoadingImage:(UIImage *)image original:(UIImage*)originalImage
{
    self.imagePreview.image = image;
    //NSLog(@"loadImage: %@ original:%@" , image.description, originalImage.description);
    self.imagePreview.contentMode = UIViewContentModeScaleAspectFit;
    self.imagePreview.clipsToBounds = YES;
    
    int points = [self.level playImageOnLevel:image original:originalImage];

    
    if(points== -1){
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Duplicate Image"
                                                              message:@"You have already used this image"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
    }
    
    //self.level.colorPlayed = [RBImage getDominantColor:image];
    self.color.backgroundColor = self.level.colorPlayed;
    //int p = [self calculatePoints];
    self.result.text = [NSString stringWithFormat:@"Pontuation: %d",points];
    //if (!self.level.isTimeAttack) [self savePoints:p];

}

-(int) calculatePoints
{
    if (self.imagePreview.image == nil) return 0;
    float distance = [RBImage euclideanDistanceFrom:self.color.backgroundColor to:self.targetPreview.backgroundColor];
    return [RBImage convertDistanceToPoints:distance];
}

-(void) savePoints:(int)p
{
    if (self.level.isTimeAttack) self.level.pointsScored += p;
    else {
        self.level.pointsScored = MAX(p, self.level.pointsScored);
    }
}

- (void)onTick{
    self.time--;
    if (self.time <= 0) {
        [self.timerLabel setTextColor:[UIColor redColor]];
        [self timerOver];
        self.time=0;
    }
    
    self.timerLabel.text = [NSString stringWithFormat:@"%d",self.time];
}

- (void) timerOver
{
    //[self.timerController.timer invalidate];
    NSLog(@"TIMER OVER");
    [RBGame updateRecord:self.level.pointsScored];
    [self performSegueWithIdentifier:@"gameOver" sender:self];
}

- (IBAction)playButton:(id)sender {
    
    if (!self.level.isTimeAttack) {
        [RBGame saveDefaultLevels];
        [self performSegueWithIdentifier:@"levelsSegue" sender:self];
    }
    else
    {
        
        int p = [self calculatePoints];
        [self savePoints:p];
        p = self.level.pointsScored;
        [self.level changeColor];
        self.result.text = [NSString stringWithFormat:@"Total Pontuation: %d",p];
        self.color.backgroundColor = nil;
        self.targetPreview.backgroundColor = self.level.color;
        self.imagePreview.image = nil;
    }
}

- (IBAction)resetTimer:(id)sender {
    self.time = 30;
    [self.timerLabel setTextColor:[UIColor blackColor]];
    self.timerLabel.text = [NSString stringWithFormat:@"%d",self.time];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
