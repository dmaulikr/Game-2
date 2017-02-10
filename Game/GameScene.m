//
//  GameScene.m
//  Game
//
//  Created by One on 07/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import "GameScene.h"
#import "ActionScene.h"
#import "TutorialScene.h"
#import <AVFoundation/AVFoundation.h>

// для музыки и звука
@interface GameScene ()
@property (nonatomic) SKAction *pressStartSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;

@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view {

    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splash"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
    
    // настройка звука
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"StartScreen" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1; // to repeat forever
    // загрузка из URL, подготовка, проигрывание
    [self.backgroundMusic prepareToPlay];
    [self.backgroundMusic play];
    
    self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    TutorialScene *tutorialScene = [TutorialScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    
    // воспроизведение звука, остановка музыки
    [self runAction:self.pressStartSFX];
    [self.backgroundMusic stop];
    
    // переход к следующей Scene
    [self.view presentScene:tutorialScene transition:transition];
}

@end
