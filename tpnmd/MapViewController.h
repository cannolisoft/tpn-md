/**
 * File: MapViewController.h 
 * Description: The primary view controller containing the MKMapView,
 *              adding and removing both MKPinAnnotationViews 
 *              through its toolbar. 
 */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class DetailViewController;

@interface MapViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate>
{
    MKMapView *mapView;
    DetailViewController *detailViewController;
	
    NSMutableArray *urgentCareAnnotations;
	NSMutableArray *practiceAnnotations;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSMutableArray *urgentCareAnnotations;
@property (nonatomic, retain) NSMutableArray *practiceAnnotations;

+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;

- (IBAction)filterAction:(id)sender;

@end
