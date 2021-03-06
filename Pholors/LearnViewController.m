//
//  LearnViewController.m
//  Pholors
//
//  Created by Rafael Padilha on 14/04/14.
//  Copyright (c) 2014 Rock Bottom. All rights reserved.
//

#import "LearnViewController.h"
#import "RBImageProcessor.h"

@interface LearnViewController ()

@end

@implementation LearnViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)randomColor:(id)sender
{
    float r = drand48(), g = drand48(), b = drand48();

    if (self.viewPickSC.selectedSegmentIndex == 0) {
        self.leftColorView.backgroundColor = [UIColor colorWithRed:r
                                                             green:g
                                                              blue:b
                                                             alpha:1.0];
    } else
        self.rightColorView.backgroundColor = [UIColor colorWithRed:r
                                                              green:g
                                                               blue:b
                                                              alpha:1.0];

    self.RSlider.value = r;
    self.GSlider.value = g;
    self.BSlider.value = b;

    self.RLabel.text = [NSString stringWithFormat:@"%f", self.RSlider.value];
    self.GLabel.text = [NSString stringWithFormat:@"%f", self.GSlider.value];
    self.BLabel.text = [NSString stringWithFormat:@"%f", self.BSlider.value];

    self.saveButton.enabled = YES;
}
- (IBAction)saveOnTxt:(id)sender
{
    [RBImageProcessor writeToLearningLog:self.leftColorView.backgroundColor
                                      To:self.rightColorView.backgroundColor
                                   Stars:[self.valueTF.text integerValue]];
    self.saveButton.enabled = NO;
    self.valueTF.text = @"";
}

- (IBAction)selectView:(id)sender
{

    if (self.viewPickSC.selectedSegmentIndex == 0) {
        const CGFloat* componentsColor = CGColorGetComponents([self.leftColorView.backgroundColor CGColor]);
        self.RSlider.value = componentsColor[0];
        self.GSlider.value = componentsColor[1];
        self.BSlider.value = componentsColor[2];
    } else {
        const CGFloat* componentsColor = CGColorGetComponents([self.rightColorView.backgroundColor CGColor]);
        self.RSlider.value = componentsColor[0];
        self.GSlider.value = componentsColor[1];
        self.BSlider.value = componentsColor[2];
    }
    self.RLabel.text = [NSString stringWithFormat:@"%f", self.RSlider.value];
    self.GLabel.text = [NSString stringWithFormat:@"%f", self.GSlider.value];
    self.BLabel.text = [NSString stringWithFormat:@"%f", self.BSlider.value];
}
- (IBAction)colorComponentChange:(id)sender
{
    self.RLabel.text = [NSString stringWithFormat:@"%f", self.RSlider.value];
    if (self.viewPickSC.selectedSegmentIndex == 0) {
        self.leftColorView.backgroundColor = [UIColor colorWithRed:self.RSlider.value
                                                             green:self.GSlider.value
                                                              blue:self.BSlider.value
                                                             alpha:1.0];
    } else
        self.rightColorView.backgroundColor = [UIColor colorWithRed:self.RSlider.value
                                                              green:self.GSlider.value
                                                               blue:self.BSlider.value
                                                              alpha:1.0];

    self.saveButton.enabled = YES;
}
- (IBAction)greenComponentChange:(id)sender
{
    self.GLabel.text = [NSString stringWithFormat:@"%f", self.GSlider.value];
    if (self.viewPickSC.selectedSegmentIndex == 0) {
        self.leftColorView.backgroundColor = [UIColor colorWithRed:self.RSlider.value
                                                             green:self.GSlider.value
                                                              blue:self.BSlider.value
                                                             alpha:1.0];
    } else
        self.rightColorView.backgroundColor = [UIColor colorWithRed:self.RSlider.value
                                                              green:self.GSlider.value
                                                               blue:self.BSlider.value
                                                              alpha:1.0];

    self.saveButton.enabled = YES;
}
- (IBAction)blueComponentChange:(id)sender
{
    self.BLabel.text = [NSString stringWithFormat:@"%f", self.BSlider.value];
    if (self.viewPickSC.selectedSegmentIndex == 0) {
        self.leftColorView.backgroundColor = [UIColor colorWithRed:self.RSlider.value
                                                             green:self.GSlider.value
                                                              blue:self.BSlider.value
                                                             alpha:1.0];
    } else
        self.rightColorView.backgroundColor = [UIColor colorWithRed:self.RSlider.value
                                                              green:self.GSlider.value
                                                               blue:self.BSlider.value
                                                              alpha:1.0];
    self.saveButton.enabled = YES;
}
- (IBAction)starsChanged:(id)sender
{
    self.starsLabel.text = [NSString stringWithFormat:@"Stars:%d", (int)self.starsSlider.value];
}

- (void)dismissKeyboard
{
    [self.valueTF resignFirstResponder];
}

@end
