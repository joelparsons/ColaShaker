//
//  CLSMenuViewController.m
//  Cola Shaker
//
//  Created by Joel Parsons on 04/11/2013.
//  Copyright (c) 2013 Joel Parsons. All rights reserved.
//

#import "CLSMenuViewController.h"
#import <SmallBet/SmallBet.h>
#import "CLSMenuScene.h"
#import "CLSGameViewController.h"

@interface CLSMenuViewController ()
<SBControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *shakerLabel;
@property (nonatomic, weak) NSTimer * shakerTimer;

@property (weak, nonatomic) IBOutlet SKView *backgoundScene;

@property (nonatomic, strong) SBChallenge * observedChallenge;
@property (nonatomic) BOOL userIntendedToViewChallenges;

@property (nonatomic, strong) NSMutableArray * observers;

@end

@implementation CLSMenuViewController

#pragma mark - properties

-(NSMutableArray *)observers{
    if (_observers) {
        return _observers;
    }
    _observers = [NSMutableArray array];
    return _observers;
}

#pragma mark - lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startShakingLabel];

    id observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:SBChallengeStatusNewNotification
                   object:nil
                   queue:[NSOperationQueue mainQueue]
                   usingBlock:^(NSNotification *note) {
                       if (self.observedChallenge) {
                           return ;
                       }
                       SBChallenge * observedChallenge = note.userInfo[SBChallengeObjectKey];
                       self.observedChallenge = observedChallenge;
                       UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Challenge", @"alert title")
                                                                            message:NSLocalizedString(@"You have been challenged to a game of Moneyhole!", nil)
                                                                           delegate:self
                                                                  cancelButtonTitle:NSLocalizedString(@"Later", @"alert button view challenge later")
                                                                  otherButtonTitles:NSLocalizedString(@"View", @"alert button view challenge now"), nil];
                       [alertView show];
                   }];
    [self.observers addObject:observer];

    observer = [[NSNotificationCenter defaultCenter]
                addObserverForName:SBChallengeStatusDidChangeNotification
                object:nil
                queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *note) {
                    if (self.observedChallenge) {
                        return ;
                    }
                    SBChallenge * observedChallenge = note.userInfo[SBChallengeObjectKey];
                    self.observedChallenge = observedChallenge;
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Challenge Updated", @"alert title")
                                                                         message:NSLocalizedString(@"One of your challenges has been updated!", nil)
                                                                        delegate:self
                                                               cancelButtonTitle:NSLocalizedString(@"Later", @"alert button view challenge later")
                                                               otherButtonTitles:NSLocalizedString(@"View", @"alert button view challenge now"), nil];
                    [alertView show];
                }];

    [self.observers addObject:observer];

    observer = [[NSNotificationCenter defaultCenter]
                  addObserverForName:UIApplicationDidBecomeActiveNotification
                  object:nil
                  queue:[NSOperationQueue mainQueue]
                  usingBlock:^(NSNotification *note) {
                      [self startShakingLabel];
                  }];
    [self.observers addObject:observer];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    for (id observer in self.observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    self.observers = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIViewController

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

    if (self.backgoundScene.scene == nil) {
        CLSMenuScene * menuScene = [[CLSMenuScene alloc] initWithSize:self.view.bounds.size];
        [self.backgoundScene setShowsFPS:YES];
        [self.backgoundScene presentScene:menuScene];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"playchallenge"]) {
        id destination = segue.destinationViewController;
        if ([destination isKindOfClass:[CLSGameViewController class]]) {
            [destination setChallenge:sender];
        }
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - CLSMenuViewController

-(void)startShakingLabel{
    if (self.shakerTimer) {
        [self.shakerTimer invalidate];
        self.shakerTimer = nil;
    }

    NSTimer * timer = [NSTimer timerWithTimeInterval:0.25
                                              target:self
                                            selector:@selector(shakeLabel)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer
                              forMode:NSRunLoopCommonModes];
    self.shakerTimer = timer;
}

-(void)shakeLabel{
    if (CGAffineTransformIsIdentity(self.shakerLabel.transform)) {
        self.shakerLabel.transform = CGAffineTransformMakeTranslation(10, 0);
    }
    else{
        self.shakerLabel.transform = CGAffineTransformIdentity;
    }
}

- (void)showChallengeListWithChallenge:(SBChallenge *)challenge {
    SBChallengesViewController * challengeListViewController = [[SBChallengesViewController alloc] init];
    challengeListViewController.delegate = self;

    if (challenge) {
        [challengeListViewController showDetailForChallenge:challenge];
    }

    [self presentViewController:challengeListViewController
                       animated:YES
                     completion:^{

                     }];
}

#pragma mark - target Action

- (IBAction)challengeButtonTapped:(id)sender {
    SBChallengeCreateViewController * challengeCreateViewController = [[SBChallengeCreateViewController alloc] initWithDelegate:self];

    [self presentViewController:challengeCreateViewController
                       animated:YES
                     completion:^{

                     }];
}

- (IBAction)yourChallengesButtonTapped:(id)sender {
    if ([[SBSmallbetManager defaultManager] currentPlayer] == nil) {
        self.userIntendedToViewChallenges = YES;
        SBLoginViewController * loginViewController = [[SBLoginViewController alloc] initWithDelegate:self];
        [self presentViewController:loginViewController
                           animated:YES
                         completion:^{

                         }];
        return;
    }
    [self showChallengeListWithChallenge:nil];
}

- (IBAction)accountButtonTapped:(id)sender {
    SBLoginViewController * accountViewController = [[SBLoginViewController alloc] initWithDelegate:self];
    [self presentViewController:accountViewController
                       animated:YES
                     completion:^{

                     }];
}

#pragma mark - SBControllerDelegate

-(void)SBViewController:(UIViewController *)controller didFinishWithResult:(SBControllerResultType)result object:(id)object error:(NSError *)error{
    //This is the delegate method for all the smallbet controllers
    //we can detect which one we are talking about by class
    [self dismissViewControllerAnimated:YES completion:^{
        if ([controller isKindOfClass:[SBLoginViewController class]]) {
            switch (result) {
                case SBControllerResultTypeSuccess:
                    if (self.userIntendedToViewChallenges) {
                        [self showChallengeListWithChallenge:nil];
                    }
                    self.userIntendedToViewChallenges = NO;
                    break;
                case SBControllerResultTypeCanceled:
                case SBControllerResultTypeFailed:
                default:
                    break;
            }
        }
        if ([controller isKindOfClass:[SBChallengesViewController class]]) {
            switch (result) {
                case SBControllerResultTypeSuccess:{
                    //when selecting challenges if the result is success then the object
                    //is the SBChallenge the user has selected to play right now!!
                    [self performSegueWithIdentifier:@"playchallenge" sender:object];

                }
                    break;
                case SBControllerResultTypeCanceled:
                case SBControllerResultTypeFailed:
                default:
                    break;
            }
        }
    }];
}

#pragma mark - <#section title#>

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [self showChallengeListWithChallenge:self.observedChallenge];
    }
    self.observedChallenge = nil;
}

@end
