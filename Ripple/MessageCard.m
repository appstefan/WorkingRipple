//
//  MessageCard.m
//  Ripple
//
//  Created by Stefan Britton on 2/22/2014.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import "MessageCard.h"

@implementation MessageCard

@synthesize messageLabel, yesLabel, noLabel, background;

- (id)initWithFrame:(CGRect)frame message:(NSString*)message
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.background = [[UIView alloc] initWithFrame:frame];
        background.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        background.backgroundColor = [UIColor whiteColor];
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:background.bounds];
        background.layer.masksToBounds = NO;
        background.layer.shadowColor = [UIColor blackColor].CGColor;
        background.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        background.layer.shadowOpacity = 0.5f;
        background.layer.shadowPath = shadowPath.CGPath;
        [self addSubview:background];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:frame];
        messageLabel.frame = CGRectMake(10, 10, frame.size.width-20, frame.size.height-20);
        messageLabel.backgroundColor = [UIColor whiteColor];
        messageLabel.numberOfLines = 5;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = message;
        messageLabel.font = [UIFont systemFontOfSize:26];
        
        [self addSubview:messageLabel];
        
//        self.noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-50, frame.size.width, 50)];
//        noLabel.text = @"FUCK THIS";
//        noLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:26];
//        noLabel.textAlignment = NSTextAlignmentCenter;
//        noLabel.backgroundColor = [UIColor clearColor];
//        noLabel.textColor = [UIColor redColor];
//        noLabel.alpha = 0.0f;
//        [self addSubview:noLabel];
//        
//        self.yesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
//        yesLabel.text = @"HELL YA";
//        yesLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:26];
//        yesLabel.textAlignment = NSTextAlignmentCenter;
//        yesLabel.backgroundColor = [UIColor clearColor];
//        yesLabel.textColor = [UIColor greenColor];
//        yesLabel.alpha = 0.0f;
//        [self addSubview:yesLabel];
        
    }
    return self;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *aTouch = [touches anyObject];
//    offset = [aTouch locationInView:self];
//    
//    //bring me to top
//    [self.superview bringSubviewToFront:self];
//}
//
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    UITouch *aTouch = [touches anyObject];
//    CGPoint location = [aTouch locationInView:self.superview];
//    
//    CGPoint temp = CGPointMake(location.x - offset.x + 100, location.y - offset.y + 100);
//    
//    [UIView beginAnimations:@"Dragging A DraggableView" context:nil];
//    self.center = temp;
//    [UIView commitAnimations];
//    
//    //swipe right
//    if (self.center.y >= self.superview.bounds.size.height/2) {
//        //rotation
//        [self setTransform:CGAffineTransformMakeRotation((self.center.x - 160.0f)/160.0f * (M_PI/5))];
//        
//        //labels
//        noLabel.alpha = ((self.center.y - (self.superview.bounds.size.height/2.0f))/(self.superview.bounds.size.height/2.0f)) +0.1f;
//        yesLabel.alpha = 0.0f;
//    }
//    //swipe left
//    else {
//        //rotation
//        [self setTransform:CGAffineTransformMakeRotation(((self.center.x - 160.0f)/160.0f) * (M_PI/5))];
//        
//        //labels
//        yesLabel.alpha = (((self.superview.bounds.size.height/2.0f) - self.center.y)/(self.superview.bounds.size.height/2.0f))+0.1f;
//        
//        noLabel.alpha = 0.0f;
//    }
//    
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
