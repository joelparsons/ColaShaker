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

@interface CLSKickScene ()
<SKPhysicsContactDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer * panGestureRecognizer;

@property (nonatomic, strong) SKNode * cameraNode;
@property (nonatomic, strong) CLSKickCanSprite * can;

@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic, getter = hasKicked) BOOL kicked;
@end

@implementation CLSKickScene

#define kCAN_X_OFFSET CGRectGetMidX(self.frame)

-(instancetype)initWithSize:(CGSize)size{
    self = [super initWithSize:size];

    if (self) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(panGestureRecognized:)];

        self.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 0)
                                                        toPoint:CGPointMake(50000, 0.0)];

        self.physicsWorld.contactDelegate = self;

        self.cameraNode = [SKNode node];
        self.cameraNode.name = @"Camera";
        [self addChild:self.cameraNode];

        self.can = [CLSKickCanSprite node];

        CGPoint position = CGPointMake(kCAN_X_OFFSET, 400);
        self.can.position = position;
        [self.cameraNode addChild:self.can];
    }

    return self;
}

#pragma mark - CLSKickScene

-(void)moveCameraToCan{
    CGPoint convertedCanPosition = self.can.position;
    CGFloat convertedCanX = convertedCanPosition.x - kCAN_X_OFFSET;
    self.cameraNode.position = CGPointMake(-convertedCanX, 0);
}

#pragma mark - SKScene

-(void)update:(NSTimeInterval)currentTime{

}

-(void)didEvaluateActions{

}

-(void)didSimulatePhysics{
    if ([self hasKicked]) {
        [self moveCameraToCan];
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

    CGPoint force = UIKitPointToSKPoint(CGPointNormalize(translation));
    CGPoint magnitude = CGPointAbs(velocity);

    force = CGPointMultiply(force, magnitude);

    [self.can.physicsBody applyForce:CGVectorMake(force.x, force.y)];
}

#pragma mark - target action

-(void)panGestureRecognized:(UIPanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self kickCanWithVelocity:[sender velocityInView:self.view]
                      translation:[sender translationInView:self.view]];
    }
}

@end
