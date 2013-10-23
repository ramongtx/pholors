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
    self.targetColor.layer.borderColor = [[UIColor blackColor] CGColor];
    self.targetColor.layer.borderWidth = 2.0;
    self.targetColor.layer.cornerRadius = 25;
    self.targetColor.layer.masksToBounds = YES;
    self.targetColor.backgroundColor = [RBImage randomColor];
    self.result.text = @"";
    self.imagePreview.layer.borderColor = [[UIColor blackColor] CGColor];
    self.imagePreview.layer.borderWidth = 1.5;
    
    RBGame* game = [[RBGame alloc] init];
    [game loadLevels];
    
    self.timerLabel.text = @"";
    
    self.time = 30;
    self.timerController = [[RBTimer alloc]initWithTimer:1.0 andDelegate:self];
    self.timerLabel.text = [NSString stringWithFormat:@"%d",self.time];

    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.color.backgroundColor = [RBImage getDominantColor:image];
    self.result.text = [NSString stringWithFormat:@"Pontuation: %.0f",[RBImage euclideanDistanceFrom:self.color.backgroundColor to:self.targetColor.backgroundColor]*100];

}

- (void)onTick{
    self.time--;
    if (self.time == -1) {
        [self.timerController.timer invalidate];
        [self.timerLabel setTextColor:[UIColor redColor]];
    }
    self.timerLabel.text = [NSString stringWithFormat:@"%d",self.time];
}

- (IBAction)resetTimer:(id)sender {
    self.time = 30;
    [self.timerLabel setTextColor:[UIColor blackColor]];
    self.timerLabel.text = [NSString stringWithFormat:@"%d",self.time];
    self.timerController = [[RBTimer alloc]initWithTimer:1.0 andDelegate:self];
}
@end
