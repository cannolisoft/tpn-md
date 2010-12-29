/**
 * File: DetailViewController.h 
 * Description: The controller used for displaying the Office information. 
 */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "OfficeAnnotation.h"

@interface DetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{

  UITableView* table;
  UIImageView* imageView;

  OfficeAnnotation* annotation;

}

@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) OfficeAnnotation* annotation;

@end
