//
//  LevelsCollectionVC.m
//  Pholors
//
//  Created by Felix Dumit on 4/25/14.
//  Copyright (c) 2014 Rock Bottom. All rights reserved.
//

#import "LevelsCollectionVC.h"
#import "LevelCollectionCell.h"
#import "RBSharedFunctions.h"
#import "RBGame.h"
#import "GameVC.h"
#import "AWCollectionViewDialLayout.h"
#import "UIColor-MJGAdditions.h"
#import <iAd/iAd.h>

@interface LevelsCollectionVC () <UICollectionViewDelegate, UICollectionViewDataSource, AWCollectionLayoutProtocol>

@end

@implementation LevelsCollectionVC {
    NSArray* tableData;
    RBLevel* selectedLevel;
    AWCollectionViewDialLayout* dialLayout;
    UILabel* totalStarsBarLabel;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.canDisplayBannerAds = YES;
    
    self.title = NSLocalizedString(@"Levels", @"LevelsVC title");
    [RBSharedFunctions playSound:@"comein"
                   withExtension:@"mp3"];
    
    NSArray* levelsArray = [RBGame getDefaultLevels];
    
    tableData = [levelsArray sortedArrayUsingComparator:
                 ^NSComparisonResult(id obj1, id obj2)
                 {
                     
                     RBLevel* l1 = (RBLevel*)obj1;
                     RBLevel* l2 = (RBLevel*)obj2;
                     
                     CGFloat hue, saturation, brightness, alpha;
                     [l1.color getHue:&hue
                           saturation:&saturation
                           brightness:&brightness
                                alpha:&alpha];
                     CGFloat hue2, saturation2, brightness2, alpha2;
                     [l2.color getHue:&hue2
                           saturation:&saturation2
                           brightness:&brightness2
                                alpha:&alpha2];
                     if (hue - hue2 < -0.1)
                         return NSOrderedAscending;
                     else if (hue - hue2 > 0.1)
                         return NSOrderedDescending;
                     
                     if (saturation - saturation2 < -0.1)
                         return NSOrderedAscending;
                     else if (saturation - saturation2 > 0.1)
                         return NSOrderedDescending;
                     
                     if (brightness < brightness2)
                         return NSOrderedAscending;
                     else if (brightness > brightness2)
                         return NSOrderedDescending;
                     
                     return NSOrderedSame;
                 }];
    
    dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:300.0
                                                  andAngularSpacing:18.0
                                                        andCellSize:CGSizeMake(300, 100)
                                                       andAlignment:WHEELALIGNMENTCENTER
                                                      andItemHeight:100
                                                         andXOffset:170];
    
    dialLayout.layoutDelegate = self;
    
    [self.collectionView setCollectionViewLayout:dialLayout];
    
    // Do any additional setup after loading the view.
    UIImageView* imView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"singleStar"]];
    
    [imView setFrame:CGRectMake(0, 0, 50, 50)];
    
    totalStarsBarLabel = [[UILabel alloc] init];
    totalStarsBarLabel.frame = CGRectMake(5, 15, 40, 20);
    
    totalStarsBarLabel.textAlignment = NSTextAlignmentCenter;
    
    [imView addSubview:totalStarsBarLabel];
    
    UIBarButtonItem* starImage = [[UIBarButtonItem alloc] initWithCustomView:imView];
    self.navigationItem.rightBarButtonItems = @[
                                                starImage
                                                //item3
                                                ];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIDeviceOrientationIsLandscape(toInterfaceOrientation))
        dialLayout.xOffset = 250;
    else {
        dialLayout.xOffset = 150;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.collectionView reloadData];
    totalStarsBarLabel.text = [NSString stringWithFormat:@"%ld", [RBGame allStars]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tableData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)cv cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* simpleTableIdentifier = @"LevelCell";
    
    LevelCollectionCell* cell = [cv dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier
                                                              forIndexPath:indexPath];
    
    RBLevel* level = [tableData objectAtIndex:indexPath.row];
    
    cell.cellLabel.text = [NSString stringWithFormat:@"%@!", level.colorName];
    
    cell.cellLabel.textColor = [level.color blackOrWhiteContrastingColor];
    
    //If we want to change the background color of the cells... we gotta sort by color first
    //cell.backgroundColor = [level.color colorWithAlphaComponent:0.05];
    
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
    
    //cell.colorImage.layer.borderWidth = 2.0;
    cell.colorImage.layer.cornerRadius = 15;
    cell.colorImage.image = nil;
    cell.colorImage.backgroundColor = level.color;
    
    //  cv.backgroundColor = level.color;
    
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    LevelCollectionCell* cell = (LevelCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    selectedLevel = cell.level;
    [self performSegueWithIdentifier:@"loadLevel"
                              sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"loadLevel"]) {
        [RBSharedFunctions playSound:@"onemusttry"
                       withExtension:@"mp3"];
        GameVC* vc = [segue destinationViewController];
        vc.level = selectedLevel;
    }
}

#pragma mark - Dial layout delegate
- (void)updateOnScreenList:(id)layoutCollection
{
    AWCollectionViewDialLayout* layout = (AWCollectionViewDialLayout*)layoutCollection;
    //NSLog(@"%@", layout.onScreenAngles);
    
    if (layout.onScreenAngles.count == 0)
        return;
    
    float r = 0, g = 0, b = 0;
    
    float factSum = 0;
    
    for (NSNumber* row in layout.onScreenAngles) {
        float angle = [layout.onScreenAngles[row] floatValue];
        RBLevel* level = [tableData objectAtIndex:[row integerValue]];
        
        float factor = 1 - angle / 30.0;
        
        const CGFloat* colors = CGColorGetComponents(level.color.CGColor);
        
        factor = factor * factor * factor * factor;
        
        r += factor * colors[0];
        g += factor * colors[1];
        b += factor * colors[2];
        
        factSum += factor;
    }
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:r / factSum
                                                          green:g / factSum
                                                           blue:b / factSum
                                                          alpha:1];
}

#pragma mark - UICollectionViewDelegate methods
//- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
//{
//    return CGSizeMake(240, 100);
//}
//
//- (UIEdgeInsets)collectionView:
//(UICollectionView*)collectionView
//                        layout:(UICollectionViewLayout*)collectionViewLayout
//        insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

@end
