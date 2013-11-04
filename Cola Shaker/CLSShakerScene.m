//
//  CLSShakerScene.m
//  Cola Shaker
//
//  Created by Joel Parsons on 23/10/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

@import CoreMotion;
#import "CLSShakerScene.h"
#import "CLSCan.h"

@interface CLSShakerScene ()
<SKPhysicsContactDelegate>

@property (nonatomic, strong) CLSCan * can;
@property (nonatomic, strong) CMMotionManager * motionManager;

@property (nonatomic) double damagePoints;

@property (nonatomic, getter = isGameStarted) BOOL gameStarted;
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

        CGFloat yPosition = CGRectGetMaxY(self.frame) - 60;
        self.timerLabel.position = CGPointMake(CGRectGetMidX(self.frame), yPosition);
        self.timerLabel.text = @"10.00";
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

    if (self.countdownStartTime > 0) {
        NSTimeInterval timeElapsed = currentTime - self.countdownStartTime;
        NSTimeInterval countdownTime = kGAME_LENGTH - timeElapsed;
        self.timerLabel.text = [NSString stringWithFormat:@"%.2f",countdownTime];
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

#pragma mark - UIResponder

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.countdownStartTime == 0) {
        [self startGame];
    }
}

#pragma mark - CLShakerScene
#pragma mark loading

-(void)loadCan{
    self.can = [CLSCan node];
    CGPoint position =CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.can.position = position;
    [self.can.physicsBody applyAngularImpulse:0.2 * M_PI];
    [self addChild:self.can];

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

    CGFloat priorDamage = self.damagePoints;
    self.damagePoints += contact.collisionImpulse / 100000;
    if ((floor(self.damagePoints / 700.0) - floor(priorDamage / 700.0)) >= 1) {
        [self.can dent];
    }
}

@end
