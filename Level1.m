
#import "Level1.h"
#import "cocos2d.h"
#import "CCPhysicsNode.h"

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
    
    timeSec = 0;
    timeMin = 0;
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
    
    //[self changeScore];
    
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

// I have no idea why this stops updating after it gets to 2!
/*-(void)changeScore{
    if (score == 0){
        [_par setString:[NSString stringWithFormat:@"1"]];
        score = 1;
    } else {
        int newScore = (score + 1);
        NSLog(@"%d", newScore);
        [_par setString:[NSString stringWithFormat:@"%d", newScore]];
    }
}*/

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
        [_physicsNode addChild:_soccerBall];
    }
    
    
    
    // Once I get the physics worked out, this will identify if the is in the cup.  I will then transition the scene to the next level
    if (_soccerBall.position.x <= 470.0 && _soccerBall.position.y <= 118.0 && _soccerBall.position.x >= 457.0 && _soccerBall.position.y >= 108.0) {
        NSLog(@"Ball is in the hole.");
        
        [[OALSimpleAudio sharedInstance] playEffect:@"Applause.wav"];
        
        id transition = [CCTransition transitionFadeWithDuration:3.0];
        
        CCScene *secondLevel = [CCBReader loadAsScene:@"Level2"];
        [[CCDirector sharedDirector] replaceScene:secondLevel withTransition:transition];
        [_soccerBall removeFromParent];
    }
    
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
        timeSec++;
        if (timeSec == 90)
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
    if (buttonIndex == 0)
    {
        CCScene *firstLevel = [CCBReader loadAsScene:@"Level1"];
        [[CCDirector sharedDirector] replaceScene:firstLevel];
    }
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
