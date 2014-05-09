//
//  ViewController.m
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "GameVC.h"
#import <GameKit/GameKit.h>

@interface GameVC ()

@end

@implementation GameVC {
    UILabel* totalStarsBarLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.level.isTimeAttack) {
        self.timerLabel.hidden = YES;
        self.timerLabel.textAlignment = NSTextAlignmentCenter;
        self.colorNameLabel.text = self.level.colorName;
    }
    
    self.color.layer.borderColor = [[UIColor blackColor] CGColor];
    self.color.layer.borderWidth = 2.0;
    self.color.layer.cornerRadius = 25;
    self.color.layer.masksToBounds = YES;
    
    if (self.level.colorPlayed) {
        self.color.backgroundColor = self.level.colorPlayed;
        self.averageLabel.text = NSLocalizedString(@"Last Played", @"Last played color");
        [self updateStars:[self.level stars]];
    } else
        self.averageLabel.text = NSLocalizedString(@"Average Color", @"Average Color");
    
    self.targetPreview.layer.borderColor = [[UIColor blackColor] CGColor];
    self.targetPreview.layer.borderWidth = 2.0;
    self.targetPreview.layer.cornerRadius = 25;
    self.targetPreview.layer.masksToBounds = YES;
    
    self.imagePreview.layer.borderColor = [[UIColor blackColor] CGColor];
    self.imagePreview.layer.borderWidth = 1.5;
    
    self.totalPoints = 0;
    
    self.targetPreview.backgroundColor = self.level.color;
    
    self.timerLabel.text = self.level.colorName;
    self.timerLabel.textColor = [UIColor blackColor];
    
    if (self.level.isTimeAttack) {
        self.time = 80;
        self.timelock = 3;
        self.nextButton.enabled = NO;
        self.timerController = [[RBTimer alloc] initWithTimer:1.0
                                                  andDelegate:self];
        self.timerLabel.text = [NSString stringWithFormat:@"%@ %lds", NSLocalizedString(@"Time Left:", @"Time left"), (long)self.time];
        self.timerLabel.textColor = [UIColor redColor];
        self.colorNameLabel.hidden = YES;
        
        UIImageView* imView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"singleStar"]];
        
        [imView setFrame:CGRectMake(0, 0, 50, 50)];
        
        totalStarsBarLabel = [[UILabel alloc] init];
        totalStarsBarLabel.frame = CGRectMake(5, 15, 40, 20);
        self.totalPoints = 0;
        totalStarsBarLabel.textAlignment = NSTextAlignmentCenter;
        
        [imView addSubview:totalStarsBarLabel];
        
        if (self.level.isTimeAttack) {
            UIBarButtonItem* shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:imView];
            self.navigationItem.rightBarButtonItems = @[
                                                        shareBarButton
                                                        //item3
                                                        ];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.timerController start];
    //[self.navigationController setNavigationBarHidden:YES];
    if (!self.level.isTimeAttack) {
        self.title = self.level.colorName;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.timerController stop];
    
    [super viewWillDisappear:animated];
}

- (void)updateStars:(int)stars
{
    if (stars == 0)
        self.stars.image = [UIImage imageNamed:@"0star.png"];
    else if (stars == 1)
        self.stars.image = [UIImage imageNamed:@"1star.png"];
    else if (stars == 2)
        self.stars.image = [UIImage imageNamed:@"2star.png"];
    else {
        self.stars.image = [UIImage imageNamed:@"3star.png"];
    }
}

- (IBAction)button:(id)sender
{
    [self setGalleryDelegate:self];
    [self launchBrowser];
}

