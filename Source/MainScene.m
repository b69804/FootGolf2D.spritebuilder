#import "MainScene.h"
#import "cocos2d.h"
#import "CCPhysicsNode.h"


@implementation MainScene 
{
    CCButton *startGame;
    CCButton *nextLevel;
    CCButton *instructions;
    BOOL remove;
}


-(void)startGame:(id)sender{
    
    NSLog(@"Button Pressed.");
    
    CCScene *firstLevel = [CCBReader loadAsScene:@"Level1"];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"CheerStart.wav"];

    [[CCDirector sharedDirector] replaceScene:firstLevel];
    
}

-(void)instructions:(id)sender{

    CCScene *instruct = [CCBReader loadAsScene:@"Instructions"];

    [[CCDirector sharedDirector] replaceScene:instruct];
}

-(void)showCredits:(id)sender{

    CCScene *cred = [CCBReader loadAsScene:@"Level2"];
    
    [[CCDirector sharedDirector] replaceScene:cred];

}


@end
