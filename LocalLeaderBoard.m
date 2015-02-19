//
//  LocalLeaderBoard.m
//  FootGolf2D
//
//  Created by Matthew Ashton on 2/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LocalLeaderBoard.h"
#import <Parse/Parse.h>
#import <Social/Social.h>

@interface LocalLeaderBoard ()
{
    NSArray *_levels;
    NSMutableArray *allScores;
    NSString *selectedLevel;
}

@end

@implementation LocalLeaderBoard

- (void)viewDidLoad {
    [super viewDidLoad];
    _levels = @[@"Select Level", @"Level 1", @"Level 2", @"Level 3"];
    allScores = [[NSMutableArray alloc] init];
    selectToTweet.hidden = true;
    
    self.levelPicker.dataSource = self;
    self.levelPicker.delegate = self;
    self.tableOfScores.dataSource = self;
    self.tableOfScores.delegate = self;
    
    self.tableOfScores.hidden = true;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int pickerCount = (int) _levels.count;
    
    return pickerCount;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _levels[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedLevel = _levels[row];
    NSLog(@"%@", selectedLevel);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allScores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [allScores objectAtIndex:indexPath.row];
    
    return cell;
    
}


// User selects the level to show the high scores for.  If no scores are present, an alert is shown to go play that level.  This is my filter.
-(IBAction)onSelect:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
    [query whereKey:@"whatLevel" equalTo:selectedLevel];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count == 0){
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"No High Scores Found"
                                                             message:@"Play that level to get a High Score!"
                                                            delegate:self
                                                   cancelButtonTitle:@"Okay."
                                                   otherButtonTitles: nil];
                [alert show];
            } else {
                for (PFObject *object in objects) {
                    NSString *name = object[@"playerName"];
                    int score = [[object objectForKey:@"score"] intValue];
                    NSMutableString *highScore;
                    highScore = [[NSMutableString alloc] init];
                    [highScore setString:[NSString stringWithFormat:@"%@ got the score of %d seconds", name, score]];
                    [allScores addObject:highScore];
                    [self.tableOfScores reloadData];
                }
                self.tableOfScores.hidden = false;
                selectToTweet.hidden = false;
            }
        } else {
            
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        self.tableOfScores.hidden = true;
    }
}

-(IBAction)onBack:(id)sender
{
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] presentScene:mainScene];
}

// When the user selects a high score, they can tweet that high score.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@", [allScores objectAtIndex:indexPath.row]]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}


@end
