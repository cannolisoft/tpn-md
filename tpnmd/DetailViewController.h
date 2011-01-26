/**
 * File: DetailViewController.h 
 * Description: The controller used for displaying the Office information. 
 */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "OfficeAnnotation.h"

@interface DetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{

  UITableView* table;
  UILabel* headerLabel;
  UIImageView* headerImageView;

  OfficeAnnotation* annotation;

}

@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet UILabel* headerLabel;
@property (nonatomic, retain) IBOutlet UIImageView* headerImageView;

@property (nonatomic, retain) OfficeAnnotation* annotation;

@end
