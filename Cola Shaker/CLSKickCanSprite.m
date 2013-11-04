//
//  CLSKickCanSprite.m
//  Cola Shaker
//
//  Created by Joel Parsons on 30/10/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

#import "CLSKickCanSprite.h"

@implementation CLSKickCanSprite
-(id)init{
    self = [super initWithImageNamed:@"20cola"];
    if (self) {
        [self setupShape];
    }
    return self;
}

-(void)setupShape{

    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;

    CGMutablePathRef path = CGPathCreateMutable();

    CGPathMoveToPoint(path, NULL, 7 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 1 - offsetX, 5 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 56 - offsetY);
    CGPathAddLineToPoint(path, NULL, 5 - offsetX, 63 - offsetY);
    CGPathAddLineToPoint(path, NULL, 30 - offsetX, 63 - offsetY);
    CGPathAddLineToPoint(path, NULL, 34 - offsetX, 57 - offsetY);
    CGPathAddLineToPoint(path, NULL, 33 - offsetX, 6 - offsetY);
    CGPathAddLineToPoint(path, NULL, 28 - offsetX, 0 - offsetY);

    CGPathCloseSubpath(path);
    
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    
}
@end
