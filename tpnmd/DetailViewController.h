/**
 * File: DetailViewController.h 
 * Description: The controller used for displaying the Office information. 
 */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "Office.h"
#import "Physician.h"


@interface DetailViewController : UITableViewController<UIActionSheetDelegate>
{
  UILabel *headerLabel;
  UIImageView *headerImageView;

  Office *office;
}

@property (nonatomic, retain) IBOutlet UILabel *headerLabel;
@property (nonatomic, retain) IBOutlet UIImageView *headerImageView;

@property (nonatomic, retain) Office *office;

@end
