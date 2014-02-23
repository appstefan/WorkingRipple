//
//  MessagesViewController.h
//  Ripple
//
//  Created by Stefan Britton on 2/22/2014.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesViewController : UIViewController

@property (nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UILabel *loadingMessage;
- (IBAction)refreshButton:(id)sender;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableDictionary *seenEvents;
@property (strong, nonatomic) NSMutableArray *eventCache;

- (void) receivedEvents: (NSArray*) events;

@end
