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

@property (nonatomic, strong) SKLabelNode * damagePointsLabel;
@property (nonatomic) double damagePoints;
@end

@implementation CLSShakerScene

static uint32_t kCanContactBitmask = 1;

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

        self.damagePointsLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        self.damagePointsLabel.position = CGPointMake(CGRectGetMidX(self.frame), 0);
        [self addChild:self.damagePointsLabel];
    }
    return self;
}


#pragma mark - SKScene

-(void)update:(NSTimeInterval)currentTime{
    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
    self.physicsWorld.gravity = CGVectorMake(acceleration.x * 10.0 * 20.0, acceleration.y * 10.0* 20.0);
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
    self.can = [CLSCan node];
    CGPoint position =CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.can.position = position;
    [self.can.physicsBody applyAngularImpulse:0.2 * M_PI];
    [self addChild:self.can];

}

#pragma mark - SKPhysicsContactDelegate

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if (contact.collisionImpulse < 500000) {
        return;
    }
    self.damagePoints += contact.collisionImpulse / 100000;
    self.damagePointsLabel.text = [NSString stringWithFormat:@"%0.2f",self.damagePoints];
}

@end
