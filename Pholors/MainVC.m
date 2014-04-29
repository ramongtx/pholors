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

@interface MainVC () <UIAlertViewDelegate>
@end

@implementation MainVC

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
    
    NSString* text = @"I'm playing pholors, its amazing! #pholors";
    NSURL* url = [NSURL URLWithString:@"https://itunes.apple.com/app/id824331341"];
    UIImage* image = [UIImage imageNamed:@"pholors"];
    
    //    void (^completion)(NSString * activityType, BOOL completed) = ^(NSString * activityType, BOOL completed)
    //    {
    //        if (completed) {
    //            [RBGame increaseLevelPackCount];
    //            [RBSharedFunctions playSound:@"whistle"
    //                           withExtension:@"mp3"];
    //        }
    //    };
    
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
             self.timeLabel.text = [NSString stringWithFormat:@"%li", [RBGame getRecord]];
         }
     }
     ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RBSharedFunctions playSound:@"welcome"
                   withExtension:@"mp3"];
    
    //NSString* title = @"Titile loco";
   // NSString* message = @"Mensagem loclona";
    
    //    [GKNotificationBanner showBannerWithTitle:title
    //                                      message:message
    //                            completionHandler:^{
    //                                NSLog(@"here booy");
    //                            }];
    //
    
    // Do any additional setup after loading the view.
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
        //Call it to update
        [self viewWillAppear:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.starsLabel.text = [NSString stringWithFormat:@"%li/%li", [RBGame allStars], [RBGame maxStars]];
    self.timeLabel.text = [NSString stringWithFormat:@"%li", [RBGame getRecord]];
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
