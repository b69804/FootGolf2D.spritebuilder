//
//  LocalLeaderBoard.h
//  FootGolf2D
//
//  Created by Matthew Ashton on 2/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalLeaderBoard : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

{
    IBOutlet UIButton *getScores;
    IBOutlet UIButton *goBack;
    IBOutlet UILabel *selectToTweet;
}

@property (weak, nonatomic) IBOutlet UIPickerView *levelPicker;
@property (weak, nonatomic) IBOutlet UITableView *tableOfScores;

-(IBAction)onSelect:(id)sender;
-(IBAction)onBack:(id)sender;

@end
