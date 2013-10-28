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
    
    self.targetPreview.layer.borderColor = [[UIColor blackColor] CGColor];
    self.targetPreview.layer.borderWidth = 2.0;
    self.targetPreview.layer.cornerRadius = 25;
    self.targetPreview.layer.masksToBounds = YES;
    
    self.imagePreview.layer.borderColor = [[UIColor blackColor] CGColor];
    self.imagePreview.layer.borderWidth = 1.5;
    
    self.result.text = @"";
    self.timerLabel.text = @"";
    
    self.targetPreview.backgroundColor = self.level.color;
    
    self.time = 30;
    self.timerController = [[RBTimer alloc]initWithTimer:1.0 andDelegate:self];
    self.timerLabel.text = [NSString stringWithFormat:@"%d",self.time];
}

- (IBAction)button:(id)sender {
    [self setGalleryDelegate:self];
    [self launchBrowser];
}

-(void) didFinishLoadingImage:(UIImage *)image original:(UIImage*)originalImage
{
    self.imagePreview.image = image;
    NSLog(@"loadImage: %@ original:%@" , image.description, originalImage.description);
    self.imagePreview.contentMode = UIViewContentModeScaleAspectFit;
    self.imagePreview.clipsToBounds = YES;
    
    self.level.colorPlayed = [RBImage getDominantColor:image];
    self.color.backgroundColor = self.level.colorPlayed;
    float distance = [RBImage euclideanDistanceFrom:self.color.backgroundColor to:self.targetPreview.backgroundColor];
    self.level.pointsScored = [RBImage convertDistanceToPoints:distance];
    self.result.text = [NSString stringWithFormat:@"Pontuation: %d",self.level.pointsScored];


}

- (void)onTick{
    self.time--;
    if (self.time == 0) {
        [self.timerLabel setTextColor:[UIColor redColor]];
        [self timerOver];
    }
    self.timerLabel.text = [NSString stringWithFormat:@"%d",self.time];
}

- (void) timerOver
{
    [self performSegueWithIdentifier:@"gameOver" sender:self];
}

- (IBAction)playButton:(id)sender {
    [self timerOver];
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
