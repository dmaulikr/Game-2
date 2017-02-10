//
//  HudNode.m
//  Game
//
//  Created by One on 11/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import "HudNode.h"
#import "Util.h"

@implementation HudNode

+ (instancetype) hudAtPosition: (CGPoint) position inFrame: (CGRect) frame{
    
    HudNode *hud = [self node];
    hud.position = position;
    hud.name = @"HUD";
    // чтобы лежал на переднем front layer
    hud.zPosition = 10;
    SKSpriteNode *heroHead = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_hero_1"];
    heroHead.position = CGPointMake(30, -10);
    [hud addChild:heroHead];
    
    // количество жизней из Util файла.
    hud.lives = maxLives;
    
    SKSpriteNode *lastLifeBar;
    
    for (int i = 0; i < hud.lives; i++) {
        SKSpriteNode *lifeBar = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_life_1"];
        lifeBar.name = [NSString stringWithFormat:@"Life%d", i+1];
        [hud addChild:lifeBar];
        
        // расположение Life Nodes на экране.
        if (lastLifeBar == nil) {
            lifeBar.position = CGPointMake(heroHead.position.x + 30, heroHead.position.y);
        } else {
            lifeBar.position = CGPointMake(lastLifeBar.position.x + 10, lastLifeBar.position.y);
        }
        lastLifeBar = lifeBar;
    }
    
    // настройка Score label
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    scoreLabel.name = @"Score";
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 24;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    scoreLabel.position = CGPointMake(frame.size.width - 20, -10);
    [hud addChild:scoreLabel];
    
    return hud;
    
}

- (void) addPoints: (NSInteger) points {
    
    // updating score
    self.score += points;
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:@"Score"];
    scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
    
}

- (BOOL) loseLife {
    // удаление Life Node с экрана и понижение его количества
    if (self.lives > 0) {
        NSString *lifeNodeName = [NSString stringWithFormat:@"Life%ld", self.lives];
        SKNode *lifeToRemove = [self childNodeWithName:lifeNodeName];
        [lifeToRemove removeFromParent];
        self.lives--;
    }
    
    // если lives != 0, значит они остались. Иначе - нет.
    return self.lives == 0;
}

@end
