//
//  TableViewController.h
//
//  Created by gg on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DataViewController.h"
#import "DetailViewController.h"


@interface TableViewController : UITableViewController<DataViewController> {
    DetailViewController *detailViewController;
    
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context;
}
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;

@end
