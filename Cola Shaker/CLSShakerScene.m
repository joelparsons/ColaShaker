//
//  CLSShakerScene.m
//  Cola Shaker
//
//  Created by Joel Parsons on 23/10/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

@import CoreMotion;
#import "CLSShakerScene.h"
#import "CLSCanSprite.h"
#import "CLSKickScene.h"

@interface CLSShakerScene ()
<SKPhysicsContactDelegate>

@property (nonatomic, strong) CMMotionManager * motionManager;

@property (nonatomic) NSInteger gameCountInTimer;

@property (nonatomic, getter = isGameStarted) BOOL gameStarted;
@property (nonatomic, getter = isGameEnded) BOOL gameEnded;
@property (nonatomic, strong) SKLabelNode * timerLabel;
@property (nonatomic) NSTimeInterval countdownStartTime;
@end

@implementation CLSShakerScene

static uint32_t kCanContactBitmask = 1;
#define kGAME_LENGTH 10.0

-(instancetype)initWithSize:(CGSize)size{

    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        [self loadCan];
        self.can.physicsBody.contactTestBitMask = kCanContactBitmask;

        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.contactTestBitMask = kCanContactBitmask;

        self.physicsWorld.contactDelegate = self;

        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = 1.0/60.0;

        self.timerLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        [self addChild:self.timerLabel];

        CGFloat yPosition = CGRectGetMaxY(self.frame) - 40;
        self.timerLabel.position = CGPointMake(CGRectGetMidX(self.frame), yPosition);
        self.timerLabel.text = @"10.00";

        [self showCountInTimer];
    }
    return self;
}


#pragma mark - SKScene

-(void)update:(NSTimeInterval)currentTime{
    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
    self.physicsWorld.gravity = CGVectorMake(acceleration.x * 10.0 * 20.0, acceleration.y * 10.0* 20.0);

    if (self.isGameStarted && self.countdownStartTime == 0) {
        self.countdownStartTime = currentTime;
    }

    if (self.isGameStarted) {
        NSTimeInterval timeElapsed = currentTime - self.countdownStartTime;
        NSTimeInterval countdownTime = kGAME_LENGTH - timeElapsed;
        if (countdownTime > 0) {
            self.timerLabel.text = [NSString stringWithFormat:@"%.2f",countdownTime];
        }
        else if (self.isGameEnded == NO){
            self.timerLabel.text = @"0.00";
            self.gameEnded = YES;
            [self.gameDelegate clsGameSceneDidFinish:self];
        }
    }
}

-(void)didEvaluateActions{

}

-(void)didSimulatePhysics{

}

-(void)didMoveToView:(SKView *)view{
    [self.motionManager startAccelerometerUpdates];
}

-(void)willMoveFromView:(SKView *)view{
    [self.motionManager stopAccelerometerUpdates];
}

#pragma mark - CLShakerScene
#pragma mark loading

-(void)loadCan{
    self.can = [CLSCanSprite node];
    CGPoint position =CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.can.position = position;
    [self.can.physicsBody applyAngularImpulse:0.2 * M_PI];
    [self addChild:self.can];

}

-(void)showCountInTimer{
    self.gameCountInTimer = 3;

    SKLabelNode * labelNode = [[SKLabelNode alloc] initWithFontNamed:@"Avenir Next Condensed Heavy"];
    labelNode.fontSize = 200;
    labelNode.fontColor = [UIColor lightGrayColor];
    labelNode.text = [NSString stringWithFormat:@"%ld",(long)self.gameCountInTimer];
    labelNode.alpha = 1.0;
    labelNode.position = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);

    [self addChild:labelNode];

    SKAction * fadeIn = [SKAction fadeInWithDuration:0.3];
    SKAction * wait = [SKAction waitForDuration:0.4];
    SKAction * fadeOut = [SKAction fadeOutWithDuration:0.3];
    SKAction * changeLabel = [SKAction runBlock:^{
        self.gameCountInTimer --;
        if (self.gameCountInTimer < 0) {
            [self startGame];
        }

        if (self.gameCountInTimer == 0) {
            labelNode.fontSize = 60;
            labelNode.text = @"SHAKE!";
        }
        else{
            labelNode.text = [NSString stringWithFormat:@"%ld",(long)self.gameCountInTimer];
        }
    }];

    NSMutableArray * countInActions = [NSMutableArray array];

    for (NSInteger i = self.gameCountInTimer; i >= 0; i--){
        [countInActions addObjectsFromArray:@[fadeIn, wait, fadeOut, changeLabel]];
    }
    [countInActions addObject:[SKAction removeFromParent]];
    [labelNode runAction:[SKAction sequence:countInActions]];
}

#pragma mark playing

-(void)startGame{
    self.gameStarted = YES;
}

#pragma mark - SKPhysicsContactDelegate

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if (contact.collisionImpulse < 500000) {
        return;
    }

    if (self.isGameStarted) {
        CGFloat priorDamage = self.damagePoints;
        self.damagePoints += contact.collisionImpulse / 100000;
        if ((floor(self.damagePoints / 700.0) - floor(priorDamage / 700.0)) >= 1) {
            [self.can dent];
        }
    }
}

@end
