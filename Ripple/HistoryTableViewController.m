//
//  HistoryTableViewController.m
//  Ripple
//
//  Created by Stefan Britton on 2/21/2014.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "CustomTableViewCell.h"
#import "PostViewController.h"
#import "HistoryAPIClient.h"

@interface HistoryTableViewController ()

@end

@implementation HistoryTableViewController

//- (void)setupFetchedResultsController
//{
//    // 1 - Decide what Entity you want
//    NSString *entityName = @"Message"; // Put your entity name here
//    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
//    
//    // 2 - Request that Entity
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
//    
//    // 3 - Filter it if you want
//    //request.predicate = [NSPredicate predicateWithFormat:@"Role.name = Blah"];
//    
//    // 4 - Sort it if you want
//    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"mtime_timestamp"ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
//    // 5 - Fetch it
//    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
//                                                                        managedObjectContext:self.managedObjectContext
//                                                                          sectionNameKeyPath:nil
//                                                                                   cacheName:nil];
//    [self performFetch];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self setupFetchedResultsController];
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveMessages) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.refreshControl setHidden:FALSE];
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[HistoryAPIClient alloc] getHistory:self];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [self.messages count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
//    Message *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSObject *msg = [self.messages objectAtIndex:indexPath.row];
    
    cell.messageLabel.text = [msg valueForKey:@"content"];
    
    NSNumber *reach = [msg valueForKey:@"reach"];
    cell.greenLabel.text = [reach stringValue];
    
    return cell;
}

- (void) retrieveMessages {
    [[HistoryAPIClient alloc] getHistory:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the role object that was swiped
        Message *messageToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting (%@)", messageToDelete.text);
        [self.managedObjectContext deleteObject:messageToDelete];
        [self.managedObjectContext save:nil];
        
        // Delete the (now empty) row on the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self performFetch];
        
        [self.tableView endUpdates];
    }
}

- (void) receivedMessages: (NSArray*) messages {
    self.messages = messages;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)thePostButtonOnThePostViewControllerWasTapped:(PostViewController *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Create Post Segue"])
	{
        NSLog(@"Setting RolesTVC as a delegate of AddRolesTVC");
        
        PostViewController *postViewController = segue.destinationViewController;
        postViewController.delegate = self;
        postViewController.managedObjectContext = self.managedObjectContext;
	}
}

@end
