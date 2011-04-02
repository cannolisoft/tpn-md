/**
 * File: MapViewController.h 
 * Description: The primary view controller containing the MKMapView,
 *              adding and removing both MKPinAnnotationViews 
 *              through its toolbar. 
 */
  
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DataViewController.h"

@class DetailViewController;

@interface MapViewController : UIViewController <DataViewController, MKMapViewDelegate, UIActionSheetDelegate>
{
    MKMapView *mapView;
    DetailViewController *detailViewController;

    NSManagedObjectContext *_context;
}
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet NSManagedObjectContext *context;

- (IBAction)filterAction:(id)sender;

@end
