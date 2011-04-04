//
//  DocTableViewController.h
//  tpnmd
//
//  Created by gg on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewController.h"
#import "DocDetailViewController.h"

@interface DocTableViewController : UITableViewController<DataViewController, NSFetchedResultsControllerDelegate>
{
    UINavigationItem *navigationItem;
    DocDetailViewController *detailViewController;
    
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context;   
}
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, retain) IBOutlet DocDetailViewController *detailViewController;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;


@end
