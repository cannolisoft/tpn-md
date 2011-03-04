/**
 * File: DetailViewController.h 
 * Description: The controller used for displaying the Office information. 
 */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "Office.h"
#import "Physician.h"
#import "Specialty.h"


@interface DocDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{

  UITableView* table;
  UILabel* headerLabel;

  Physician* doc;

@private
  NSMutableArray* sections;
}

@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet UILabel* headerLabel;

@property (nonatomic, retain) Physician* doc;

@end
