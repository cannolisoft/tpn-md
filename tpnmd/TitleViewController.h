//
//  TitleViewController.h
//  tpnmd
//
//  Created by gg on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewController.h"

@interface TitleViewController : UITableViewController<DataViewController>
{
    NSManagedObjectContext *_context;
}

@end
