//
//  MachineNode.m
//  Game
//
//  Created by One on 08/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import "MachineNode.h"

@implementation MachineNode

+ (instancetype) machineAtPosition: (CGPoint) position {
    MachineNode *machine = [self spriteNodeWithImageNamed:@"machine_1"];
    machine.position = position;
    machine.zPosition = 8; // чтобы находилась за героем
    machine.name = @"Machine";
    machine.anchorPoint = CGPointMake(0.5, 0);
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"machine_1"],
                           [SKTexture textureWithImageNamed:@"machine_2"]];
    
    SKAction *machineAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    SKAction *machineRepeat = [SKAction repeatActionForever:machineAnimation];
    [machine runAction:machineRepeat];
    
    return machine;
}

@end