//When the selected picture finishes loading, it is time to calculate the distance
//between colors, atribute the number of stars and so on
- (void)didFinishLoadingImage:(UIImage*)image original:(UIImage*)originalImage
{
    self.imagePreview.image = image;
    self.imagePreview.contentMode = UIViewContentModeScaleAspectFit;
    self.imagePreview.clipsToBounds = YES;
    self.averageLabel.text = NSLocalizedString(@"Average Color", @"Average Color");
    
    self.totalPoints -= self.level.starsScored;
    
    int stars = [self.level playImageOnLevel:image];
    
    NSLog(@"starsHEre:%d", stars);
    self.color.backgroundColor = [RBImageProcessor getDominantColor:image]; //self.level.colorPlayed;
    [self updateStars:stars];
    
    self.totalPoints += self.level.starsScored;
    
    if (stars == 3)
        [RBSharedFunctions playSound:@"itsaspell"
                       withExtension:@"mp3"];
    
    if (self.level.isTimeAttack) {
        [RBSharedFunctions playSound:@"beam"
                       withExtension:@"mp3"];
    } else {
        [self reportChallengeScore];
    }
}

- (void)reportChallengeScore
{
    GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:@"Total_Challenge_Stars"];
    score.value = [RBGame allStars];
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error)
     {
         if (error != nil) {
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
    
    [RBGame updateAchievements];
}

- (int)calculatePoints
{
    if (self.imagePreview.image == nil)
        return 0;
    float distance = [RBImageProcessor cossineSimilarityFrom:self.color.backgroundColor
                                                          to:self.targetPreview.backgroundColor];
    return [RBImageProcessor convertDistanceToPoints:distance];
}

- (void)savePoints:(int)p
{
    if (self.level.isTimeAttack)
        self.level.starsScored += p;
    else {
        self.level.starsScored = MAX(p, self.level.starsScored);
    }
}

- (void)onTick
{
    self.time--;
    self.timelock--;
    
    if (self.timelock <= 0)
        self.nextButton.enabled = YES;
    else
        self.nextButton.enabled = NO;
    
    if (self.time == 7) {
        [RBSharedFunctions playSound:@"sample"
                       withExtension:@"mp3"];
    } else if (self.time == 0) {
        [RBSharedFunctions playSound:@"pullover"
                       withExtension:@"mp3"];
        [self.timerLabel setTextColor:[UIColor redColor]];
        [self timerOver];
        self.time = 0;
    }
    
    self.timerLabel.text = [NSString stringWithFormat:@"%@ %lds", NSLocalizedString(@"Time Left:", @"Time left"), (long)self.time];
    self.title = [NSString stringWithFormat:@"%@ %lds", NSLocalizedString(@"Time Left:", @"Time left"), (long)self.time];
}

- (void)timerOver
{
    [self.timerController.timer invalidate];
    self.highscore = [RBGame updateRecord:self.totalPoints];
    [self performSegueWithIdentifier:@"gameOver"
                              sender:self];
}

- (IBAction)playButton:(id)sender
{
    
    if (!self.level.isTimeAttack) {
        [RBGame saveDefaultLevels];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ((self.timelock <= 0) || (self.imagePreview.image != nil)) {
        self.timelock = 3;
        self.nextButton.enabled = NO;
        self.level = [[RBLevel alloc] init];
        self.level.isTimeAttack = YES;
        self.color.backgroundColor = nil;
        self.targetPreview.backgroundColor = self.level.color;
        self.imagePreview.image = nil;
        self.stars.image = [UIImage imageNamed:@"0star.png"];
    }
}

- (void)setTotalPoints:(NSInteger)totalPoints
{
    _totalPoints = totalPoints;
    totalStarsBarLabel.text = [NSString stringWithFormat:@"%ld", (long)totalPoints];
}

- (IBAction)stopButton:(id)sender
{
    
    if (self.level.isTimeAttack)
        [self timerOver];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButton:(id)sender
{
    
    NSString* text = [NSString stringWithFormat:@"I'm playing #pholors level \"%@\" and I got %d stars", self.level.colorName, self.level.stars];
    UIImage* image = [UIImage imageNamed:@"pholors"];
    NSURL* url = [NSURL URLWithString:@"https://itunes.apple.com/app/id824331341"];
    
    [RBSharedFunctions shareItems:@[
                                    text,
                                    url,
                                    image
                                    ]
                        forSender:self
                   withCompletion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"gameOver"]) {
        // Get reference to the destination view controller
        EndGameVC* vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.points = self.totalPoints;
        vc.highscore = self.highscore;
    }
}

@end
