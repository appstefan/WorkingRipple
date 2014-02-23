//
//  PostViewController.h
//  Ripple
//
//  Created by Stefan Britton on 2/21/2014.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@class PostViewController;
@protocol AddPostViewControllerDelegate
- (void)thePostButtonOnThePostViewControllerWasTapped:(PostViewController *)controller;
@end


@interface PostViewController : UIViewController <UITextViewDelegate>
- (IBAction)cancelButton:(id)sender;

@property (nonatomic) UIDynamicAnimator *animator;

@property (nonatomic, weak) id <AddPostViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *checkmarkImage;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *messages;


- (IBAction)postButton:(id)sender;

@end
