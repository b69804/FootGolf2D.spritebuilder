//
//  Instructions.m
//  FootGolf2D
//
//  Created by Matthew Ashton on 1/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Instructions.h"

@implementation Instructions
{
    CCButton *back;
}

-(void)back:(id)sender{

    CCScene *goBack = [CCBReader loadAsScene:@"MainScene"];
    
    [[CCDirector sharedDirector] replaceScene:goBack];

}

@end
