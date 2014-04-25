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

@interface LevelsCollectionVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation LevelsCollectionVC {
    NSArray* tableData;
    RBLevel* selectedLevel;
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
    
    [RBSharedFunctions playSound:@"comein"
                   withExtension:@"mp3"];
    
    tableData = [RBGame getDefaultLevels];
    
    AWCollectionViewDialLayout* dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:300.0
                                                                              andAngularSpacing:18.0
                                                                                    andCellSize:CGSizeMake(300, 100)
                                                                                   andAlignment:WHEELALIGNMENTCENTER
                                                                                  andItemHeight:100
                                                                                     andXOffset:150];
    
    [self.collectionView setCollectionViewLayout:dialLayout];
    
    // Do any additional setup after loading the view.
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
    
    //    if (cell == nil) {
    //        cell = [[LevelCollectionCell alloc] init
    //                                     reuseIdentifier:simpleTableIdentifier];
    //    }
    
    RBLevel* level = [tableData objectAtIndex:indexPath.row];
    
    cell.cellLabel.text = [NSString stringWithFormat:@"%@!", level.colorName];
    
    cell.cellLabel.textColor = [UIColor blackColor];
    
    //If we want to change the background color of the cells... we gotta sort by color first
    cell.backgroundColor = [level.color colorWithAlphaComponent:0.05];
    
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
