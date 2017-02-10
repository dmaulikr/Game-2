//
//  HeroNode.m
//  Game
//
//  Created by One on 08/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import "HeroNode.h"

@interface HeroNode ()
@property (nonatomic, strong) SKAction *tapAction;
@end

@implementation HeroNode

+ (instancetype) heroAtPosition: (CGPoint) position {
    
    HeroNode *hero = [self spriteNodeWithImageNamed:@"hero_1"];
    hero.position = position;
    hero.zPosition = 9;
    hero.anchorPoint = CGPointMake(0.5, 0);
    // чтобы иметь возможность получить доступ из другого класса ActionScene
    hero.name = @"Hero";
    return hero;
}

- (void) performTap {
    [self runAction:self.tapAction];
}

- (SKAction *) tapAction {
    // значит был проинициализирован
    if (_tapAction != nil) {
        return _tapAction;
    }
    // если не был проинициализирован, применяем анимацию
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"hero_2"], [SKTexture textureWithImageNamed:@"hero_1"]];
    _tapAction = [SKAction animateWithTextures:textures timePerFrame:0.25];
    return _tapAction;
}

@end
