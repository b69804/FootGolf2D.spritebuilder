#import "MainScene.h"
#import "cocos2d.h"
#import "CCPhysicsNode.h"
#import "LocalLeaderBoard.h"
#import <GameKit/GameKit.h>



@implementation MainScene
{
    CCButton *startGame;
    CCButton *nextLevel;
    CCButton *instructions;
    BOOL remove;
}

-(void)onEnter
{

    [self authenticateLocalPlayer];
    
    [super onEnter];
}

-(void)startGame:(id)sender{
    
    NSLog(@"Button Pressed.");
    
    CCScene *firstLevel = [CCBReader loadAsScene:@"Level1"];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"CheerStart.wav"];

    [[CCDirector sharedDirector] replaceScene:firstLevel];
    
}

-(void)showLeaderBoard:(id)sender{
    
    _leaderboardIdentifier = @"Level1";
    
    GKLeaderboardViewController *gcViewController = [[GKLeaderboardViewController alloc] init];
    //gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gcViewController.gameCenterDelegate = self;
    gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    
    
    
    [[CCDirector sharedDirector] presentViewController:gcViewController animated:YES completion:nil];

}

-(void)instructions:(id)sender{

    CCScene *instruct = [CCBReader loadAsScene:@"Instructions"];

    [[CCDirector sharedDirector] replaceScene:instruct];
}

-(void)showCredits:(id)sender{

    CCScene *cred = [CCBReader loadAsScene:@"Level2"];
    
    [[CCDirector sharedDirector] replaceScene:cred];

}

-(void)showLocalLBoard:(id)sender
{
    LocalLeaderBoard *lVC = [[LocalLeaderBoard alloc] init];
    [[CCDirector sharedDirector] presentViewController:lVC animated:YES completion:nil];
}

-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [[CCDirector sharedDirector] presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}

-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
