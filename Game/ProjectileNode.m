//
//  ProjectileNode.m
//  Game
//
//  Created by One on 08/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import "ProjectileNode.h"
#import "Util.h"

@implementation ProjectileNode

+ (instancetype) projectileAtPosition: (CGPoint) position {
    
    ProjectileNode *projectile = [self spriteNodeWithImageNamed:@"projectile_1"];
    projectile.position = position;
    // для возможности доступа из другого класса ActionScene
    projectile.name = @"Projectile";
    
    // анимация
    [projectile setupAnimations];
    [projectile setupPhysicsBody];
    return projectile;
}

- (void) setupAnimations {
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"projectile_1"], [SKTexture textureWithImageNamed:@"projectile_2"], [SKTexture textureWithImageNamed:@"projectile_3"]];
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *repeatAction = [SKAction repeatActionForever:animation];
    [self runAction:repeatAction];
}

- (void) setupPhysicsBody {
    // установка размеров physics body
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    
    // какой категории принадлежит враг (physics mask)
    // с кем будет contact, а с кем collide
    self.physicsBody.categoryBitMask = CollisionCategoryProjectile;
    self.physicsBody.collisionBitMask = 0; // not colliding with anything
    self.physicsBody.contactTestBitMask = CollisionCategoryEnemy;
    
}

    // Движение снаряда в сторону Tap
- (void) moveTowardsPosition: (CGPoint) position {
    // "position" это место, с координатами касания пользователя
    // "self.position" это позиция снаряда (projectile)
    // Высчитывание slope (наклона) = (y3 - y1) / (x3 - x1)
    float slope = (position.y - self.position.y) / (position.x - self.position.x);
    
    // поиск координат третьей точки линии, точка которая находится за пределами экрана
    // slope = (y2 - y1) / (x2 - x1); x2 будет -10 за экраном.
    // y2 - y1 = slope (x2 - x1);
    // y2 = slope*x2 - slope*x1 + y1
    float offscreenX;
    if (position.x <= self.position.x) { //значит, что касание в левой части экрана
        offscreenX = -10;
    } else {
        offscreenX = self.parent.frame.size.width + 10;
    }
    // как расчитывалось выше
    float offscreenY = slope * offscreenX - slope * self.position.x + self.position.y;
    
    CGPoint pointOffScreen = CGPointMake(offscreenX, offscreenY);
    
    // расчёт дистанции - длина гиппотенузы. (по т. Пифагора)
    float distanceA = pointOffScreen.y - self.position.y;
    float distanceB = pointOffScreen.x - self.position.x;
    float distanceC = sqrtf(powf(distanceA, 2) + powf(distanceB, 2));
    
    // S = V * t, t = S/V
    float time = distanceC / ProjectileSpeed; //  is a constant from Constants.h file
    // придание эффекта Fade снаряду
    float waitToFade = time * 0.75; // после 3/4 времени начинается Fade
    float fadeTime = time - waitToFade;
    
    SKAction *moveProjectile = [SKAction moveTo:pointOffScreen duration:time];
    [self runAction:moveProjectile];
    
    // Действия могут быть совершены в последовательности (sequence). Одно за другим.
    // в данном случае, 3/4 это ожидание перед Fade, потом Fade, потом удаление Node со сцены
    NSArray *sequence = @[[SKAction waitForDuration:waitToFade],
                          [SKAction fadeOutWithDuration:fadeTime],
                          [SKAction removeFromParent]];
    // выполнение последовательности Sequence
    [self runAction:[SKAction sequence:sequence]];
    
}

@end
