//
//  GameOverViewController.m
//  Pholors
//
//  Created by Rafael Padilha on 23/10/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "EndGameVC.h"

@interface EndGameVC ()
@property(weak, nonatomic) IBOutlet UILabel* scoreLabel;
@property(weak, nonatomic) IBOutlet UILabel* highScoreLabel;

@end

@implementation EndGameVC

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
    NSString* str = [NSString stringWithFormat:@"%@  %d", NSLocalizedString(@"You scored:", @"You scored"), self.points];
    if (self.highscore)
        self.highScoreLabel.text = NSLocalizedString(@"(HIGH SCORE)", "High score");
    else
        self.highScoreLabel.text = @"";
    self.scoreLabel.text = str;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)restart:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

@end
