//
//  MessagesViewController.m
//  Ripple
//
//  Created by Stefan Britton on 2/22/2014.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageCard.h"
#import "HistoryTableViewController.h"
#import "APIClient.h"
#import <QuartzCore/QuartzCore.h>

@interface MessagesViewController ()

@end

CGFloat x, y, w, h;
UIGestureRecognizer *pan;
NSInteger cardCount = 0;
BOOL offsetCard = YES;

@implementation MessagesViewController

@synthesize seenEvents = _seenEvents;

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
    self.eventCache = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    w = self.view.bounds.size.width-20;
    h = 260;
    x = 10;
    y = (self.view.bounds.size.height/2)-h/2;
    //y = 50;
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    
}



- (bool) hasSeenEvent:(NSString*) evtId {
    NSLog(@"checking whether has seen %@", evtId);
    for (int i = 0; i < [self.eventCache count]; i++) {
        NSString *eid = [self.eventCache objectAtIndex:i];
        NSLog(@"comparing %@ and %@", evtId, eid);
        if  ([eid isEqualToString:evtId]) { return TRUE; }
    }
    return FALSE;
}

- (void) receivedEvents: (NSArray*) events {
//    if ([events count] == 0) {
//        return;
//    }
    
    for (NSObject *event in events) {
        NSString *eventId = [event valueForKey:@"id"];
        NSString *content = [event valueForKey:@"content"];
        NSLog(@"RECEIVED MSG: %@", content);
        if (![self hasSeenEvent:eventId]) {
            NSLog(@"RENDERING MSG: %@", content);
            [self.eventCache addObject:eventId];
            
            [self renderCardWithContent:content andId:eventId];
        }
    }
    if ([events count] < 1) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
        self.loadingMessage.text = @"No new broadcasts. Try again soon.";
    }
}

- (void) renderCardWithContent: (NSString*) content andId: (NSString*) eventId {
    MessageCard* messageCard = [[MessageCard alloc] initWithFrame:CGRectMake(x, y, w, h) message:content];
    messageCard.eventId = eventId;
    
    cardCount++;
    [self.view addSubview:messageCard];
    
//    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:messageCard snapToPoint:self.view.center];
//    [self.animator addBehavior:snap];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [messageCard addGestureRecognizer:pan];
    
    self.activityIndicatorView.hidden = YES;
    self.loadingMessage.hidden = YES;
}

