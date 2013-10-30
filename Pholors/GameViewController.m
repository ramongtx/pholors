//
//  ViewController.m
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!STARS || self.level.isTimeAttack) self.stars.hidden = YES;
    else self.result.hidden = YES;
    
    self.color.layer.borderColor = [[UIColor blackColor] CGColor];
    self.color.layer.borderWidth = 2.0;
    self.color.layer.cornerRadius = 25;
    self.color.layer.masksToBounds = YES;
    
    self.result.text = [NSString stringWithFormat:@"Pontuation: %d",self.level.pointsScored];
    
    if(self.level.colorPlayed){
        self.color.backgroundColor = self.level.colorPlayed;
        self.averageLabel.text = @"Last Played";
        [self updateStars:[self.level stars]];
    }
    else
        self.averageLabel.text = @"Average Color";
    
    self.targetPreview.layer.borderColor = [[UIColor blackColor] CGColor];
    self.targetPreview.layer.borderWidth = 2.0;
    self.targetPreview.layer.cornerRadius = 25;
    self.targetPreview.layer.masksToBounds = YES;
    
    self.imagePreview.layer.borderColor = [[UIColor blackColor] CGColor];
    self.imagePreview.layer.borderWidth = 1.5;
    
    self.timerLabel.hidden = YES;
    
    self.totalPoints = 0;
    
    self.targetPreview.backgroundColor = self.level.color;
    
    if (self.level.isTimeAttack) {
        self.time = 80;
        self.timelock = 3;
        self.timerController = [[RBTimer alloc]initWithTimer:1.0 andDelegate:self];
        self.timerLabel.text = [NSString stringWithFormat:@"%d",self.time];
        self.timerLabel.hidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void) updateStars:(int)stars
{
    if (stars == 0) self.stars.image = [UIImage imageNamed:@"0star.png"];
    else if (stars == 1) self.stars.image = [UIImage imageNamed:@"1star.png"];
    else if (stars == 2) self.stars.image = [UIImage imageNamed:@"2star.png"];
    else self.stars.image = [UIImage imageNamed:@"3star.png"];
}

- (IBAction)button:(id)sender {
    [self setGalleryDelegate:self];
    [self launchBrowser];
}

-(void) didFinishLoadingImage:(UIImage *)image original:(UIImage*)originalImage
{
    self.imagePreview.image = image;
    self.imagePreview.contentMode = UIViewContentModeScaleAspectFit;
    self.imagePreview.clipsToBounds = YES;
    self.averageLabel.text = @"Average Color";

    
    int points = [self.level playImageOnLevel:image original:originalImage];
    
    self.color.backgroundColor = [RBImage getDominantColor:image];
    [self updateStars:[RBImage convertPointstoStars:points]];
    self.result.text = [NSString stringWithFormat:@"Pontuation: %d",points];

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
    self.timelock--;
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
    [RBGame updateRecord:self.totalPoints];
    [self performSegueWithIdentifier:@"gameOver" sender:self];
}

- (IBAction)playButton:(id)sender {
    
    if (!self.level.isTimeAttack) {
        [RBGame saveDefaultLevels];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ((self.timelock <= 0) || (self.imagePreview.image != nil))
    {
        self.timelock = 3;
        self.totalPoints += [self calculatePoints];
        self.level = [[RBLevel alloc] init];
        self.level.isTimeAttack = YES;
        self.result.text = [NSString stringWithFormat:@"Total Pontuation: %d",self.totalPoints];
        self.color.backgroundColor = nil;
        self.targetPreview.backgroundColor = self.level.color;
        self.imagePreview.image = nil;
    }
}
- (IBAction)stopButton:(id)sender {
    if (self.level.isTimeAttack)
        [self timerOver];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

@end
