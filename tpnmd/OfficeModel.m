/**
 * File: OfficeModel.m
 * Description: Encapsulates the office data used throughout the application.
 *
 */

#import "OfficeModel.h"


@implementation OfficeModel

@synthesize urgentCareOffices, practiceOffices;

-(NSMutableArray *)getUCOffices
{
    NSMutableArray *offices = [[NSMutableArray alloc] initWithCapacity:20];
    
    OfficeAnnotation *officeAnnotation = nil;
    
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
    [officeAnnotation release];
    
    return [offices autorelease];
}

-(NSMutableArray *)getPracticeOffices
{
    NSMutableArray *offices = [[NSMutableArray alloc] initWithCapacity:20];
        
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Rex Family Practice of Knightdale";
    officeAnnotation.address = @"6602 Knightdale Blvd., Suite 202";
    officeAnnotation.address2 = @"Knightdale, NC 27545";
    officeAnnotation.phone = @"919-747-5270";
    officeAnnotation.imagePath = @"knightdale.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.795562];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.510993];
    [offices addObject: officeAnnotation];
    [officeAnnotation release];
    
    officeAnnotation = [[OfficeAnnotation alloc] init];
    officeAnnotation.name = @"Rex Family Practice of Wakefield";
    officeAnnotation.address = @"11200 Governor Manly Way, Suite 205";
    officeAnnotation.address2 = @"Raleigh, NC 27614";
    officeAnnotation.phone = @"919-570-7700";
    officeAnnotation.imagePath = @"wakefield.jpg";
    officeAnnotation.latitude = [NSNumber numberWithFloat:35.942431];
    officeAnnotation.longitude = [NSNumber numberWithFloat:-78.599759];
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
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
    [offices addObject: officeAnnotation];
    [officeAnnotation release];
    
    return [offices autorelease];
}



-(OfficeModel*) init
{
    self = [super init];
    
    if ( self )
    {
        NSMutableArray *ucOffices = [self getUCOffices];
        urgentCareOffices = [[NSArray arrayWithArray:ucOffices] retain];
        
        NSMutableArray *pOffices = [self getPracticeOffices];
        practiceOffices = [[NSArray arrayWithArray:pOffices] retain];
    }
    
    return self;
}

-(NSArray *)getAllOffices
{
    return [urgentCareOffices arrayByAddingObjectsFromArray: practiceOffices];
}

- (void)addWaitTimeData:(WaitTime *)waitTime
{
    
    for(OfficeAnnotation *office in urgentCareOffices)
    {
        if([waitTime.name caseInsensitiveCompare:office.waitTimeKey] == NSOrderedSame)
        {
            office.waitTime = waitTime;
        }
    }
}

- (void)dealloc
{
    [urgentCareOffices release];
    [practiceOffices release];
    
    [super dealloc];
}




@end
