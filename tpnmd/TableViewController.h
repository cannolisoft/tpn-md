//
//  TableViewController.h
//
//  Created by gg on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DetailViewController.h"
#import "OfficeModel.h"

@interface TableViewController : UITableViewController {
    DetailViewController *detailViewController;
    
    OfficeModel *officeModel;
}
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) OfficeModel *officeModel;

@end
