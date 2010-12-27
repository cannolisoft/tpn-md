/*
     File: MapViewController.m 
 Abstract: The primary view controller containing the MKMapView, adding and removing both MKPinAnnotationViews through its toolbar. 
  Version: 1.0 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2010 Apple Inc. All Rights Reserved. 
  
 */

#import "MapViewController.h"
#import "DetailViewController.h"
#import "OfficeAnnotation.h"
#import "BridgeAnnotation.h"

enum
{
    kCityAnnotationIndex = 0,
    kBridgeAnnotationIndex
};

@implementation MapViewController

@synthesize mapView, detailViewController, mapAnnotations;


#pragma mark -

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}



-(void)zoomToFitMapAnnotations:(NSArray *)annotations
{
    if([annotations count] == 0)
        return;
	
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
	
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    //newRegion.center.latitude = 37.786996;
    //newRegion.center.longitude = -122.440100;
	
	newRegion.center.latitude = 35.467442;
    newRegion.center.longitude = -79.186845;
	
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
	
    [self.mapView setRegion:newRegion animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    // bring back the toolbar
    [self.navigationController setToolbarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    self.mapView.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid
	self.mapView.showsUserLocation = TRUE;

    // create a custom navigation bar button and set it to always says "Back"
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"Back";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
    
    // create out annotations array
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:20];
	
	
	OfficeAnnotation *officeAnnotation = nil;
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Chapel Hill North Medical Center";
	officeAnnotation.address = @"1838 Martin Luther King, Jr. Blvd.";
	officeAnnotation.address2 = @"Chapel Hill, North Carolina 27514";
	officeAnnotation.phone = @"919-960-7461";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.964467];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-79.058385];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Chatham Crossing";
	officeAnnotation.address = @"11312 US 15-501N, Suite 308";
	officeAnnotation.address2 = @"Chapel Hill, North Carolina 27517";
	officeAnnotation.phone = @"919-960-6094";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.84619];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-79.09073];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Chatham Primary Care";
	officeAnnotation.address = @"311 N. Fir Avenue";
	officeAnnotation.address2 = @"Siler City, North Carolina 27344";
	officeAnnotation.phone = @"919-742-6032";	
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.722466];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-79.470778];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Executive Health (The Carolina Clinic)";
	officeAnnotation.address = @"315 Meadowmont Village Circle";
	officeAnnotation.address2 = @"Chapel Hill, North Carolina 27517";
	officeAnnotation.phone = @"919-962-2862";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.904847];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-79.010439];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Highgate Family Medical Center";
	officeAnnotation.address = @"5317 Highgate Drive, Suite 117";
	officeAnnotation.address2 = @"Durham, North Carolina 27713";
	officeAnnotation.phone = @"919-361-2644";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.910117];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-78.941535];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Pittsboro Family Medicine";
	officeAnnotation.address = @"855 East Street";
	officeAnnotation.address2 = @"Pittsboro, North Carolina 27312";
	officeAnnotation.phone = @"919-545-0911";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.719903];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-79.162602];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];

	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Sanford Hematology Oncology";
	officeAnnotation.address = @"1212 Central Drive, Suite 201";
	officeAnnotation.address2 = @"Sanford, North Carolina 27330";
	officeAnnotation.phone = @"919-775-8183";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.467442];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-79.186845];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Sanford Specialty Clinics";
	officeAnnotation.address = @"1301 Central Drive";
	officeAnnotation.address2 = @"Sanford, North Carolina 27330";	
	officeAnnotation.phone = @"919-718-9512";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.466466];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-79.185844];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"UNC Family Medicine at Hillsborough";
	officeAnnotation.address = @"2201 Old N.C. Highway 86";
	officeAnnotation.address2 = @"Hillsborough, North Carolina 27278";
	officeAnnotation.phone = @"919-732-2909";
	officeAnnotation.latitude = [NSNumber numberWithFloat:36.053007];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-79.103842];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"University Pediatrics at Highgate";
	officeAnnotation.address = @"5322 Highgate Dr., Suite 144";
	officeAnnotation.address2 = @"Durham, North Carolina 27713";
	officeAnnotation.phone = @"919-806-3335";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.909862];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-78.941376];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Rex Family Practice of Knightdale";
	officeAnnotation.address = @"6602 Knightdale Blvd., Suite 202";
	officeAnnotation.address2 = @"Knightdale, North Carolina 27545";
	officeAnnotation.phone = @"919-747-5270";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.795562];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-78.510993];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Rex Family Practice of Wakefield";
	officeAnnotation.address = @"11200 Governor Manly Way, Suite 205";
	officeAnnotation.address2 = @"Raleigh, North Carolina 27614";
	officeAnnotation.phone = @"919-570-7700";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.942431];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-78.599759];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Rex Primary Care of Holly Springs";
	officeAnnotation.address = @"208 Village Walk Drive";
	officeAnnotation.address2 = @"Holly Springs, North Carolina 27540";
	officeAnnotation.phone = @"919-552-8911";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.639555];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-78.833773];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Rex Senior Health Center";
	officeAnnotation.address = @"512 E. Davie Street";
	officeAnnotation.address2 = @"Raleigh, North Carolina 27601";
	officeAnnotation.phone = @"919-832-2400";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.775227];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-78.631606];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Rex/UNC Family Practice of Panther Creek ";
	officeAnnotation.address = @"10030 Green Level Church Road, Suite 808";
	officeAnnotation.address2 = @"Cary, North Carolina 27519";
	officeAnnotation.phone = @"919-481-4997";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.819609];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-78.902204];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Boylan Healthcare (Browning Place)";
	officeAnnotation.address = @"3900 Browning Place, Suite 101";
	officeAnnotation.address2 = @"Raleigh, North Carolina 27609";
	officeAnnotation.phone = @"919-781-9650";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.830793];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-78.633088];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];
	
	officeAnnotation = [[OfficeAnnotation alloc] init];
	officeAnnotation.name = @"Boylan Healthcare (Health Park)";
	officeAnnotation.address = @"8300 Health Park, Suite 309";
	officeAnnotation.address2 = @"Raleigh, North Carolina 27615";
	officeAnnotation.phone = @"919-781-9650";
	officeAnnotation.latitude = [NSNumber numberWithFloat:35.894875];
	officeAnnotation.longitude = [NSNumber numberWithFloat:-78.659756];
	[self.mapAnnotations addObject: officeAnnotation];
	[officeAnnotation release];

    //[self gotoLocation];
	[self zoomToFitMapAnnotations:self.mapAnnotations];	
	[self.mapView addAnnotations:self.mapAnnotations];
}

