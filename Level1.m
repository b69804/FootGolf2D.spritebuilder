
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
    
    [self changeScore];
    
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
-(void)changeScore{
    if (score == 0){
        [_par setString:[NSString stringWithFormat:@"1"]];
        score = 1;
    } else {
        int newScore = (score + 1);
        NSLog(@"%d", newScore);
        [_par setString:[NSString stringWithFormat:@"%d", newScore]];
    }
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

-(void)nextLevel:(id)sender{
    
    NSLog(@"Button Pressed again.");
    
    [[OALSimpleAudio sharedInstance] playEffect:@"Applause.wav"];
    
    id transition = [CCTransition transitionFadeWithDuration:2.0];
    
    CCScene *secondLevel = [CCBReader loadAsScene:@"Level2"];
    [[CCDirector sharedDirector] replaceScene:secondLevel withTransition:transition];
    
}

-(void)pause:(id)sender{
    [[CCDirector sharedDirector] pause];
}

-(void)resume:(id)sender{
    [[CCDirector sharedDirector] resume];
}

@end
