
#import "Level1.h"
#import "cocos2d.h"
#import "CCPhysicsNode.h"

@implementation Level1
{
    CCButton *nextLevel;
}


-(void)angleSlider:(id)sender{
    
    CCSlider *newSLider = sender;
    NSLog(@"%f", newSLider.sliderValue);
    
    float newAngle = newSLider.sliderValue * -180;
    
    _arrow.rotation = newAngle;
}

-(void)onEnter{

    score = 0;
    
    [_par setString:[NSString stringWithFormat:@"%d", score]];
    
    [super onEnter];

}

-(void)hitBall:(id)sender{
    
    int newScore = score++;
    
    [_par setString:[NSString stringWithFormat:@"%d", newScore]];
    
    float betterAngle;
    
    float angleOfArrow = _arrow.rotation;
    NSLog(@"%f", angleOfArrow);
    betterAngle = (angleOfArrow * -1.00);
    NSLog(@"%f", betterAngle);
    CGPoint direction = ccp(sinf(betterAngle), cosf(betterAngle));
    float forceValue = 50;
    CGPoint shootAmount = ccpMult(direction, forceValue);
    [_soccerBall.physicsBody applyImpulse:(shootAmount)];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"SportGolf DM006_62.wav"];
    
    [self update:3.0];
    
}

- (void)update:(CCTime)delta{
    if (_soccerBall.position.x <= 0){
        [_soccerBall removeFromParentAndCleanup:YES];
        _soccerBall = [CCSprite spriteWithImageNamed:@"ImageAssets/BallHD_03.png"];
        _soccerBall.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:6.66 andCenter:CGPointMake(0.5, 0.5)];
        _soccerBall.position = ccp(54.8, 99.7);
        
        [self addChild:_soccerBall];
        [_physicsNode addChild:_soccerBall];
    }
    
    if (_soccerBall.position.x <= 465.0 && _soccerBall.position.y <= 110.0 && _soccerBall.position.x >= 459.0 && _soccerBall.position.y >= 108.0) {
        NSLog(@"Ball is in the hole.");
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

@end
