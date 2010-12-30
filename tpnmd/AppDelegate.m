/*
     File: AppDelegate.m 
 Abstract: The application delegate class used for installing our navigation controller. 
  Version: 1.0
 */ 

#import "AppDelegate.h"
#import "MapViewController.h"
#import "WaitTimeImporter.h"

@implementation AppDelegate

@synthesize window, myNavController, mapViewController, importer;

- (void)dealloc
{
	[myNavController release];
    [window release];
	
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	
    // create an importer object to retrieve, parse, and import into the CoreData store 
    self.importer = [[[WaitTimeImporter alloc] init] autorelease];
    importer.delegate = self;
    importer.xmlURL = [NSURL URLWithString:@"http://www.rexhealth.com/_images/flash/rex_homepage_waittimes/rexwaitsettings.xml"];
		
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
    // add the importer to an operation queue for background processing
    [self.operationQueue addOperation:importer];
	
    // create window and set up table view controller
    [window addSubview:myNavController.view];
    [window makeKeyAndVisible];
}

- (NSOperationQueue *)operationQueue {
    if (operationQueue == nil) {
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return operationQueue;
}


#pragma mark <WaitTimeImporterDelegate> Implementation

- (void)importerDidParseWaitTime:(WaitTime *)waitTime
{
    [self performSelectorOnMainThread:@selector(handleImportData:) withObject:waitTime waitUntilDone:NO];
}

- (void)handleImportData:(WaitTime *)waitTime
{
    NSLog(@"in importerDidParseWaitTime: %@, %@, %@, %@, %@", waitTime.name, waitTime.type, waitTime.message, waitTime.time, waitTime.update);
    [mapViewController addWaitTimeData:waitTime];
}

// Helper method for main-thread processing of import completion.
- (void)handleImportCompletion
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.importer = nil;
}

// This method will be called on a secondary thread. Forward to the main thread for safe handling of UIKit objects.
- (void)importerDidFinishParsingData:(WaitTimeImporter *)importer
{
    [self performSelectorOnMainThread:@selector(handleImportCompletion) withObject:nil waitUntilDone:NO];
}

// Helper method for main-thread processing of errors received in the delegate callback below.
- (void)handleImportError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.importer = nil;
    // handle errors as appropriate to your application...
    NSAssert3(NO, @"Unhandled error in %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
}

// This method will be called on a secondary thread. Forward to the main thread for safe handling of UIKit objects.
- (void)importer:(WaitTimeImporter *)importer didFailWithError:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(handleImportError:) withObject:error waitUntilDone:NO];
}

@end
