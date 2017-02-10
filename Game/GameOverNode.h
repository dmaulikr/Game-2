//
//  GameOverNode.h
//  Game
//
//  Created by One on 11/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverNode : SKNode

+ (instancetype) gameOverAtPosition: (CGPoint) position;

- (void) performAnimation: (NSInteger) highScore;

@end
