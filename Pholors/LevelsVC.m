//
//  LevelsViewController.m
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "LevelsVC.h"
#import <iAd/iAd.h>

@interface LevelsVC ()

@end

@implementation LevelsVC {
    NSArray* tableData;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // propagandou!! $$$$$
    self.canDisplayBannerAds = YES;

    [RBSharedFunctions playSound:@"comein"
                   withExtension:@"mp3"];

    tableData = [RBGame getDefaultLevels];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableData count];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* simpleTableIdentifier = @"LevelCell";

    LevelTableCell* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[LevelTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:simpleTableIdentifier];
    }

    RBLevel* level = [tableData objectAtIndex:indexPath.row];

    cell.cellLabel.text = [NSString stringWithFormat:@"%@!", level.colorName];
    cell.cellLabel.textColor = level.color;
    cell.level = level;

    int stars = [level stars];
    if (stars == 0)
        cell.starImage.image = [UIImage imageNamed:@"0star.png"];
    else if (stars == 1)
        cell.starImage.image = [UIImage imageNamed:@"1star.png"];
    else if (stars == 2)
        cell.starImage.image = [UIImage imageNamed:@"2star.png"];
    else
        cell.starImage.image = [UIImage imageNamed:@"3star.png"];

    cell.colorImage.layer.borderWidth = 2.0;
    cell.colorImage.layer.cornerRadius = 25;
    cell.colorImage.image = nil;

    cell.colorImage.backgroundColor = level.color;

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    LevelTableCell* cell = (LevelTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    self.selectedLevel = cell.level;
    [self performSegueWithIdentifier:@"loadLevel"
                              sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"loadLevel"]) {
        [RBSharedFunctions playSound:@"onemusttry"
                       withExtension:@"mp3"];
        GameVC* vc = [segue destinationViewController];
        vc.level = self.selectedLevel;
    }
}
@end
