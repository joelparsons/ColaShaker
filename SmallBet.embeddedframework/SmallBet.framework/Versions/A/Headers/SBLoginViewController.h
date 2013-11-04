//
//  SBLoginViewController.h
//  SmallBet
//
//  Created by Joel Parsons on 27/02/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBControllerDelegate.h"
/**
 The aim of this view controller is to return a player logged into the smallbet service. 
 
 Presenting this view controller is the only way to log a player into smallbet.
 
 Player login is only successful if a player can be created who is also authorized to make payments. Therefore if the login process completes successfully you will be able to proceed and start making challenges straight away.
 
 This view controller also allows the logged in player to manage their account or logout of the service. The player sent to the delegate may be different than the original logged in player when this controller is presented if one user logs out and another logs in. 
 If there is a logged in player this controller will always tell its delegate SBControllerResultTypeSuccess.
 If there is no logged in player and the user declines to log in then the controller tells its delegate SBControllerResultTypeCanceled.
 This controller never tells its delegate SBControllerResultTypeFailed as all errors generated by the login process are handled by this class and its children.
 */

@interface SBLoginViewController : UIViewController

/**
 The object responsible for dismissing the view controller once the login flow is completed. Not setting the delegate is considered programmer error and will throw an exception.
 
 @discussion  If there is a logged in player this controller will always tell its delegate SBControllerResultTypeSuccess.
 If there is no logged in player and the user declines to log in then the controller tells its delegate SBControllerResultTypeCanceled.
 This controller never tells its delegate SBControllerResultTypeFailed as all errors generated by the login process are handled by this class and its children.

 The object sent with the delegate callback will be the logged in SBPlayer object (if there is a player logged in)
 */
@property (nonatomic, weak) id<SBControllerDelegate> delegate;

/**
 designated initializer
 @param delegate an object which confroms to the SBControllerDelegate protocol which can act as the delegate for this view controller
 @returns an instance of this controller ready to go!
 */
-(id)initWithDelegate:(id<SBControllerDelegate>)delegate;
@end