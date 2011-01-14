/**
 * File: WaitTime.m 
 * Description: The wait time for an office.
 */

#import "WaitTime.h"


@implementation WaitTime

@synthesize name;
@synthesize type;
@synthesize message;
@synthesize time;
@synthesize update;

static NSString *DEFAULT_MSG = @"Closed";


- (void)dealloc
{
    [name release];
    [type release];
    [message release];
    [time release];
    [update release];
    
    [super dealloc];
}

-(NSString *)waitMsg
{
    
    NSString *msg = DEFAULT_MSG;
    
    // If the type is '1' appears to be closed
    if(message && [@"1" isEqualToString:type])
    {
        msg = [NSString stringWithString:message];
    }
    else if(time)
    {
        msg = [NSString stringWithFormat:@"%@ minute wait", time];
    }
    return msg;
}

-(NSString *)relativeDateString
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit |
                           NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |
                           NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:update
                                                  toDate:[NSDate date]
                                                 options:0];
    
    NSInteger magnitude = 0;
    NSString *unit = nil;
    
    if([components year])
    {
        magnitude = [components year];
        unit = @"year";
    }
    else if([components month])
    {
        magnitude = [components month];
        unit = @"month";        
    }
    else if([components week])
    {
        magnitude = [components week];
        unit = @"week";
    }
    else if([components day])
    {
        magnitude = [components day];
        unit = @"day";
    }
    else if([components hour])
    {
        magnitude = [components hour];
        unit = @"hour";
    }
    else if([components minute])
    {
        magnitude = [components minute];
        unit = @"minute";
    }
    else if([components second])
    {
        magnitude = [components second];
        unit = @"second";
    }
    
    if(magnitude != 1)
    {
        unit = [unit stringByAppendingString:@"s"];
    }

    [gregorian release];
    
    return [NSString stringWithFormat:@"updated %d %@ ago", magnitude, unit];
    
}

@end
