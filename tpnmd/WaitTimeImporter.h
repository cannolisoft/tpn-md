/**
 *   File: WaitTimeImporter.h
 *   Definition: Downloads, parses, and provides the wait times xml.
 */

#import <UIKit/UIKit.h>
#import <libxml/tree.h>
#import "WaitTime.h"

@class WaitTimeImporter;

// Protocol for the importer to communicate with its delegate.
@protocol WaitTimeImporterDelegate <NSObject>

@optional
// Called by the importer when parsing is finished.
- (void)importerDidParseWaitTime:(WaitTime *)waitTime;
// Called by the importer when parsing is finished.
- (void)importerDidFinishParsingData:(WaitTimeImporter *)importer;
// Called by the importer in the case of an error.
- (void)importer:(WaitTimeImporter *)importer didFailWithError:(NSError *)error;

@end


@interface WaitTimeImporter : NSOperation {
@private
    id <WaitTimeImporterDelegate> delegate;
	
    // Reference to the libxml parser context
    xmlParserCtxtPtr context;
	
    // Overall state of the importer, used to exit the run loop.
    BOOL done;
	
    NSDateFormatter *dateFormatter;
    NSURL *xmlURL;
    NSURLConnection *xmlConnection;
}

@property (nonatomic, retain) NSURL *xmlURL;
@property (nonatomic, assign) id <WaitTimeImporterDelegate> delegate;

- (void)main;

@end
