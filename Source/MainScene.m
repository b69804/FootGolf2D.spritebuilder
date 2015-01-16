#import "MainScene.h"
#import "cocos2d.h"
#import "CCPhysicsNode.h"


@implementation MainScene 
{
    CCButton *startGame;
    CCButton *nextLevel;
}


-(void)startGame:(id)sender{
    
    NSLog(@"Button Pressed.");
    
    _physicsNode.collisionDelegate = self;
    
    CCScene *firstLevel = [CCBReader loadAsScene:@"Level1"];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"CheerStart.wav"];

    [[CCDirector sharedDirector] replaceScene:firstLevel];
    
}

-(void)nextLevel:(id)sender{
    
    NSLog(@"Button Pressed again.");
    
    [[OALSimpleAudio sharedInstance] playEffect:@"Applause.wav"];
    
    id transition = [CCTransition transitionFadeWithDuration:2.0];
    
    CCScene *secondLevel = [CCBReader loadAsScene:@"Level2"];
    [[CCDirector sharedDirector] replaceScene:secondLevel withTransition:transition];
    
}



-(void)hitBall:(id)sender{
    
    float betterAngle;
    
    float angleOfArrow = _arrow.rotation;
    NSLog(@"%f", angleOfArrow);
    if (angleOfArrow > -90.0){
        betterAngle = (angleOfArrow * -1.00);
    } else {
        betterAngle = (angleOfArrow * 1.00);
    }
    NSLog(@"%f", betterAngle);
    
    CGPoint direction = ccp(sinf(45), cosf(45));
    //CGPoint offSet = ccpMult(direction, 50);
    [_physicsNode addChild:_soccerBall];
    CGPoint force = ccpMult(direction, 2000);
    
    [_soccerBall.physicsBody applyForce:force];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"SportGolf DM006_62.wav"];
    
}

- (BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair ball:(CCNode *)_soccerBall tree:(CCNode *)thisIsATree
{
    NSLog(@"Ball hit tree");
    return YES;
}


@end
