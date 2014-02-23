//
//  HistoryTableViewController.h
//  Ripple
//
//  Created by Stefan Britton on 2/21/2014.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "PostViewController.h"
//#import "CoreDataTableViewController.h" // so we can fetch

@interface HistoryTableViewController : UITableViewController <AddPostViewControllerDelegate>

- (void) receivedMessages: (NSArray*) messages;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *messages;

@end
