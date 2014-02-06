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
#import "CLSGameProgressionDelegate.h"

@interface CLSGameViewController ()
<CLSGameProgressionDelegate>
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    if (self.sceneView.scene == nil) {
        //CLSKickScene * scene = [CLSKickScene sceneWithSize:self.sceneView.bounds.size];
        CLSShakerScene * scene = [CLSShakerScene sceneWithSize:self.sceneView.bounds.size];
        scene.gameDelegate = self;
        [self.sceneView presentScene:scene];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)gameOverWithScore:(float)score{
    if (self.challenge) {
        NSInteger finalScore = (NSInteger)(score * 100);
        [self.challenge submitScore:finalScore withCompletion:^(SBChallenge *updtedChallenge, NSError *error) {
            [self dismissViewControllerAnimated:YES
                                     completion:^{

                                     }];
        }];
    }
    else{
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self dismissViewControllerAnimated:YES completion:^{

            }];
        });
    }
}

#pragma mark - CLSGameProgressionDelegate

-(void)clsGameSceneDidFinish:(SKScene *)scene{
    if ([scene isKindOfClass:[CLSShakerScene class]]) {
        CLSShakerScene * shakerScene = (CLSShakerScene *)scene;
        SKTransition * transition = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:0.6];
        CLSKickScene * kickScene = [[CLSKickScene alloc] initWithSize:scene.size];
        kickScene.gameDelegate = self;
        kickScene.canDamage = shakerScene.damagePoints;
        [self.sceneView presentScene:kickScene transition:transition];
    }else if ([scene isKindOfClass:[CLSKickScene class]]){
        CLSKickScene * kickScene = (CLSKickScene *)scene;
        [self gameOverWithScore:kickScene.score];
    }
}

@end
