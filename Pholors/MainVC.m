//
//  MainViewController.m
//  Pholors
//
//  Created by Ramon Carvalho Maciel on 10/28/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)clickPholors:(id)sender {
    [RBSharedFunctions playSound:@"whistle" withExtension:@"mp3"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RBSharedFunctions playSound:@"welcome" withExtension:@"mp3"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)challengeMode:(id)sender {
    [self performSegueWithIdentifier:@"challengeSegue" sender:self];

}
- (IBAction)timeAttack:(id)sender {
    [RBSharedFunctions playSound:@"upupandaway" withExtension:@"mp3"];
    [self performSegueWithIdentifier:@"timeAttack" sender:self];
}
- (IBAction)clear:(id)sender {
    [RBGame clearAll];
    [self viewWillAppear:FALSE];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.starsLabel.text = [NSString stringWithFormat:@"%li/%li",[RBGame allStars], [RBGame maxStars]];
    self.timeLabel.text = [NSString stringWithFormat:@"%li",[RBGame getRecord]];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"timeAttack"])
    {
        // Get reference to the destination view controller
        GameVC *vc = [segue destinationViewController];
        
        // Set TimeAttack Mode
        vc.level = [[RBLevel alloc] init];
        vc.level.isTimeAttack = YES;
    }
}

@end
