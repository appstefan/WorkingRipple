//
//  MakeMessageCard.h
//  Ripple
//
//  Created by Stefan Britton on 2/22/2014.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeMessageCard : UIView {
    CGPoint offset;
}

@property (strong, nonatomic) NSString *message;

@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) UILabel *characterCountLabel;
@property (nonatomic, strong) UIView *background;

- (id)initWithFrame:(CGRect)frame message:(NSString*)message;

@end
