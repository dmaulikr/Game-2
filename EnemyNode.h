//
//  EnemyNode.h
//  Game
//
//  Created by One on 09/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

// каким типом противника будет являться враг
typedef NS_ENUM(NSUInteger, EnemyType) {
    EnemyTypeA = 0,
    EnemyTypeB = 1
};


@interface EnemyNode : SKSpriteNode

+ (instancetype) enemyOfType: (EnemyType) type;

@end