- (void)viewDidUnload
{
    self.mapAnnotations = nil;
    self.detailViewController = nil;
    self.mapView = nil;
}

- (void)dealloc 
{
    [mapView release];
    [detailViewController release];
    [mapAnnotations release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark ButtonActions

- (IBAction)cityAction:(id)sender
{
    [self gotoLocation];//•• avoid this by checking its region from ours??
    
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    
    [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:kCityAnnotationIndex]];
}

- (IBAction)bridgeAction:(id)sender
{
    [self gotoLocation];
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    
    [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:kBridgeAnnotationIndex]];
}

- (IBAction)allAction:(id)sender
{
    [self gotoLocation];
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    
    [self.mapView addAnnotations:self.mapAnnotations];
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
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[OfficeAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
                                        [mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                             initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier] autorelease];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
			
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //[rightButton addTarget:self
            //                action:@selector(showDetails:)
            //      forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;

            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	
	//MKAnnotation annotation = view.annotation;
	if ([view.annotation isKindOfClass:[OfficeAnnotation class]]){
		OfficeAnnotation *officeAnnotation = (OfficeAnnotation*)view.annotation;
		
		// the detail view does not want a toolbar so hide it
		[self.navigationController setToolbarHidden:YES animated:NO];
		self.detailViewController.annotation = officeAnnotation;
		[self.navigationController pushViewController:self.detailViewController animated:YES];
	}
	
	
}

@end
