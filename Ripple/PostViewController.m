//
//  PostViewController.m
//  Ripple
//
//  Created by Stefan Britton on 2/21/2014.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import "PostViewController.h"
#import "HistoryTableViewController.h"
#import "MakeMessageCard.h"
#import "APIClient.h"
#import "AppDelegate.h"

@interface PostViewController ()

@end

CGFloat x, y, w, h;
MakeMessageCard *makeMessageCard;
CLLocation *lastLocation;

@implementation PostViewController

@synthesize managedObjectContext = __managedObjectContext;

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
    w = self.view.bounds.size.width-20;
    h = 170;
    x = 10;
    y = 78;
    makeMessageCard = [[MakeMessageCard alloc] initWithFrame:CGRectMake(x, y, w, h) message:@""];
    
    [self.view addSubview:makeMessageCard];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    makeMessageCard.messageTextView.delegate = self;
    [makeMessageCard.messageTextView becomeFirstResponder];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) textViewDidChange:(UITextView *)textView {
    makeMessageCard.characterCountLabel.text = [NSString stringWithFormat:@"%lu / 80", (unsigned long)textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText: (NSString *)text {
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    if((newLength > 80)) {
        return NO;
    }
    if ([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location != NSNotFound) {
        [textView resignFirstResponder];
        [self post];
    }
    return YES;
}

- (void)post {
//    NSLog(@"Telling the AddRoleTVC Delegate that Save was tapped on the AddRoleTVC");
//    Message *message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
//    message.text = makeMessageCard.messageTextView.text;
//    [self.managedObjectContext save:nil];  // write to database
    
    
    [APIClient publishMessage:makeMessageCard.messageTextView.text fromLocation:lastLocation];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[makeMessageCard]];
    UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[makeMessageCard]];
    gravity.magnitude = -5.0;
    [self.animator addBehavior:gravity];
    
    
    dynamic.action = ^{
        self.checkmarkImage.hidden = NO;
        if (!CGRectIntersectsRect(self.view.bounds, makeMessageCard.frame)) {
            
            [self.animator removeAllBehaviors];
            [makeMessageCard removeFromSuperview];
            [NSThread sleepForTimeInterval:0.5];
            self.checkmarkImage.hidden = YES;
            [self dismissModalViewControllerAnimated:YES];
            [self.delegate thePostButtonOnThePostViewControllerWasTapped:self];
        }
    };
    [self.animator addBehavior:dynamic];
}

- (void)locationUpdated {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    lastLocation = app.lastLocation;
//    if(app.applicationState == UIApplicationStateBackground) {
//        //background code
//    } else {
//        
//    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Interface

- (IBAction)postButton:(id)sender {
    [self post];
}


- (IBAction)cancelButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end