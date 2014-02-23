//
//  APIClient.h
//  Ripple
//
//  Created by Anastasis Germanidis on 2/22/14.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MessagesViewController.h"

@interface APIClient : NSObject

+ (void) postLocationToServer: (CLLocation*) loc;
+ (void) publishMessage: (NSString*) content fromLocation:(CLLocation*) loc;
+ (void) propagateMessage: (NSString*) eventId;
+ (void) ignoreMessage: (NSString*) eventId;
- (void) checkForIncomingMessages: (MessagesViewController*) controller;
+ (int) checkForIncomingMessages2;

@property (nonatomic, strong) MessagesViewController* controller;

@end
