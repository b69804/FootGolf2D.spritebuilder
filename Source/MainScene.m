#import "MainScene.h"
#import "cocos2d.h"
#import "CCPhysicsNode.h"


@implementation MainScene 
{
    CCButton *startGame;
    CCButton *nextLevel;
    BOOL remove;
}


-(void)startGame:(id)sender{
    
    NSLog(@"Button Pressed.");
    
    CCScene *firstLevel = [CCBReader loadAsScene:@"Level1"];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"CheerStart.wav"];

    [[CCDirector sharedDirector] replaceScene:firstLevel];
    
}


@end
