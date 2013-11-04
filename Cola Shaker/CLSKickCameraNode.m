//
//  CLSKickCameraNode.m
//  Cola Shaker
//
//  Created by Joel Parsons on 04/11/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

#import "CLSKickCameraNode.h"

@interface CLSKickCameraNode ()

@property (nonatomic, strong) NSArray * cityNodes;
@property (nonatomic) NSUInteger tilingIndex;
@property (nonatomic) CGFloat cityBlockWidth;
@end

@implementation CLSKickCameraNode
#define kNUM_CITY_TILES 7

- (id)init
{
    self = [super init];
    if (self) {
        [self loadBackground];
    }
    return self;
}

-(void)loadBackground{
    NSMutableArray * cityNodes = [[NSMutableArray alloc] initWithCapacity:kNUM_CITY_TILES];

    for (NSUInteger i = 0; i < kNUM_CITY_TILES; i++) {
        NSString * textureName = [NSString stringWithFormat:@"city0%lu",(unsigned long)i + 1];
        SKSpriteNode * node = [[SKSpriteNode alloc] initWithImageNamed:textureName];
        [self addChild:node];
        [cityNodes addObject:node];

    }

    self.cityNodes = cityNodes;

    self.cityBlockWidth = [(SKSpriteNode *)cityNodes.lastObject size].width;

    for (SKSpriteNode * node in self.cityNodes) {
        node.position = CGPointMake(self.tilingIndex * self.cityBlockWidth, node.size.height / 2.0);
        self.tilingIndex ++;
    }
}

-(void)setPosition:(CGPoint)position{
    [super setPosition:position];
    [self tileBackground];
}

-(void)tileBackground{
    CGFloat offset = -1 * self.position.x;
    SKSpriteNode * firstNode = self.cityNodes[self.tilingIndex % kNUM_CITY_TILES];
    CGFloat lastX = firstNode.position.x;
    if (lastX + 2*self.cityBlockWidth < offset) {
        firstNode.position = CGPointMake(self.tilingIndex * self.cityBlockWidth, firstNode.size.height / 2.0);
        self.tilingIndex++;
    }
}

@end
