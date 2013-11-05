//
//  CLSSlidingNode.h
//  Cola Shaker
//
//  Created by Joel Parsons on 05/11/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CLSSlidingNode : SKNode

@property (nonatomic) CGFloat nodeHeight;

-(void)tileWithNodeHeight:(CGFloat)nodeHeight;
-(void)tile;

@end
