//
//  TutorialScene.m
//  Game
//
//  Created by One on 15/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import "TutorialScene.h"
#import "ActionScene.h"
#import <AVFoundation/AVFoundation.h>

// для музыки и звука
@interface TutorialScene ()
@property (nonatomic) SKAction *pressStartSFX;

@end

@implementation TutorialScene

- (void)didMoveToView:(SKView *)view {
    
    // добавление поясняющего изображения к игре.
    SKSpriteNode *tutorial = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial"];
    tutorial.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:tutorial];
    
    self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ActionScene *actionScene = [ActionScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    
    // воспроизведение звука, остановка музыки
    [self runAction:self.pressStartSFX];
    
    // переход к следующей Scene
    [self.view presentScene:actionScene transition:transition];
}

@end
