
#import "Level1.h"
#import "cocos2d.h"
#import "CCPhysicsNode.h"
#import <Parse/Parse.h>
#import <GameKit/GameKit.h>

@implementation Level1
{
    CCButton *nextLevel;
    CCButton *pause;
    CCButton *resume;
}


-(void)angleSlider:(id)sender{
    
    CCSlider *newSLider = sender;
    NSLog(@"%f", newSLider.sliderValue);
    
    float newAngle = newSLider.sliderValue * -180;
    
    _arrow.rotation = newAngle;
}

-(void)onEnter{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    outOfBoundsPerc = 0.0;
    ballsOutOfBounds = 0;
    score = 0;
    isOut = false;
    timeSec = 90;
    [self StartTimer];
    // Cant quite this to have the proper physics for flight but I am working on that
    _soccerBall = [CCSprite spriteWithImageNamed:@"ImageAssets/BallHD_03.png"];
    _soccerBall.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:(_soccerBall.contentSize.width/2) andCenter:CGPointMake(8.0, 8.0)];
    _soccerBall.position = ccp(54.8, 99.7);
    _soccerBall.physicsBody.density = 1.0;
    _soccerBall.physicsBody.friction = 0.30;
    _soccerBall.physicsBody.elasticity = 0.30;
    _soccerBall.physicsBody.allowsRotation = NO;
    [_physicsNode addChild:_soccerBall];
    
    [super onEnter];
}

-(void)hitBall:(id)sender{
    
    score++;
    
    if (!isOut) {
        ballsOutOfBounds = 0;
    } else {
        isOut = false;
    }
    
    float betterAngle;
    
    float angleOfArrow = _arrow.rotation;
    NSLog(@"%f", angleOfArrow);
    betterAngle = (angleOfArrow * -1.00);
    NSLog(@"%f", betterAngle);
    CGPoint direction = ccp(cosf(betterAngle), sinf(betterAngle));
    NSLog(@"%@", NSStringFromCGPoint(direction));
    float forceValue = 50;
    CGPoint shootAmount = ccpMult(direction, forceValue);
    [_soccerBall.physicsBody applyImpulse:(shootAmount)];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"SportGolf DM006_62.wav"];
    
    
    
}

// This resets the ball to the starting position after going off screen
- (void)update:(CCTime)delta{
    if (_soccerBall.position.x <= 0){
        [_soccerBall removeFromParent];
        _soccerBall = [CCSprite spriteWithImageNamed:@"ImageAssets/BallHD_03.png"];
        _soccerBall.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:(_soccerBall.contentSize.width/2) andCenter:CGPointMake(8.0, 8.0)];
        _soccerBall.physicsBody.density = 1.0;
        _soccerBall.physicsBody.friction = 0.30;
        _soccerBall.physicsBody.elasticity = 0.30;
        _soccerBall.position = ccp(54.8, 99.7);
        _soccerBall.physicsBody.allowsRotation = NO;
        ballsOutOfBounds++;
        outOfBoundsPerc = (20 * ballsOutOfBounds);
        [self updateOutOfBounds];
        [self firstShotOut];
        NSLog(@"%d", ballsOutOfBounds);
        isOut = true;
        [_physicsNode addChild:_soccerBall];
    }
    
    if (_soccerBall.position.y >= 335){
        [_soccerBall removeFromParent];
        _soccerBall = [CCSprite spriteWithImageNamed:@"ImageAssets/BallHD_03.png"];
        _soccerBall.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:(_soccerBall.contentSize.width/2) andCenter:CGPointMake(8.0, 8.0)];
        _soccerBall.physicsBody.density = 1.0;
        _soccerBall.physicsBody.friction = 0.30;
        _soccerBall.physicsBody.elasticity = 0.30;
        _soccerBall.position = ccp(54.8, 99.7);
        _soccerBall.physicsBody.allowsRotation = NO;
        ballsOutOfBounds++;
        outOfBoundsPerc = (20 * ballsOutOfBounds);
        [self updateOutOfBounds];
        [self firstShotOut];
        NSLog(@"%d", ballsOutOfBounds);
        isOut = true;
        [_physicsNode addChild:_soccerBall];
    }
    
    if (_soccerBall.position.x >= 565){
        [_soccerBall removeFromParent];
        _soccerBall = [CCSprite spriteWithImageNamed:@"ImageAssets/BallHD_03.png"];
        _soccerBall.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:(_soccerBall.contentSize.width/2) andCenter:CGPointMake(8.0, 8.0)];
        _soccerBall.physicsBody.density = 1.0;
        _soccerBall.physicsBody.friction = 0.30;
        _soccerBall.physicsBody.elasticity = 0.30;
        _soccerBall.position = ccp(54.8, 99.7);
        _soccerBall.physicsBody.allowsRotation = NO;
        ballsOutOfBounds++;
        outOfBoundsPerc = (20 * ballsOutOfBounds);
        [self updateOutOfBounds];
        [self firstShotOut];
        NSLog(@"%d", ballsOutOfBounds);
        isOut = true;
        [_physicsNode addChild:_soccerBall];
    }
    
    // Once I get the physics worked out, this will identify if the is in the cup.  I will then transition the scene to the next level
    if (_soccerBall.position.x <= 470.0 && _soccerBall.position.y <= 118.0 && _soccerBall.position.x >= 457.0 && _soccerBall.position.y >= 108.0) {
        NSLog(@"Ball is in the hole.");
        // This is where I get the User's score.  It will be the time it took the user to get the ball in the hole.
        // Score is saved to both GameCenter and Locally.
        usersScore = (90 - timeSec);
        _leaderboardIdentifier = @"Level1";
        GKScore *gamecenterScore = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
        gamecenterScore.value = usersScore;
        [GKScore reportScores:@[gamecenterScore] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
        // This is my measureable achievement.  If the user gets the ball into the hole on their first shot, they get this achievement.  
        if (score == 1){
            GKAchievement *timeAchievement = nil;
            timeAchievement = [[GKAchievement alloc] initWithIdentifier:@"firstShot"];
            timeAchievement.percentComplete = 100;
            timeAchievement.showsCompletionBanner = YES;
            NSArray *achievementArray = @[timeAchievement];
            [GKAchievement reportAchievements:achievementArray withCompletionHandler:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"%@", [error localizedDescription]);
                }
            }];
        }
        
        // This is my completion achievement.  If the user's score is less than 10 seconds, they earn this achievement.
        if (usersScore <10){
            GKAchievement *timeAchievement = nil;
            timeAchievement = [[GKAchievement alloc] initWithIdentifier:@"lessthan_10"];
            timeAchievement.percentComplete = 100;
            timeAchievement.showsCompletionBanner = YES;
            NSArray *achievementArray = @[timeAchievement];
            [GKAchievement reportAchievements:achievementArray withCompletionHandler:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"%@", [error localizedDescription]);
                }
            }];
        }
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Save your Score!"
                                                         message:@"Enter a Name to save your score under."
                                                        delegate:self
                                               cancelButtonTitle:@"Save!"
                                               otherButtonTitles: nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
        [[CCDirector sharedDirector] pause];
        [_soccerBall removeFromParent];
    }
}

