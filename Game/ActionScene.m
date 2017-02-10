//
//  ActionScene.m
//  Game
//
//  Created by One on 07/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import "ActionScene.h"
#import "MachineNode.h"
#import "HeroNode.h"
#import "ProjectileNode.h"
#import "EnemyNode.h"
#import "GroundNode.h"
#import "Util.h"
#import <AVFoundation/AVFoundation.h>
#import "HudNode.h"
#import "GameOverNode.h"

@interface ActionScene ()

// чтобы знать сколько времени прошло между циклом game run loop
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
// чтобы знать когда добавить нового enemy
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;

// для увеличения сложности
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) NSInteger maxSpeed;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;

// background музыка
@property (nonatomic) AVAudioPlayer *backgroundMusic;
@property (nonatomic) AVAudioPlayer *gameOverMusic;

// звуковые эффекты
@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *explodeSFX;
@property (nonatomic) SKAction *laserSFX;

// for GameOver scenario
@property (nonatomic) BOOL gameOver;
@property (nonatomic) BOOL restart;
@property (nonatomic) BOOL gameOverDisplayed;

@end

// сохранение HighScore
static NSString *kSettingsScore = @"HighScore";

@implementation ActionScene

- (void)didMoveToView:(SKView *)view {
    
    [self loadHighScore];
    
    // для обновления подсчёта времени
    self.lastUpdateTimeInterval = 0;
    self.timeSinceEnemyAdded = 0;
    
    // для установки сложности
    self.totalGameTime = 0;
    self.minSpeed = enemyMinSpeed;
    self.maxSpeed = enemyMaxSpeed;
    self.addEnemyTimeInterval = 1.25;
    
    // для Game Over
    self.gameOver = NO;
    self.restart = NO;
    self.gameOverDisplayed = NO;
    
    // расположение основных Nodes на сцене: background, hero, machine, HUD, ground
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
    
    HeroNode *hero = [HeroNode heroAtPosition:CGPointMake(CGRectGetMidX(self.frame), 10)];
    [self addChild:hero];
    
    MachineNode *machine = [MachineNode machineAtPosition: CGPointMake(CGRectGetMidX(self.frame), 12)];
    [self addChild:machine];
    
    HudNode *hud = [HudNode hudAtPosition:CGPointMake(0, self.frame.size.height - 20) inFrame:self.frame];
    [self addChild:hud];
    
    GroundNode *ground = [GroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
    [self addChild:ground];
    
    // настройка гравитации
    self.physicsWorld.gravity = CGVectorMake(0, -9.8);
    
    // delegate контакта с физическим мира=ом
    self.physicsWorld.contactDelegate = self;

    [self setupSounds];
    [self.backgroundMusic play];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *firstBody, *secondBody;
    
    // проверка если category bitmask тела bodyA меньше, чем тела bodyB (как в классе Util <<), т.к. они всегда будут в особом порядке.
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // здесь мы уверены, что первое тело это enemy, а второе - снаряд. Projectile hits enemy.
    if (firstBody.categoryBitMask == CollisionCategoryEnemy && secondBody.categoryBitMask == CollisionCategoryProjectile) {
        
        EnemyNode *enemy = (EnemyNode *)firstBody.node;
        ProjectileNode *projectile = (ProjectileNode *)secondBody.node;
        
        // добавление очков из константы класса Util, когда в противника попадает снаряд.
        [self addPoints: pointsPerHit];
        
        // звук
        [self runAction:self.explodeSFX];
        
        // удаление со сцены после столкновения
        [enemy removeFromParent];
        [projectile removeFromParent];
        
    // если враг падает на землю
    } else if (firstBody.categoryBitMask == CollisionCategoryEnemy && secondBody.categoryBitMask == CollisionCategoryGround) {
        
        [self runAction:self.damageSFX];
        
        // удаление со сцены
        EnemyNode *enemy = (EnemyNode *)firstBody.node;
        [enemy removeFromParent];
        
        [self loseLife];
    }
    // создание разлетающихся осколков
    [self createGarbageAtPosition:contact.contactPoint];
}

- (void) setupSounds {
    
    // нахождение музыкального файла в mainBundle
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1; // чтобы зациклить проигрывание
    // загрузка файла из URL и подготовка к проигрыванию.
    [self.backgroundMusic prepareToPlay];
    
    // то же самое для музыки GameOver
    NSURL *gameOverURL = [[NSBundle mainBundle] URLForResource:@"GameOver" withExtension:@"mp3"];
    self.gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:gameOverURL error:nil];
    self.gameOverMusic.numberOfLoops = 0;
    [self.gameOverMusic prepareToPlay];
    
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
    self.laserSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // если жизни ещё остались и это не сценарий GameOver
    if (!self.gameOver) {
    // доступ к точке, где пользователь коснулся экрана
        for (UITouch *touch in touches) {
            // получение координат касания в текущей Scene. Возвращает (х,у)
            CGPoint position = [touch locationInNode:self];
            [self shootProjectileTowardsThePosition:position];
        }
        
    // если нажатие осуществилось в момент GameOver
    } else if (self.restart) {
        // удаляем все Nodes
        for (SKNode *node in [self children]) {
            [node removeFromParent];
        }
        // перезагружаем Scene.
        ActionScene *scene = [ActionScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
}

- (void) performGameOver {
    // добавление надписи GameOver
    GameOverNode *gameOver = [GameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 50)];
    [self addChild:gameOver];
    self.restart = YES;
    self.gameOverDisplayed = YES;
    
    // сравнение highScore с результатами прошлого раза
    HudNode *hud = (HudNode *)[self childNodeWithName:@"HUD"];
    if (hud.score > highScore) {
        highScore = hud.score;
        [self saveHighScore];
    }
    // передача значения highScore на экран GameOver
    [gameOver performAnimation:highScore];
    
    [self.backgroundMusic stop];
    [self.gameOverMusic play];
    
    // отключение UI на пару секунд
    [self.view setUserInteractionEnabled:NO];
    [self performSelector:@selector(activateUI) withObject:nil afterDelay:2.0];
}

- (void) activateUI {
    [self.view setUserInteractionEnabled:YES];
}

    // для Score points
- (void) addPoints: (NSInteger) points {
    HudNode *hud = (HudNode *)[self childNodeWithName:@"HUD"];
    [hud addPoints:points];
    
}

- (void) loseLife {
    HudNode *hud = (HudNode *)[self childNodeWithName:@"HUD"];
    // если жизней больше не осталось - GameOver
    self.gameOver = [hud loseLife];
}

- (void) update:(NSTimeInterval)currentTime {
    if (self.lastUpdateTimeInterval) {
        // сколько секунд прошло с последнего выполненного run loop. Добавление их к property
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }
    
    // сколько времени прошло с того момента, как был добавлен новый enemy
    if (self.timeSinceEnemyAdded > self.addEnemyTimeInterval && !self.gameOver) {
        // добавление enemy
        [self addEnemy];
        self.timeSinceEnemyAdded = 0;
    }
    self.lastUpdateTimeInterval = currentTime;
    
    // Настройка сложности. Настройка интервала времени появления врагов и скорости их движения.
    // в данном случае повышение сложности происходит очень быстро в целях отладки. 
    if (self.totalGameTime > 480) {
        // 480 / 60 = 8 минут игрового времени
        self.addEnemyTimeInterval = 0.5;
        self.minSpeed = -160;
    } else if (self.totalGameTime > 40) {
        self.addEnemyTimeInterval = 0.10;
        self.minSpeed = enemyMinSpeed - 250;
        self.maxSpeed = enemyMaxSpeed - 250;
    } else if (self.totalGameTime > 30) {
        self.addEnemyTimeInterval = 0.25;
        self.minSpeed = enemyMinSpeed - 150;
        self.maxSpeed = enemyMaxSpeed - 150;
    } else if (self.totalGameTime > 20) {
        self.addEnemyTimeInterval = 0.50;
        self.minSpeed = enemyMinSpeed - 70;
        self.maxSpeed = enemyMaxSpeed - 70;
    }
    
    // проверка оставшихся жизней и GameOver
    if (self.gameOver && !self.gameOverDisplayed) {
        [self performGameOver];
    }
    
}

- (void) shootProjectileTowardsThePosition:(CGPoint) position {
    
    // анимация героя
    HeroNode *hero = (HeroNode *)[self childNodeWithName:@"Hero"];
    [hero performTap];
    
    // помещаем снаряд прямо над machine в стартовую позицию
    ProjectileNode *projectile = [ProjectileNode projectileAtPosition:CGPointMake(CGRectGetMidX(self.frame), 75)];
    //MachineNode *machine = (MachineNode*)[self childNodeWithName:@"Machine"];
    //ProjectileNode *projectile = [ProjectileNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y + machine.frame.size.height-15)];
    [self addChild:projectile];
    
    // перемещение снаряда по направлению к координатам касания
    [projectile moveTowardsPosition:position];
    
    [self runAction:self.laserSFX];
}

- (void) addEnemy {
    
    // какого типа противник будет
    NSUInteger randomEnemy = [Util randomWithMin:0 max:2];
    EnemyNode *enemy = [EnemyNode enemyOfType:randomEnemy];
    
    // установка скорости (velocity) противника учитывая min/max показатели сложности
    float dy = [Util randomWithMin:self.minSpeed max:self.maxSpeed];
    enemy.physicsBody.velocity = CGVectorMake(0, dy);
    
    // координаты, в которых появляется противник
    float y = self.frame.size.height + enemy.size.height;
    float x = [Util randomWithMin:10 + enemy.size.width max: self.frame.size.width-enemy.frame.size.width - 10];
    enemy.position = CGPointMake(x, y);
    [self addChild:enemy];
}

- (void) createGarbageAtPosition:(CGPoint) position {
    
    // количество осколков от 10 до 20
    NSInteger numberOfPieces = [Util randomWithMin:10 max:20];
    
    // создание осколков из картинок в .atlas
    for (int i = 0; i < numberOfPieces; i++) {
        NSInteger randomPiece = [Util randomWithMin:1 max:4];
        NSString *imageName = [NSString stringWithFormat:@"debri_%ld", randomPiece];
        
        SKSpriteNode *garbage = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        garbage.position = position;
        [self addChild:garbage];
        
        // настройка физики осколков
        garbage.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:garbage.frame.size];
        garbage.physicsBody.categoryBitMask = CollisionCategoryGarbage;
        garbage.physicsBody.contactTestBitMask = 0;
        garbage.physicsBody.collisionBitMask = CollisionCategoryGround | CollisionCategoryGarbage;
        garbage.name = @"Garbage";
        
        // добавление эффекта взрыва, придавая скорость (velocity) осколкам
        garbage.physicsBody.velocity = CGVectorMake([Util randomWithMin:-150 max:150], [Util randomWithMin:150 max:350]);
        
        // осколки пропадают через 1 секунду после взрыва
        [garbage runAction:[SKAction waitForDuration:1.0] completion:^{
            [garbage removeFromParent];
        }];
    }
    
    // создание взрыва
    NSString *explodePath = [[NSBundle mainBundle] pathForResource:@"Explode" ofType:@"sks"];
    SKEmitterNode *explode = [NSKeyedUnarchiver unarchiveObjectWithFile:explodePath];
    explode.position = position;
    [self addChild:explode];
    [explode runAction:[SKAction waitForDuration:2.0] completion:^{
        [explode removeFromParent];
    }];
}

    // для сохранения и загрузки HighScore
- (void) saveHighScore {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:highScore forKey:kSettingsScore];
    [userDefaults synchronize];
}

- (void) loadHighScore {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    highScore = [userDefaults integerForKey:kSettingsScore];
}


@end
