//
//  CLSKickScene.m
//  Cola Shaker
//
//  Created by Joel Parsons on 29/10/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

#import "CLSKickScene.h"
#import "CLSCan.h"
#import "CLSKickCanSprite.h"
#import "CLSKickCameraNode.h"

@interface CLSKickScene ()
<SKPhysicsContactDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer * panGestureRecognizer;

@property (nonatomic, strong) CLSKickCameraNode * cameraNode;
@property (nonatomic, strong) CLSKickCanSprite * can;
@property (nonatomic, strong) SKEmitterNode * foamNode;

@property (nonatomic) NSTimeInterval lastUpdateTime;

@property (nonatomic, getter = hasKicked) BOOL kicked;
@property (nonatomic, getter = hasBurst) BOOL burst;

@property (nonatomic) CGPoint force;
@end

@implementation CLSKickScene

#define kCAN_X_OFFSET CGRectGetMidX(self.frame)
#define kFLOOR_NODE_CATEGORY 1

-(instancetype)initWithSize:(CGSize)size{
    self = [super initWithSize:size];

    if (self) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(panGestureRecognized:)];

        self.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 30.0)
                                                        toPoint:CGPointMake(50000, 30.0)];
        self.physicsBody.categoryBitMask = kFLOOR_NODE_CATEGORY;
        self.physicsBody.friction = 0.4;


        self.physicsWorld.contactDelegate = self;

        self.cameraNode = [CLSKickCameraNode node];
        self.cameraNode.name = @"Camera";
        [self addChild:self.cameraNode];

        self.can = [CLSKickCanSprite node];
        self.can.physicsBody.contactTestBitMask = kFLOOR_NODE_CATEGORY;

        CGPoint position = CGPointMake(kCAN_X_OFFSET, 400);
        self.can.position = position;
        [self.cameraNode addChild:self.can];

        self.backgroundColor = [UIColor colorWithHue:0.52f saturation:0.99f brightness:1.00f alpha:1.00f];

        self.canDamage = 7000;
    }

    return self;
}

#pragma mark - SKScene

-(void)update:(NSTimeInterval)currentTime{

    if(self.hasKicked && self.can.physicsBody.resting){
        self.kicked = NO;
        self.burst = NO;
        [self.foamNode removeFromParent];
        self.foamNode = nil;
    }
}

-(void)didEvaluateActions{

}

-(void)didSimulatePhysics{
    if ([self hasKicked]) {
        [self moveCameraToCan];
        [self sprayFoam];
    }
}

-(void)didMoveToView:(SKView *)view{
    [view addGestureRecognizer:self.panGestureRecognizer];
}

-(void)willMoveFromView:(SKView *)view{
    [view removeGestureRecognizer:self.panGestureRecognizer];
}

#pragma mark - CLSKickScene
#pragma mark loading

#pragma mark kicking

-(void)kickCanWithVelocity:(CGPoint)velocity translation:(CGPoint)translation{
    self.kicked = YES;

    self.force = UIKitPointToSKPoint(CGPointNormalize(translation));
    CGPoint magnitude = CGPointAbs(velocity);

    CGPoint kick = CGPointMultiply(self.force, magnitude);

    [self.can.physicsBody applyForce:CGVectorMake(kick.x, kick.y)];
    [self.can.physicsBody applyAngularImpulse:-0.02];
}

-(void)burstCan{

    CGFloat burstMagnitude = self.canDamage / 10000 * 130;

    CGVector force = CGPointToCGVector(CGPointMultiplyScalar(self.force, burstMagnitude));
    [self.can.physicsBody applyImpulse:force];
    [self.can.physicsBody applyAngularImpulse:-0.03];

    if (self.foamNode == nil) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"CLSColaFoam" ofType:@"sks"];
        SKEmitterNode * emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        self.foamNode = emitter;
        [self.cameraNode addChild:emitter];
    }
    [self sprayFoam];

    self.burst = YES;
}

-(void)sprayFoam{

    CGPoint position = CGPointMake(0, self.can.size.width / 2.0);
    CGAffineTransform rotate = CGAffineTransformMakeRotation(self.can.zRotation);
    CGAffineTransform translate = CGAffineTransformMakeTranslation(self.can.position.x, self.can.position.y);
    CGAffineTransform contact = CGAffineTransformConcat(rotate, translate);
    position = CGPointApplyAffineTransform(position, contact);
    self.foamNode.particlePosition = position;
    self.foamNode.emissionAngle = self.can.zRotation + M_PI_2;

    CGPoint velocityPoint = CGVectorToCGPoint(self.can.physicsBody.velocity);
    velocityPoint = CGPointAbs(velocityPoint);

    CGFloat velocity = CGPointLength(velocityPoint);
    velocity = velocity / 1000.0 * 250.0;
    velocity = MAX(0, MIN(velocity, 250.0));
    self.foamNode.particleBirthRate = velocity;
}

#pragma mark camera

-(void)moveCameraToCan{
    CGPoint convertedCanPosition = self.can.position;
    CGFloat convertedCanX = convertedCanPosition.x - kCAN_X_OFFSET;
    self.cameraNode.position = CGPointMake(-convertedCanX, 0);
}

#pragma mark - target action

-(void)panGestureRecognized:(UIPanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [sender velocityInView:self.view];
        if (velocity.x > 0) {
            [self kickCanWithVelocity:velocity
                          translation:[sender translationInView:self.view]];
        }
    }
}

#pragma mark - SKPhysicsContactDelegate

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if (self.hasKicked && self.hasBurst == NO) {
        [self burstCan];
    }
}

@end