// This is my negative achievement.  If the first shot the user takes goes out of bound, then they get his achievement.
-(void)firstShotOut
{
    if (score == 1){
        GKAchievement *timeAchievement = nil;
        timeAchievement = [[GKAchievement alloc] initWithIdentifier:@"firstInFirstOut"];
        timeAchievement.percentComplete = 100;
        timeAchievement.showsCompletionBanner = YES;
        NSArray *achievementArray = @[timeAchievement];
        [GKAchievement reportAchievements:achievementArray withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
}

-(void)updateOutOfBounds
{
    // This is my incremental achievement.  When the user hits 5 balls out of bounds in a row, they will earn this achievement.
        GKAchievement *negativeAchievment = nil;
        negativeAchievment = [[GKAchievement alloc] initWithIdentifier:@"tooManyMissHits"];
        negativeAchievment.percentComplete = outOfBoundsPerc;
        if (ballsOutOfBounds == 5){
            negativeAchievment.showsCompletionBanner = YES;
        }
        NSArray *achievementArray = @[negativeAchievment];
        [GKAchievement reportAchievements:achievementArray withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
            }
        }];
}

- (BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair ball:(CCNode *)_soccerBall tree:(CCNode *)thisIsATree
{
    NSLog(@"Ball hit tree");
    return YES;
}

-(void) StartTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)timerTick:(NSTimer *)timer
{
    if (paused == NO){
        timeSec--;
        if (timeSec == 0)
        {
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Time's Up!"
                                                        message:@"You have run out of time!  The level will now be reset."
                                                        delegate:self
                                                        cancelButtonTitle:@"Okay."
                                                        otherButtonTitles: nil];
            [alert show];
            paused = YES;
        }
        NSString* timeNow = [NSString stringWithFormat:@"%02d", timeSec];
        [_par setString: timeNow];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Save!"])
    {
        // When the ball goes in the hole, an Alert is shown asking the user to input a name to save the score as locally.
        UITextField *name = [alertView textFieldAtIndex:0];
        PFObject *level1Score = [PFObject objectWithClassName:@"GameScore"];
        level1Score[@"score"] = [NSNumber numberWithInt:usersScore];
        NSString *savedName = name.text;
        level1Score[@"whatLevel"] = @"Level 1";
        level1Score[@"playerName"] = savedName;
        
        [level1Score saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // When the score saves to Parse, the transition to the next screen occurs.
                NSLog(@"Score Saved.");
                [[CCDirector sharedDirector] resume];
                [[OALSimpleAudio sharedInstance] playEffect:@"Applause.wav"];
                
                id transition = [CCTransition transitionFadeWithDuration:3.0];
                [timer invalidate];
                
                CCScene *secondLevel = [CCBReader loadAsScene:@"Level2"];
                [[CCDirector sharedDirector] replaceScene:secondLevel withTransition:transition];
                
                
            } else {
                // There was a problem, check error.description
            }
        }];
    } else if ([title isEqualToString:@"Okay."])
    {
        CCScene *firstLevel = [CCBReader loadAsScene:@"Level1"];
        [[CCDirector sharedDirector] replaceScene:firstLevel];
    };
}

-(void)pause:(id)sender{
    paused = YES;
    [[CCDirector sharedDirector] pause];
}

-(void)resume:(id)sender{
    [[CCDirector sharedDirector] resume];
    paused = NO;
}

-(void)appWillResignActive:(NSNotification*)note
{
    NSLog(@"App went into the background.");
    paused = YES;
}
-(void)appWillTerminate:(NSNotification*)note
{
    [timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    
}
-(void)applicationDidBecomeActive:(NSNotification*)note{
    NSLog(@"App came back.");
    paused = NO;
}

@end
