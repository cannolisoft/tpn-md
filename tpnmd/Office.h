//
//  Office.h
//  tpnmd
//
//  Created by gg on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

#import "WaitTime.h"

@class Physician;

@interface Office :  NSManagedObject <MKAnnotation>
{
}

@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * zipCode;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* physicians;
@property (nonatomic, retain) WaitTime * waitTime;

- (NSString *)cityAndState;
- (NSString *)fullAddress:(BOOL)separated;

@end


@interface Office (CoreDataGeneratedAccessors)
- (void)addPhysiciansObject:(Physician *)value;
- (void)removePhysiciansObject:(Physician *)value;
- (void)addPhysicians:(NSSet *)value;
- (void)removePhysicians:(NSSet *)value;

@end

