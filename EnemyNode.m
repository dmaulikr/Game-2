//
//  EnemyNode.m
//  Game
//
//  Created by One on 09/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import "EnemyNode.h"
#import "Util.h"

@implementation EnemyNode

+ (instancetype) enemyOfType: (EnemyType) type {
    
    EnemyNode *enemy;
    
    // текстуры для анимации
    NSArray *textures;
    
    // какого типа будет враг
    if (type == EnemyTypeA) {
        enemy = [self spriteNodeWithImageNamed:@"enemy_A_1"];
        textures = @[[SKTexture textureWithImageNamed:@"enemy_A_1"],
                     [SKTexture textureWithImageNamed:@"enemy_A_2"],
                     ];
        
    } else {
        enemy = [self spriteNodeWithImageNamed:@"enemy_B_1"];
        textures = @[[SKTexture textureWithImageNamed:@"enemy_B_1"],
                     [SKTexture textureWithImageNamed:@"enemy_B_2"],
                     [SKTexture textureWithImageNamed:@"enemy_B_3"],
                     ];
    }
    
    // random размер противника
    float scale = [Util randomWithMin:85 max:100] / 100.f;
    enemy.xScale = scale;
    enemy.yScale = scale;
    
    // применение покадровой анимации
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    [enemy runAction:[SKAction repeatActionForever:animation]];
    [enemy setupPhysicsBody];
    return enemy;
}

- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    // враг неподвластен гравитации
    self.physicsBody.affectedByGravity = NO;
    
    // какой кадегории принадлежит противник (physics mask)
    // с кем он будет collide, а с кем contact.
    self.physicsBody.categoryBitMask = CollisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0; // not colliding the enemy with anything
    self.physicsBody.contactTestBitMask = CollisionCategoryProjectile | CollisionCategoryGround; // or 0010 | 1000 = 1010
}

@end
