//
//  CLSMenuScene.m
//  Cola Shaker
//
//  Created by Joel Parsons on 04/11/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

#import "CLSMenuScene.h"
#import "CLSSlidingNode.h"

@implementation CLSMenuScene

static NSString * const kMiddleScroller = @"middle scroll node";

#define kPADDING 20


-(instancetype)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupBackground];
    }

    return self;
}

#pragma mark - setup

-(void)setupBackground{
    CGFloat thirdSceneHeight = self.size.height / 3.0 - (2.0 * kPADDING);

    CLSSlidingNode * node = [CLSSlidingNode node];
    node.name = kMiddleScroller;
    CGPoint nodePosition = CGPointMake(0, self.size.height / 2.0);
    node.position = nodePosition;

    [self addChild:node];
    [node tileWithNodeHeight:thirdSceneHeight];


    SKAction * move = [SKAction moveByX:-50 y:0 duration:1.0];
    SKAction * tile = [SKAction performSelector:@selector(tile) onTarget:node];
    SKAction * queue = [SKAction sequence:@[move, tile]];
    [node runAction:[SKAction repeatActionForever:queue]];
}

#pragma mark - SKScene

-(void)update:(NSTimeInterval)currentTime{

}

-(void)didEvaluateActions{
//    CLSSlidingNode * node = (CLSSlidingNode *)[self childNodeWithName:kMiddleScroller];
//    [node tile];
}

-(void)didSimulatePhysics{

}



@end
