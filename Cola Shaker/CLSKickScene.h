//
//  CLSKickScene.h
//  Cola Shaker
//
//  Created by Joel Parsons on 29/10/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CLSGameProgressionDelegate.h"

@interface CLSKickScene : SKScene

@property (nonatomic, weak) id<CLSGameProgressionDelegate> gameDelegate;

@property (nonatomic) CGFloat canDamage;

@property (nonatomic, readonly) CGFloat score;

@end
