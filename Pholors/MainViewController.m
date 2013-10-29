//
//  MainViewController.m
//  Pholors
//
//  Created by Ramon Carvalho Maciel on 10/28/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    [self performSegueWithIdentifier:@"timeAttack" sender:self];
}
- (IBAction)clear:(id)sender {
    [RBGame clearAll];
    [self viewWillAppear:FALSE];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.starsLabel.text = [NSString stringWithFormat:@"%li/%li",[RBGame allStars], [RBGame maxStars]];
    self.timeLabel.text = [NSString stringWithFormat:@"%li",[RBGame getRecord]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"timeAttack"])
    {
        // Get reference to the destination view controller
        ViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.level = [[RBLevel alloc] init];
        vc.level.isTimeAttack = YES;
    }
}

@end
