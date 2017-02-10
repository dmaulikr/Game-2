//
//  Util.h
//  Game
//
//  Created by One on 09/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import <Foundation/Foundation.h>

// определяет скорость передвижения снаряда
static const int ProjectileSpeed = 400;

// определяет базовую скорость движения противника
static const int enemyMinSpeed = -100;
static const int enemyMaxSpeed = -50;

// определяет стандартное количество жизней
static const int maxLives = 3;

// количество очков, добавляющихся за уничтожение противника
static const int pointsPerHit = 125;

// для highScore
static long highScore = 0;

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryEnemy      = 1 << 0,   // 0000
    CollisionCategoryProjectile = 1 << 1,   // 0010
    CollisionCategoryGarbage    = 1 << 2,   // 0100
    CollisionCategoryGround     = 1 << 3    // 1000
};


@interface Util : NSObject

+ (NSInteger) randomWithMin: (NSInteger) min max:(NSInteger) max;

@end
