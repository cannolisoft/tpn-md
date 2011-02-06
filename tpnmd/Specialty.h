//
//  Specialty.h
//  tpnmd
//
//  Created by gg on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Physician;

@interface Specialty :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* physicians;

@end


@interface Specialty (CoreDataGeneratedAccessors)
- (void)addPhysiciansObject:(Physician *)value;
- (void)removePhysiciansObject:(Physician *)value;
- (void)addPhysicians:(NSSet *)value;
- (void)removePhysicians:(NSSet *)value;

@end

