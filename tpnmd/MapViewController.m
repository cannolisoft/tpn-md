/**
 * File: MapViewController.m 
 * Description: The primary view controller containing the 
 *              MKMapView, adding and removing both
 *              MKPinAnnotationViews through its toolbar. 
 */

#import "MapViewController.h"
#import "DetailViewController.h"
#import "OfficeAnnotation.h"

@implementation MapViewController

@synthesize mapView, detailViewController, officeModel;


#pragma mark -

+ (CGFloat)annotationPadding
{
    return 10.0f;
}

+ (CGFloat)calloutHeight
{
    return 40.0f;
}


// Zoom in on the annotations, use best zoom level while still showing all the data.
-(void)zoomToFitMapAnnotations:(NSArray *)annotations
{
    if ([annotations count] == 0)
    {
        return;
    }
	
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
	
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
	
    // Search for best bounding box of the annotation data 
    for(NSObject<MKAnnotation>* annotation in annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
		
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
	
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
	
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

- (void)gotoLocation
{
	
    // Start off by default in San Francisco
    MKCoordinateRegion newRegion;
	
    newRegion.center.latitude = 35.467442;
    newRegion.center.longitude = -79.186845;
	
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
	
    [self.mapView setRegion:newRegion animated:YES];
}

- (void)plotAll
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView addAnnotations:[self.officeModel getAllOffices]];
}

- (void)plotUrgentCare
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    [self.mapView addAnnotations:self.officeModel.urgentCareOffices];
}

- (void)plotPractices
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.officeModel.practiceOffices];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Bring back the toolbar
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    self.mapView.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid
    self.mapView.showsUserLocation = TRUE;

    NSArray *offices = [self.officeModel getAllOffices];

    [self zoomToFitMapAnnotations:offices];
    [self plotAll];
}

- (void)viewDidUnload
{
    self.detailViewController = nil;
    self.mapView = nil;
}

- (void)dealloc 
{
    [mapView release];
    [detailViewController release];
    [officeModel release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark ButtonActions

- (IBAction)filterAction:(id)sender
{
    
    UIActionSheet *filterAlert = [[UIActionSheet alloc] initWithTitle: @"Choose care centers to display:"
                                                        delegate: self
                                                        cancelButtonTitle: @"Cancel"
                                                        destructiveButtonTitle: nil
                                                        otherButtonTitles: @"All", @"Urgent Care", @"Practices",
                                                        nil, nil];
    
    filterAlert.actionSheetStyle = self.parentViewController.navigationController.navigationBar.barStyle;
    [filterAlert showInView: self.mapView.superview];
    [filterAlert release];
}


#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            // Display All
            [self plotAll];
            break;
        case 1:
            // Display Urgent Care
            [self plotUrgentCare];
            break;
        case 2:
            // Display Practices
            [self plotPractices];
        default:
            break;
    }
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    // Handle our two custom annotations
    //
    if ([annotation isKindOfClass:[OfficeAnnotation class]]) // for Golden Gate Bridge
    {
        // Try to dequeue an existing pin view first
        static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
                                        [mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (!pinView)
        {
            // If an existing pin view was not available, create one
            pinView = [[[MKPinAnnotationView alloc]
                                             initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier] autorelease];
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
			

			
            
            // Add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
			
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
        }

        OfficeAnnotation *office = annotation;
        if ([office.type isEqualToString:@"Urgent Care"])
        {
            pinView.pinColor = MKPinAnnotationColorRed;	
        }
        else
        {
            pinView.pinColor = MKPinAnnotationColorPurple;
        }			
        pinView.annotation = annotation;
        return pinView;
    }    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	
    // MKAnnotation annotation = view.annotation;
    if ([view.annotation isKindOfClass:[OfficeAnnotation class]])
    {
        OfficeAnnotation *officeAnnotation = (OfficeAnnotation*)view.annotation;
        
        // The detail view does not want a toolbar so hide it
        [self.navigationController setToolbarHidden:YES animated:YES];
        self.detailViewController.annotation = officeAnnotation;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
}

@end
