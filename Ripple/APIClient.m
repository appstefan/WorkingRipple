//
//  APIClient.m
//  Ripple
//
//  Created by Anastasis Germanidis on 2/22/14.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

@synthesize controller = _controller;

- (void) checkForIncomingMessages: (MessagesViewController*) messagesController {
    _controller = messagesController;
    
    NSString *urlAsString = [NSString stringWithFormat:@"http://agermanidis.com:2323/check?user_id=%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    
    
//    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if (!error) {
//            NSError *jsonErr;
//            
//            NSArray *results = [NSJSONSerialization
//             JSONObjectWithData:data
//             options:0
//             error:&jsonErr];
//            
//            [controller receivedEvents:results];
//        }
//    }];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSHTTPURLResponse *)response {

}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
    NSError *jsonErr;
    
    NSArray *results = [NSJSONSerialization
                        JSONObjectWithData:data
                        options:0
                        error:&jsonErr];
    
    [_controller receivedEvents:results];

}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
}

+ (NSData*) apiPost: (NSString*) endpoint withData:(NSDictionary*) data {
    NSError *err;
    NSData *jsonObj = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://agermanidis.com:2323%@", endpoint]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonObj];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSURLResponse *resp;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    
    return responseData;
}

+ (int) checkForIncomingMessages2 {
    NSString *urlAsString = [NSString stringWithFormat:@"http://agermanidis.com:2323/check2?user_id=%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    NSURLResponse *resp;
    NSError *err;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    
    NSError *jsonErr;
    
    NSArray *results = [NSJSONSerialization
                        JSONObjectWithData:responseData
                        options:0
                        error:&jsonErr];
    
    return [results count];
}

+ (NSString*) getDeviceUUID {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}


+ (void) postLocationToServer: (CLLocation*) loc {
    NSNumber *lat = [NSNumber numberWithDouble:loc.coordinate.latitude];
    NSNumber *lng = [NSNumber numberWithDouble:loc.coordinate.longitude];
    
    NSMutableDictionary *locationDictionary = [[NSMutableDictionary alloc] init];
    [locationDictionary
     setValue:[APIClient getDeviceUUID] forKey:@"user_id"];
    [locationDictionary setValue:lat forKey:@"lat"];
    [locationDictionary setValue:lng forKey:@"lng"];
    
    [APIClient apiPost:@"/location" withData:locationDictionary];
}

+ (void) publishMessage: (NSString*) content fromLocation:(CLLocation*) loc {
    NSNumber *lat = [NSNumber numberWithDouble:loc.coordinate.latitude];
    NSNumber *lng = [NSNumber numberWithDouble:loc.coordinate.longitude];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:[APIClient getDeviceUUID] forKey:@"user_id"];
    [data setValue:content forKey:@"content"];
    [data setValue:lat forKey:@"lat"];
    [data setValue:lng forKey:@"lng"];
    
    [self apiPost:@"/publish" withData:data];
}

+ (void) propagateMessage: (NSString*) eventId  {   
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:[self getDeviceUUID] forKey:@"user_id"];
    [data setValue:eventId forKey:@"event_id"];
    
    [self apiPost:@"/propagate" withData:data];
}

+ (void) ignoreMessage: (NSString*) eventId  {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:[self getDeviceUUID] forKey:@"user_id"];
    [data setValue:eventId forKey:@"event_id"];
    
    [self apiPost:@"/ignore" withData:data];
}




@end

