//
//  GroundNode.m
//  Game
//
//  Created by One on 10/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import "GroundNode.h"
#import "Util.h"

@implementation GroundNode

+ (instancetype) groundWithSize: (CGSize) size {
    
    GroundNode *ground = [self spriteNodeWithColor:[SKColor clearColor] size:size];
    ground.name = @"Ground";
    ground.position = CGPointMake(size.width / 2, size.height / 2);
    [ground setupPhysicsBody];
    return ground;
}

- (void) setupPhysicsBody {
    // simple body
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    
    // не подвластно гравитации в данной Scene
    self.physicsBody.affectedByGravity = NO;
    // вне влияния и передвижения посторонними объектами или физическим взаимодействием
    self.physicsBody.dynamic = NO;
    
    // какой категории groundNode принадлежит (physics mask)
    // с каким будет collide, а с каким contact.
    self.physicsBody.categoryBitMask = CollisionCategoryGround;
    self.physicsBody.collisionBitMask = CollisionCategoryGarbage;
    self.physicsBody.contactTestBitMask = CollisionCategoryEnemy;
}

@end
