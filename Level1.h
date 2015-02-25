//
//  Level1.h
//  FootGolf2D
//
//  Created by Matthew Ashton on 1/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

@interface Level1 : CCScene <UIAlertViewDelegate>
{
    int score;
    int timeSec;
    int usersScore;
    int ballsOutOfBounds;
    float outOfBoundsPerc;
    BOOL paused;
    BOOL isOut;
    NSTimer *timer;
    CCNode *_arrow;
    CCNode *_soccerBall;
    CCNode *_ground;
    CCNode *thisIsATree;
    CCSlider *slideBar;
    CCLabelTTF *_par;
    CCPhysicsNode *_physicsNode;
    
}
-(void)updateOutOfBounds;

@property (nonatomic, strong) NSString *leaderboardIdentifier;

@end
