//
//  HistoryAPIClient.h
//  Ripple
//
//  Created by Anastasis Germanidis on 2/23/14.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HistoryTableViewController.h"

@interface HistoryAPIClient : NSObject

- (void) getHistory: (HistoryTableViewController*) historyController;

@property (nonatomic, strong) HistoryTableViewController* controller;

@end
