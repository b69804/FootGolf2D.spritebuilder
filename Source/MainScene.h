#import <GameKit/GameKit.h>

@interface MainScene : CCNode <CCPhysicsCollisionDelegate, GKGameCenterControllerDelegate, GKLeaderboardViewControllerDelegate>

@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic, strong) NSString *leaderboardIdentifier;

-(void)authenticateLocalPlayer;

@end
