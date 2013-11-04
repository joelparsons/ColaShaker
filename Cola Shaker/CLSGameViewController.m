//
//  CLSGameViewController.m
//  Cola Shaker
//
//  Created by Joel Parsons on 23/10/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

@import SpriteKit;
#import "CLSGameViewController.h"
#import "CLSShakerScene.h"
#import "CLSKickScene.h"

@interface CLSGameViewController ()

@property (weak, nonatomic) IBOutlet SKView *sceneView;
@end

@implementation CLSGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    if (self.sceneView.scene == nil) {
        //CLSKickScene * scene = [CLSKickScene sceneWithSize:self.sceneView.bounds.size];
        CLSShakerScene * scene = [CLSShakerScene sceneWithSize:self.sceneView.bounds.size];
        [self.sceneView presentScene:scene];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
