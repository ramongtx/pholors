//
//  MainViewController.m
//  Pholors
//
//  Created by Ramon Carvalho Maciel on 10/28/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "MainVC.h"
#import "RBGame.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Appirater.h>
#import <GameKit/GameKit.h>

@interface MainVC () <UIAlertViewDelegate, GKGameCenterControllerDelegate>

@property BOOL gameCenterEnabled;

@end

@implementation MainVC

- (void)authenticateLocalPlayer
{
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController * viewController, NSError * error)
    {
        if (viewController != nil) {
            [self presentViewController:viewController
                               animated:YES
                             completion:nil];
        } else {
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                
                //                // Get the default leaderboard identifier.
                //                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error)
                //                 {
                //
                //                     if (error != nil) {
                //                         NSLog(@"%@", [error localizedDescription]);
                //                     } else {
                //                         _leaderboardIdentifier = leaderboardIdentifier;
                //                     }
                //                 }];
            } else {
                _gameCenterEnabled = NO;
            }
        }
    };
}

- (void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard
{
    GKGameCenterViewController* gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        //gcViewController.leaderboardIdentifier = @"TIME_ATTACK_BEST";
    } else {
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self presentViewController:gcViewController
                       animated:YES
                     completion:nil];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES
                                                 completion:nil];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)clickPholors:(id)sender
{
    
    //[Appirater rateApp];
    [self sharePholors];
}
- (void)clickGameCenter:(id)sender
{
    [self showLeaderboardAndAchievements:YES];
}

- (void)sharePholors
{
    
    NSString* text = @"I'm playing pholors, its amazing! #pholors";
    NSURL* url = [NSURL URLWithString:@"https://itunes.apple.com/app/id824331341"];
    UIImage* image = [UIImage imageNamed:@"pholors"];
    
    [RBSharedFunctions shareItems:@[
                                    text,
                                    url,
                                    image
                                    ]
                        forSender:self
                   withCompletion:^(NSString * activityType, BOOL completed)
     {
         if (completed) {
             [RBGame increaseLevelPackCount];
             [RBSharedFunctions playSound:@"whistle"
                            withExtension:@"mp3"];
             self.starsLabel.text = [NSString stringWithFormat:@"%li/%li", [RBGame allStars], [RBGame maxStars]];
             self.timeLabel.text = [NSString stringWithFormat:@"%li", (long)[RBGame getRecord]];
         }
     }
     ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RBSharedFunctions playSound:@"welcome"
                   withExtension:@"mp3"];
    
    [self authenticateLocalPlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)challengeMode:(id)sender
{
    [self performSegueWithIdentifier:@"challengeSegue"
                              sender:self];
}
- (IBAction)timeAttack:(id)sender
{
    [RBSharedFunctions playSound:@"upupandaway"
                   withExtension:@"mp3"];
    [self performSegueWithIdentifier:@"timeAttack"
                              sender:self];
}
- (IBAction)clear:(id)sender
{
    UIAlertView* confirmAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Clear Stats", @"Message from the Alert to Clear Stats")
                                                               message:NSLocalizedString(@"Are you sure?", @"Message from the Alert to confirm if the user wants to clear his stats")
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"No", @"No")
                                                     otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
    [confirmAlertView show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [RBGame clearAll];
        
        [self resetAchievements];
        
        //Call it to update
        [self viewWillAppear:NO];
    }
}

- (void)resetAchievements
{
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil) {
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:YES];
    
    self.navigationItem.title = @"";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Leaderboards"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(clickGameCenter:)];
    
    self.navigationItem.rightBarButtonItem = /*[[UIBarButtonItem alloc] initWithTitle:@"Share"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(sharePholors)];*/
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                  target:self
                                                  action:@selector(sharePholors)];
    
    self.starsLabel.text = [NSString stringWithFormat:@"%li/%li", [RBGame allStars], [RBGame maxStars]];
    self.timeLabel.text = [NSString stringWithFormat:@"%li", (long)[RBGame getRecord]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"timeAttack"]) {
        // Get reference to the destination view controller
        GameVC* vc = [segue destinationViewController];
        
        // Set TimeAttack Mode
        vc.level = [[RBLevel alloc] init];
        vc.level.isTimeAttack = YES;
    }
}

@end
