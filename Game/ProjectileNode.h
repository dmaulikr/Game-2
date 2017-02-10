//
//  ProjectileNode.h
//  Game
//
//  Created by One on 08/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ProjectileNode : SKSpriteNode

+ (instancetype) projectileAtPosition: (CGPoint) position;
- (void) moveTowardsPosition: (CGPoint) position;

@end
