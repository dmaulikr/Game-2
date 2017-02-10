//
//  HudNode.h
//  Game
//
//  Created by One on 11/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HudNode : SKNode

@property (nonatomic) NSInteger lives;
@property (nonatomic) NSInteger score;

+ (instancetype) hudAtPosition: (CGPoint) position inFrame: (CGRect) frame;

- (void) addPoints: (NSInteger) points;
- (BOOL) loseLife;

@end
