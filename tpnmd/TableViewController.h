//
//  TableViewController.h
//
//  Created by gg on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OfficeModel.h"

@interface TableViewController : UITableViewController {
    OfficeModel *officeModel;
}

@property (nonatomic, retain) OfficeModel *officeModel;

@end
