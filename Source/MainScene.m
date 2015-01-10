#import "MainScene.h"


@implementation MainScene
{
    CCButton *startGame;
    CCButton *nextLevel;
}

-(void)startGame:(id)sender{
    
    NSLog(@"Button Pressed.");
    
    CCScene *firstLevel = [CCBReader loadAsScene:@"Level1"];

    [[CCDirector sharedDirector] replaceScene:firstLevel];
    
}

-(void)nextLevel:(id)sender{
    
    NSLog(@"Button Pressed again.");
    
    id transition = [CCTransition transitionFadeWithDuration:2.0];
    
    CCScene *secondLevel = [CCBReader loadAsScene:@"Level2"];
    [[CCDirector sharedDirector] replaceScene:secondLevel withTransition:transition];
    
}


@end
