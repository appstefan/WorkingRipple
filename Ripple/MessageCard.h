//
//  MessageCard.h
//  Ripple
//
//  Created by Stefan Britton on 2/22/2014.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCard : UIView {
    CGPoint offset;
}

@property (strong, nonatomic) NSString *message;

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *yesLabel;
@property (nonatomic, strong) UILabel *noLabel;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) UIView *background;

- (id)initWithFrame:(CGRect)frame message:(NSString*)message;

@end
