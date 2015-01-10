
#import "Level1.h"

@implementation Level1
{
    CCButton *nextLevel;
}

-(void)nextLevel:(id)sender{
    
    NSLog(@"Button Pressed again.");
    
    id transition = [CCTransition transitionFadeWithDuration:2.0];
    
    CCScene *secondLevel = [CCBReader loadAsScene:@"Level2"];
    [[CCDirector sharedDirector] replaceScene:secondLevel withTransition:transition];
    
}

@end
