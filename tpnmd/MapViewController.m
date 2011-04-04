/**
 * File: MapViewController.m 
 * Description: The primary view controller containing the 
 *              MKMapView, adding and removing both
 *              MKPinAnnotationViews through its toolbar. 
 */

#import "MapViewController.h"
#import "DetailViewController.h"

@implementation MapViewController

@synthesize mapView, detailViewController, context = _context, navigationItem;


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

- (NSArray *)getOfficesOfType:(NSString *)type
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Office" inManagedObjectContext:_context]];
    if(type)
    {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", @"type", type]];
    }
    
    
    NSError *error = nil;
    NSArray *offices = [_context executeFetchRequest:fetchRequest error:&error];
    if (!offices) {
		NSLog(@"Unresolved error retrieving offices %@, %@", error, [error userInfo]);
    }
    
    [fetchRequest release];
    
    return offices;
}

- (void)plotAll
{
    [self.mapView removeAnnotations:self.mapView.annotations];

    NSArray *offices = [self getOfficesOfType:nil];    
    [self zoomToFitMapAnnotations:offices];
    [self.mapView addAnnotations:offices];
}

- (void)plotUrgentCare
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSArray *offices = [self getOfficesOfType:@"Urgent Care"];
    [self zoomToFitMapAnnotations:offices];
    [self.mapView addAnnotations:offices];
}

- (void)plotPractices
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSArray *offices = [self getOfficesOfType:@"Practice"];
    [self zoomToFitMapAnnotations:offices];
    [self.mapView addAnnotations:offices];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Bring back the toolbar
    //[self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    self.mapView.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid
    self.mapView.showsUserLocation = TRUE;

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
    [navigationItem release];
    [detailViewController release];
    [_context release];
    
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
    if ([annotation isKindOfClass:[Office class]]) // for Golden Gate Bridge
    {
        // Try to dequeue an existing pin view first
        static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
                                        [mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (!pinView)
        {
            // If an existing pin view was not available, create one
            pinView = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation
                                                      reuseIdentifier:BridgeAnnotationIdentifier] autorelease];
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
			
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
        }

        Office *office = annotation;
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
    if ([view.annotation isKindOfClass:[Office class]])
    {
        Office *officeAnnotation = (Office *)view.annotation;
        
        // The detail view does not want a toolbar so hide it
        self.detailViewController.hidesBottomBarWhenPushed = YES;
        
        self.detailViewController.office = officeAnnotation;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
}

@end
