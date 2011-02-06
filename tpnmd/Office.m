// 
//  Office.m
//  tpnmd
//
//  Created by gg on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Office.h"

#import "Physician.h"

@implementation Office 

@dynamic phone;
@dynamic city;
@dynamic address;
@dynamic longitude;
@dynamic zipCode;
@dynamic latitude;
@dynamic type;
@dynamic state;
@dynamic name;
@dynamic waitTime;
@dynamic physicians;

- (NSString *)cityAndState
{
    return [NSString stringWithFormat:@"%@, %@",
            self.city, self.state];
}

- (NSString *)fullAddress:(BOOL)separated
{
    
    NSString *separator = (separated)?@"\n":@" ";
    return [NSString stringWithFormat:@"%@%@%@, %@ %@",
            self.address, separator, self.city, self.state, self.zipCode];
}


#pragma mark -
#pragma mark MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [[self latitude] doubleValue];
    theCoordinate.longitude = [[self longitude] doubleValue];
    return theCoordinate; 
}

- (NSString *)title
{
    return [self name];
}

- (NSString *)subtitle
{
    return [self cityAndState];
}

@end
