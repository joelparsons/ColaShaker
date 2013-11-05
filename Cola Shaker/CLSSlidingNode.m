//
//  CLSSlidingNode.m
//  Cola Shaker
//
//  Created by Joel Parsons on 05/11/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

#import "CLSSlidingNode.h"

@implementation CLSSlidingNode
{
    NSArray * _canSprites;
    NSUInteger _index;
}

#define kPADDING 20

-(void)tileWithNodeHeight:(CGFloat)nodeHeight{

    __autoreleasing SKSpriteNode * lastNode = nil;

    CGFloat sceneWidth = self.scene.size.width;
    NSMutableArray * canSprites = [[NSMutableArray alloc] init];

    CGFloat positionX = -100;

    while (lastNode.position.x < sceneWidth) {
        SKSpriteNode * spriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"dent0"];
        CGFloat spriteHeight = spriteNode.size.height;
        CGFloat scale = nodeHeight / spriteHeight;
        spriteNode.scale = scale;
        [self addChild:spriteNode];

        spriteNode.position = CGPointMake(positionX,0);
        [canSprites addObject:spriteNode];

        positionX = spriteNode.position.x + spriteNode.size.width + kPADDING;
        lastNode = spriteNode;
    }

    _canSprites = canSprites;
    _index = canSprites.count - 1;
}


-(void)tile{
    SKSpriteNode * endNode = _canSprites[_index];

    CGFloat endNodePosition = endNode.position.x + self.position.x;
    CGFloat sceneSize = self.scene.size.width;

    if (endNodePosition < sceneSize) {
        _index = (_index + 1) % _canSprites.count;
        SKSpriteNode * firstNode = _canSprites[_index];
        CGFloat positionX = endNode.position.x + endNode.size.width + kPADDING;
        firstNode.position = CGPointMake(positionX, 0) ;
    }
}

@end
