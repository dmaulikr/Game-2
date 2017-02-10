//
//  HeroNode.h
//  Game
//
//  Created by One on 08/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HeroNode : SKSpriteNode

+ (instancetype) heroAtPosition: (CGPoint) position;
- (void) performTap;

@end
