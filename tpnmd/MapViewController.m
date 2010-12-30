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

@synthesize mapView, detailViewController, urgentCareAnnotations, practiceAnnotations;


#pragma mark -

+ (CGFloat)annotationPadding
{
    return 10.0f;
}

+ (CGFloat)calloutHeight
{
    return 40.0f;
}

- (void)addWaitTimeData:(WaitTime *)waitTime
{
              
    for(OfficeAnnotation *annotation in urgentCareAnnotations)
    {
        if([waitTime.name caseInsensitiveCompare:annotation.waitTimeKey] == NSOrderedSame)
        {
            annotation.waitTime = waitTime;
        }
    }
}

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
    
    [self.mapView addAnnotations:urgentCareAnnotations];
    [self.mapView addAnnotations:practiceAnnotations];
}

- (void)plotUrgentCare
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:urgentCareAnnotations];
}

- (void)plotPractices
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:practiceAnnotations];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Bring back the toolbar
    [self.navigationController setToolbarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    self.mapView.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid
    self.mapView.showsUserLocation = TRUE;

    // Create a custom navigation bar button and set it to always says "Back"
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"Back";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];

    // Create out annotations array
    self.practiceAnnotations = [[NSMutableArray alloc] initWithCapacity:20];
    
    
    OfficeAnnotation *officeAnnotation = nil;
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Chapel Hill North Medical Center";
    officeAnnotation.address = @"1838 Martin Luther King, Jr. Blvd.";
    officeAnnotation.address2 = @"Chapel Hill, NC 27514";
    officeAnnotation.phone = @"919-960-7461";
    // No image available yet
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.964467];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-79.058385];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Chatham Crossing";
    officeAnnotation.address = @"11312 US 15-501N, Suite 308";
    officeAnnotation.address2 = @"Chapel Hill, NC 27517";
    officeAnnotation.phone = @"919-960-6094";
    // No image available yet
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.84619];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-79.09073];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Chatham Primary Care";
    officeAnnotation.address = @"311 N. Fir Avenue";
    officeAnnotation.address2 = @"Siler City, NC 27344";
    officeAnnotation.phone = @"919-742-6032";	
    // No image available yet
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.722466];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-79.470778];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Executive Health (The Carolina Clinic)";
    officeAnnotation.address = @"315 Meadowmont Village Circle";
    officeAnnotation.address2 = @"Chapel Hill, NC 27517";
    officeAnnotation.phone = @"919-962-2862";
    // No image available yet
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.904847];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-79.010439];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Highgate Family Medical Center";
    officeAnnotation.address = @"5317 Highgate Drive, Suite 117";
    officeAnnotation.address2 = @"Durham, NC 27713";
    // No image available yet
    officeAnnotation.phone = @"919-361-2644";
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.910117];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.941535];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Pittsboro Family Medicine";
    officeAnnotation.address = @"855 East Street";
    officeAnnotation.address2 = @"Pittsboro, NC 27312";
    officeAnnotation.phone = @"919-545-0911";
    // No image available yet
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.719903];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-79.162602];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];

    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Sanford Hematology Oncology";
    officeAnnotation.address = @"1212 Central Drive, Suite 201";
    officeAnnotation.address2 = @"Sanford, NC 27330";
    officeAnnotation.phone = @"919-775-8183";
    // No image available yet
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.467442];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-79.186845];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Sanford Specialty Clinics";
    officeAnnotation.address = @"1301 Central Drive";
    officeAnnotation.address2 = @"Sanford, NC 27330";	
    officeAnnotation.phone = @"919-718-9512";
    // No image available yet
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.466466];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-79.185844];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"UNC Family Medicine at Hillsborough";
    officeAnnotation.address = @"2201 Old N.C. Highway 86";
    officeAnnotation.address2 = @"Hillsborough, NC 27278";
    officeAnnotation.phone = @"919-732-2909";
    // No image available yet
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:36.053007];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-79.103842];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"University Pediatrics at Highgate";
    officeAnnotation.address = @"5322 Highgate Dr., Suite 144";
    officeAnnotation.address2 = @"Durham, NC 27713";
    officeAnnotation.phone = @"919-806-3335";
    // No image available yet
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.909862];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.941376];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Rex Family Practice of Knightdale";
    officeAnnotation.address = @"6602 Knightdale Blvd., Suite 202";
    officeAnnotation.address2 = @"Knightdale, NC 27545";
    officeAnnotation.phone = @"919-747-5270";
    officeAnnotation.imagePath = @"knightdale.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.795562];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.510993];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Rex Family Practice of Wakefield";
    officeAnnotation.address = @"11200 Governor Manly Way, Suite 205";
    officeAnnotation.address2 = @"Raleigh, NC 27614";
    officeAnnotation.phone = @"919-570-7700";
    officeAnnotation.imagePath = @"wakefield.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.942431];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.599759];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Rex Primary Care of Holly Springs";
    officeAnnotation.address = @"208 Village Walk Drive";
    officeAnnotation.address2 = @"Holly Springs, NC 27540";
    officeAnnotation.phone = @"919-552-8911";
    // Looked for image, not available
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.639555];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.833773];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Rex Senior Health Center";
    officeAnnotation.address = @"512 E. Davie Street";
    officeAnnotation.address2 = @"Raleigh, NC 27601";
    officeAnnotation.phone = @"919-832-2400";
    // Looked for an image, none available
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.775227];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.631606];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Rex/UNC Family Practice of Panther Creek ";
    officeAnnotation.address = @"10030 Green Level Church Road, Suite 808";
    officeAnnotation.address2 = @"Cary, NC 27519";
    officeAnnotation.phone = @"919-481-4997";
    // Looked for an image, none available
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.819609];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.902204];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Boylan Healthcare (Browning Place)";
    officeAnnotation.address = @"3900 Browning Place, Suite 101";
    officeAnnotation.address2 = @"Raleigh, NC 27609";
    officeAnnotation.phone = @"919-781-9650";
    // Looked for an image, none available
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.830793];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.633088];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Boylan Healthcare (Health Park)";
    officeAnnotation.address = @"8300 Health Park, Suite 309";
    officeAnnotation.address2 = @"Raleigh, NC 27615";
    // Looked for an image, none available
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.phone = @"919-781-9650";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.894875];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.659756];
    [self.practiceAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    
    self.urgentCareAnnotations = [[NSMutableArray alloc] initWithCapacity:20];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.type = @"Urgent Care";
    officeAnnotation.name = @"Rex Urgent Care of Cary";
    officeAnnotation.address = @"1515 Southwest Cary Parkway, Suite 130";
    officeAnnotation.address2 = @"Cary, NC 27511";
    officeAnnotation.phone = @"919-387-3180";
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.755050];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.809045];
    officeAnnotation.waitTimeKey = @"cary";
    [self.urgentCareAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.type = @"Urgent Care";
    officeAnnotation.name = @"Rex Urgent Care of Wakefield";
    officeAnnotation.address = @"4420 Lake Boone Trail";
    officeAnnotation.address2 = @"Raleigh, NC 27607";
    officeAnnotation.phone = @"919-784-3419";
    officeAnnotation.imagePath = @"default.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.815467];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.704067];
    officeAnnotation.waitTimeKey = @"wakefield";
    [self.urgentCareAnnotations addObject: officeAnnotation];
    [officeAnnotation release];
    
    

    [self zoomToFitMapAnnotations:self.practiceAnnotations];
    [self plotAll];
}

- (void)viewDidUnload
{
    self.practiceAnnotations = nil;
    self.detailViewController = nil;
    self.mapView = nil;
}

- (void)dealloc 
{
    [mapView release];
    [detailViewController release];
    [practiceAnnotations release];
    
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

- (void)showDetails:(id)sender
{
    // the detail view does not want a toolbar so hide it
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

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
        [self.navigationController setToolbarHidden:YES animated:NO];
        self.detailViewController.annotation = officeAnnotation;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
}

@end
