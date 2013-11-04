//
//  CLSCan.m
//  Cola Shaker
//
//  Created by Joel Parsons on 23/10/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

#import "CLSCan.h"

@implementation CLSCan{
    SKTextureAtlas * _atlas;
    NSArray * _sortedNames;
    NSUInteger _dentIndex;
}

-(id)init{
    _atlas = [SKTextureAtlas atlasNamed:@"cola"];
    _sortedNames = [_atlas.textureNames sortedArrayUsingSelector:@selector(description)];
    SKTexture * texture = [_atlas textureNamed:_sortedNames.firstObject];
    self = [super initWithTexture:texture];
    if (self) {
        [self setupShape];
        _dentIndex = 1;
    }
    return self;
}

-(void)setupShape{

    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;

    CGMutablePathRef path = CGPathCreateMutable();

    CGPathMoveToPoint(path, NULL, 20 - offsetX, 319 - offsetY);
    CGPathAddLineToPoint(path, NULL, 157 - offsetX, 318 - offsetY);
    CGPathAddLineToPoint(path, NULL, 169 - offsetX, 279 - offsetY);
    CGPathAddLineToPoint(path, NULL, 169 - offsetX, 26 - offsetY);
    CGPathAddLineToPoint(path, NULL, 146 - offsetX, 8 - offsetY);
    CGPathAddLineToPoint(path, NULL, 88 - offsetX, 1 - offsetY);
    CGPathAddLineToPoint(path, NULL, 23 - offsetX, 7 - offsetY);
    CGPathAddLineToPoint(path, NULL, 5 - offsetX, 24 - offsetY);
    CGPathAddLineToPoint(path, NULL, 2 - offsetX, 271 - offsetY);

    CGPathCloseSubpath(path);
    
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];

    self.physicsBody.affectedByGravity = YES;
    self.physicsBody.allowsRotation = YES;
    self.physicsBody.mass = 300.0;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.friction = 0.5;
    self.physicsBody.restitution = 0.3;
}

-(BOOL)dent{

    if (_dentIndex >= _sortedNames.count) {
        return NO;
    }

    NSString * textureName = _sortedNames[_dentIndex];
    SKTexture * texture = [_atlas textureNamed:textureName];
    self.texture = texture;
    _dentIndex ++;
    return YES;
}

@end
