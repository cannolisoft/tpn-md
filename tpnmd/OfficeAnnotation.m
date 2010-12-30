/**
 * File: SFAnnotation.m 
 * Description: The custom MKAnnotation object representing Medical Offices. 
 */

#import "OfficeAnnotation.h"
#import <UIKit/UIKit.h>

@implementation OfficeAnnotation 

@synthesize imagePath;

@synthesize name;
@synthesize type;
@synthesize address;
@synthesize address2;
@synthesize phone;
@synthesize latitude;
@synthesize longitude;
@synthesize waitTimeKey;
@synthesize waitTime;


- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [latitude doubleValue];
    theCoordinate.longitude = [longitude doubleValue];
    return theCoordinate; 
}

- (void)dealloc
{
	[name release];
	[type release];
	[address release];
	[address2 release];
	[phone release];
	[latitude release];
	[longitude release];

    [waitTimeKey release];
    [waitTime release];
	
    [super dealloc];
}

- (NSString *)title
{
    return name;
}

// Optional
- (NSString *)subtitle
{
    return [address stringByAppendingFormat:@"\n%@", address2];
}

- (UIImage *) getUIImage 
{
    return [UIImage imageNamed: imagePath ];
}

// Optional
- (NSString *)phone
{
    return phone;
}
@end
