//
//  CLSShakerScene.h
//  Cola Shaker
//
//  Created by Joel Parsons on 23/10/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSGameProgressionDelegate.h"

@interface CLSShakerScene : SKScene
@property (nonatomic, weak) id<CLSGameProgressionDelegate> gameDelegate;

@end
