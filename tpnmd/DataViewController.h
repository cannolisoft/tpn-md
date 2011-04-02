//
//  DataViewController.h
//  tpnmd
//
//  Created by gg on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DataViewController <NSObject>

@required

@property (nonatomic, retain) NSManagedObjectContext *context;

@end
