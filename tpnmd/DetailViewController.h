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
    Office *office;
    
    @private
    UILabel *headerLabel;
    UIImageView *headerImageView;
    
    NSArray *docs;
}

@property (nonatomic, retain) Office *office;

@end
