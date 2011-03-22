/**
 * File: AppDelegate.m 
 * Description: Application delegate class used for
 *              installing our navigation controller. 
 */ 

#import "AppDelegate.h"
#import "WaitTimeImporter.h"

#import "Office.h"

static NSString* REXURL = @"http://www.rexhealth.com/rexwaitsettings.xml";

@implementation AppDelegate

@synthesize window;
@synthesize tabBarController, myNavController, mapViewController, tableViewController, docTableViewController;
@synthesize importer;

- (void)dealloc
{
    [myNavController release];
    [window release];
	
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{	    
    mapViewController.context = [self managedObjectContext];
    tableViewController.context = [self managedObjectContext];
    docTableViewController.context = [self managedObjectContext];
    
    // create an importer object to retrieve, parse, and import into the CoreData store 
    self.importer = [[[WaitTimeImporter alloc] init] autorelease];
    importer.delegate = self;
    importer.xmlURL = [NSURL URLWithString: REXURL];
		
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
    // add the importer to an operation queue for background processing
    [self.operationQueue addOperation:importer];
    
    // create window and set up table view controller
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
}

- (NSOperationQueue *)operationQueue {
    if (operationQueue == nil) {
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return operationQueue;
}


#pragma mark -
#pragma mark ButtonActions

- (IBAction)listAction:(id)sender
{
    [UIView transitionFromView:mapViewController.view
                        toView:tableViewController.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished){
                        [myNavController 
                         setViewControllers:[NSArray arrayWithObject:tableViewController]
                         animated:NO];
                    }
     ];
}

- (IBAction)mapAction:(id)sender
{
    [UIView transitionFromView:tableViewController.view
                        toView:mapViewController.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished){
                        [myNavController 
                         setViewControllers:[NSArray arrayWithObject:mapViewController]
                         animated:NO];
                    }
     ];
}


#pragma mark <WaitTimeImporterDelegate> Implementation

- (void)importerDidParseWaitTime:(WaitTime *)waitTime
{
    [self performSelectorOnMainThread:@selector(handleImportData:) withObject:waitTime waitUntilDone:NO];
}

- (void)handleImportData:(WaitTime *)waitTime
{
    //TODO: reimplement
    //[officeModel addWaitTimeData:waitTime];
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

    //TODO: How to handle failures retrieving wait time?
}

// This method will be called on a secondary thread. Forward to the main thread for safe handling of UIKit objects.
- (void)importer:(WaitTimeImporter *)importer didFailWithError:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(handleImportError:) withObject:error waitUntilDone:NO];
}





#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Office" withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    //managedObjectModel_ = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"tpnmd.sqlite"];    
    
    // Put down default db if it doesn't already exist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] 
                                      pathForResource:@"tpnmd" ofType:@"sqlite"];
        if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:NULL];
        }
    }
    
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