- (void) refresh {
    self.loadingMessage.text = @"Looking for broadcasts...";
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.hidden = NO;
    self.loadingMessage.hidden = NO;
    
    [[APIClient alloc] checkForIncomingMessages: self];
    
    
    //[self renderCardWithContent:@"Hello this is a test message for Ripple App! Spread the word everyone!" andId:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    static UIAttachmentBehavior *attachment;
    static CGPoint               startCenter;
    
    // variables for calculating angular velocity
    
    static CFAbsoluteTime        lastTime;
    static CGFloat               lastAngle;
    static CGFloat               angularVelocity;
    
    MessageCard *currentCard = (MessageCard*)gesture.view.self;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        [self.animator removeAllBehaviors];
        
        startCenter = self.view.center;
        
        // calculate the center offset and anchor point
        
        CGPoint pointWithinAnimatedView = [gesture locationInView:gesture.view];
        
        UIOffset offset = UIOffsetMake(pointWithinAnimatedView.x - gesture.view.bounds.size.width / 2.0,
                                       pointWithinAnimatedView.y - gesture.view.bounds.size.height / 2.0);
        
        CGPoint anchor = [gesture locationInView:gesture.view.superview];
        
        // create attachment behavior
        
        attachment = [[UIAttachmentBehavior alloc] initWithItem:gesture.view
                                               offsetFromCenter:offset
                                               attachedToAnchor:anchor];
        
        // code to calculate angular velocity (seems curious that I have to calculate this myself, but I can if I have to)
        
        lastTime = CFAbsoluteTimeGetCurrent();
        lastAngle = [self angleOfView:gesture.view];
        
        attachment.action = ^{
            CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
            CGFloat angle = [self angleOfView:gesture.view];
            if (time > lastTime) {
                angularVelocity = (angle - lastAngle) / (time - lastTime);
                lastTime = time;
                lastAngle = angle;
            }
        };
        
        // add attachment behavior
        
        [self.animator addBehavior:attachment];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        // as user makes gesture, update attachment behavior's anchor point, achieving drag 'n' rotate
        
        CGPoint anchor = [gesture locationInView:gesture.view.superview];
        attachment.anchorPoint = CGPointMake(attachment.anchorPoint.x, anchor.y);
        //attachment.anchorPoint = anchor;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self.animator removeAllBehaviors];
        
        CGPoint velocity = [gesture velocityInView:gesture.view.superview];
        CGFloat yPos = [gesture locationInView:gesture.view.superview].y;
        //CGFloat yPos = gesture.view.bounds.origin.y + (gesture.view.bounds.size.height/2);
        
        // if we aren't dragging it down, just snap it back and quit
        
//        if (fabs(atan2(velocity.y, velocity.x) - M_PI_2) > M_PI_4) {
//            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gesture.view snapToPoint:startCenter];
//            [self.animator addBehavior:snap];
//            
//            return;
//        }
        if (yPos < gesture.view.superview.bounds.size.height/2 + 125 && yPos > gesture.view.superview.bounds.size.height/2 - 125) {
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gesture.view snapToPoint:startCenter];
            [self.animator addBehavior:snap];
            
            return;
        }
        
        
        // otherwise, create UIDynamicItemBehavior that carries on animation from where the gesture left off (notably linear and angular velocity)
        if (yPos > gesture.view.superview.bounds.size.height/2) {
            UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[gesture.view]];
            [dynamic addLinearVelocity:velocity forItem:gesture.view];
            [dynamic addAngularVelocity:angularVelocity forItem:gesture.view];
            [dynamic setAngularResistance:2];
            
            // when the view no longer intersects with its superview, go ahead and remove it
            
            dynamic.action = ^{
                if (!CGRectIntersectsRect(gesture.view.superview.bounds, gesture.view.frame)) {
                    [self.animator removeAllBehaviors];
                    [gesture.view removeFromSuperview];
                                        
                    NSLog(@"NO");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [APIClient ignoreMessage:currentCard.eventId];
                    });
                    
                    cardCount--;
                    if (cardCount<1) {
                        [self refresh];
                    }
                }
            };
            [self.animator addBehavior:dynamic];
            
            // add a little gravity so it accelerates off the screen (in case user gesture was slow)
            
            UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[gesture.view]];
            gravity.magnitude = 0.7;
            [self.animator addBehavior:gravity];
        } else {
            UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[gesture.view]];
            [dynamic addLinearVelocity:velocity forItem:gesture.view];
            [dynamic addAngularVelocity:-angularVelocity forItem:gesture.view];
            [dynamic setAngularResistance:2];
            
            // when the view no longer intersects with its superview, go ahead and remove it
            
            dynamic.action = ^{
                if (!CGRectIntersectsRect(gesture.view.superview.bounds, gesture.view.frame)) {
                    
                    
                    [self.animator removeAllBehaviors];
                    [gesture.view removeFromSuperview];
                    
                    NSLog(@"YES");
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [APIClient propagateMessage:currentCard.eventId];
                    });
                    
                    cardCount--;
                    if (cardCount<1) {
                        [self refresh];
                    }
                }
            };
            [self.animator addBehavior:dynamic];
            
            // add a little gravity so it accelerates off the screen (in case user gesture was slow)
            
            UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[gesture.view]];
            gravity.magnitude = -0.7;
            [self.animator addBehavior:gravity];
        }
    }
}

- (CGFloat)angleOfView:(UIView *)view
{
    return atan2(view.transform.b, view.transform.a);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"historySegue"]) {
        HistoryTableViewController *controller = (HistoryTableViewController *)[segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
    }
}

- (IBAction)refreshButton:(id)sender {
    [self refresh];
}

//-(void) fadein:(UIView*)view
//{
//    view.alpha = 0;
//    view.hidden = NO;
//    [UIView beginAnimations:@"Fade In" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    
//    //don't forget to add delegate.....
//    [UIView setAnimationDelegate:self];
//    
//    [UIView setAnimationDuration:1];
//    view.alpha = 1;
//    //also call this before commit animations......
//    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
//    [UIView commitAnimations];
//}
@end
