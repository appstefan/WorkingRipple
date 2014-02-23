//
//  HistoryAPIClient.m
//  Ripple
//
//  Created by Anastasis Germanidis on 2/23/14.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import "HistoryAPIClient.h"

@implementation HistoryAPIClient

@synthesize controller = _controller;

- (void) getHistory: (HistoryTableViewController*) historyController {
    _controller = historyController;
    
    NSString *urlAsString = [NSString stringWithFormat:@"http://agermanidis.com:2323/history?user_id=%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSHTTPURLResponse *)response {
    
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
    NSError *jsonErr;
    
    NSArray *results = [NSJSONSerialization
                        JSONObjectWithData:data
                        options:0
                        error:&jsonErr];
    
    [_controller receivedMessages:results];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
}


@end

