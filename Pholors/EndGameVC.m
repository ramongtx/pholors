//
//  GameOverViewController.m
//  Pholors
//
//  Created by Rafael Padilha on 23/10/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "EndGameVC.h"

@interface EndGameVC ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation EndGameVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString* str = [NSString stringWithFormat:@"You scored: %d points", self.points];
    if(self.highscore)
        str = [str stringByAppendingString:@" (HIGH SCORE)"];
    self.scoreLabel.text = str;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)restart:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

@end
