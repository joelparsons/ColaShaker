//
//  SBChallengeCreateViewController.h
//  SmallBet
//
//  Created by Dan Hopwood on 13/10/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBControllerDelegate.h"

@interface SBChallengeCreateViewController : UIViewController

/**
 The delegate for this view controller
 @discussion the delegate is responsible for dismissing the view controller. You will get:
 - SBControllerResultTypeSuccess if the player creates a challenge successfully
 - SBControllerResultTypeCanceled is the player fails to create a challenge
 
 this class sends the challenge object to the delegate upon success
 */
@property (nonatomic, weak) id<SBControllerDelegate> delegate;

/**
 This property represents some arbitrary NSData that you can use to send information about the challenge level/mode/game state between instanced of your app to enable you to have fair, fun challenges.
 
 @discussion
 There is a size limit of 64KB on this property.
 
 Interesting ways you can use this property are:
 NSData * data = [NSKeyedArchiver archivedDataWithRootObject:gameState];
 
 --or--
 
 NSData * data = [NSPropertyListSerialisation
 dataWithPropertyList:gameStateDictionary
 format:NSPropertyListBinaryFormat_v1_0
 options:0
 error:&error];
 
 The property list serialisation is more space efficient than keyed archiving. Either way check your data.length to see what size it is before making an SBChallengeRequest
 
 */
@property (nonatomic, strong) NSData *gameConfiguration;

/**
 designated initializer
 @param delegate an object which confroms to the SBControllerDelegate protocol which can act as the delegate for this view controller
 @returns an instance of this controller ready to go!
 */
-(id)initWithDelegate:(id<SBControllerDelegate>)delegate;

@end
