//
//  LevelsViewController.m
//  Pholors
//
//  Created by Felix Dumit on 10/23/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "LevelsViewController.h"

@interface LevelsViewController ()

@end

@implementation LevelsViewController
{
    NSArray *tableData;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView setFrame:CGRectMake(0, 20, 320, 600)];
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"LevelsViewController.viewDidLoad");
    
    //remove creating from here, pass through segway instead
    RBGame* game = [[RBGame alloc] init];
    
    tableData = game.levels;

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;//[tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"LevelCell";
    
    LevelTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[LevelTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    RBLevel* level = [tableData objectAtIndex:indexPath.row];
    
    //cell.text = level.description;
    
    cell.cellLabel.text = [NSString stringWithFormat:@"Level %ld", (long)indexPath.row];
    cell.level = level;
    
    if (level.pointsScored < 25) cell.starImage.image = [UIImage imageNamed:@"0star.png"];
    else if (level.pointsScored < 50) cell.starImage.image = [UIImage imageNamed:@"1star.png"];
    else if (level.pointsScored < 75) cell.starImage.image = [UIImage imageNamed:@"2star.png"];
    else cell.starImage.image = [UIImage imageNamed:@"3star.png"];
    
    
    cell.colorImage.layer.borderWidth = 2.0;
    cell.colorImage.layer.cornerRadius = 25;
    cell.colorImage.image = nil;
    
    cell.colorImage.backgroundColor = level.color;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LevelTableCell* cell = (LevelTableCell*) [tableView cellForRowAtIndexPath:indexPath];
    self.selectedLevel = cell.level;
    [self performSegueWithIdentifier:@"loadLevel" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"loadLevel"])
    {
        // Get reference to the destination view controller
        ViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.level = self.selectedLevel;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation


@end
