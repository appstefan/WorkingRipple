//
//  Event.h
//  Ripple
//
//  Created by Anastasis Germanidis on 2/21/14.
//  Copyright (c) 2014 Choicengine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * content;

@end
