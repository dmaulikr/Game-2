//
//  GameOverNode.m
//  Game
//
//  Created by One on 11/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import "GameOverNode.h"

@implementation GameOverNode

+ (instancetype) gameOverAtPosition: (CGPoint) position {
    
    // Настройка надписи GameOver
    GameOverNode *gameOver = [self node];
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    gameOverLabel.name = @"GameOver";
    gameOverLabel.text = @"Game Over";
    gameOverLabel.fontSize = 48;
    gameOverLabel.position = position;
    [gameOver addChild:gameOverLabel];
    
    return gameOver;
}

- (void) performAnimation: (NSInteger) highScore {
    SKLabelNode *label = (SKLabelNode *)[self childNodeWithName:@"GameOver"];
    label.xScale = 0;
    label.yScale = 0;
    
    SKAction *scaleUp = [SKAction scaleTo:1.2f duration:0.55f];
    SKAction *scaleDown = [SKAction scaleTo:0.9f duration:0.25f];
    
    SKAction *run = [SKAction runBlock:^{
        SKLabelNode *touchToRestart = [SKLabelNode labelNodeWithFontNamed:@"Futura-Medium"];
        touchToRestart.text = @"Touch to Restart";
        touchToRestart.fontSize = 18;
        touchToRestart.position = CGPointMake(label.position.x, label.position.y - 90);
        [self addChild:touchToRestart];
        
        SKLabelNode *score = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        score.text = [NSString stringWithFormat:@"Highscore: %ld", highScore];
        score.fontSize = 18;
        score.position = CGPointMake(label.position.x, label.position.y - 45);
        [self addChild:score];
    }];
    
    
    SKAction *scaleSequence = [SKAction sequence:@[scaleUp, scaleDown, run]];
    [label runAction:scaleSequence];
}

@end
