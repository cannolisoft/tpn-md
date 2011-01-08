/**
 * File: OfficeModel.h 
 * Description: Encapsulates the office data used throughout the application.
 *
 */
 
#import <Foundation/Foundation.h>
#import "OfficeAnnotation.h"
#import "WaitTime.h"

@interface OfficeModel : NSObject {
    NSArray *urgentCareOffices;
    NSArray *practiceOffices;
}

@property (nonatomic, retain, readonly) NSArray *urgentCareOffices;
@property (nonatomic, retain, readonly) NSArray *practiceOffices;

- (NSArray *)getAllOffices;
- (void)addWaitTimeData:(WaitTime *)waitTime;

@end
