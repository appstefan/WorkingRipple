//
//  AppDelegate.h
//  Ripple
//
//  Created by Stefan Britton on 2/21/2014.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *lastLocation;

@property (nonatomic) UIBackgroundTaskIdentifier bgTask;
@property (strong, nonatomic) NSTimer *backgroundTimer;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
