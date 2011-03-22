/**
 * File: WaitTimeImporter.m
 * Description: Downloads, parses, and provides the wait times xml.
 */

#import "WaitTimeImporter.h"
#import <libxml/tree.h>

// Function prototypes for SAX callbacks.
static void startElementSAX(void *context, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI, int nb_namespaces, const xmlChar **namespaces, int nb_attributes, int nb_defaulted, const xmlChar **attributes);
static void errorEncounteredSAX(void *context, const char *errorMessage, ...);


// Forward reference. The structure is defined in full at the end of the file.
static xmlSAXHandler simpleSAXHandlerStruct;

// Class extension for private properties and methods.
@interface WaitTimeImporter ()

@property BOOL done;
@property (nonatomic, retain) NSURLConnection *xmlConnection;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

// The autorelease pool property is assign because autorelease pools cannot be retained.
@property (nonatomic, assign) NSAutoreleasePool *importPool;

@end

@implementation WaitTimeImporter

@synthesize xmlURL, delegate, done, xmlConnection, dateFormatter, importPool;


- (void)dealloc {
    [xmlURL release];
    [xmlConnection release];
    [dateFormatter release];
    [super dealloc];
}

- (void) main
{
    self.importPool = [[NSAutoreleasePool alloc] init];
    done = NO;
	
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:xmlURL];

    // Create the connection with the request and start loading the data
    xmlConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
    context = xmlCreatePushParserCtxt(&simpleSAXHandlerStruct, self, NULL, 0, NULL);
    if (xmlConnection != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }

    // Release resources used only in this thread.
    xmlFreeParserCtxt(context);
    self.dateFormatter = nil;
    self.xmlConnection = nil;
	
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(importerDidFinishParsingData:)]) {
        [self.delegate importerDidFinishParsingData:self];
    }
    
    [importPool release];
    self.importPool = nil;
}

- (void) forwardError:(NSError *) error
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(importer:didFailWithError:)]) {
        [self.delegate importer:self didFailWithError:error];
    }
}

#pragma mark NSURLConnection Delegate methods

// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(forwardError:) withObject:error waitUntilDone:NO];
    // Set the condition which ends the run loop.
    done = YES;
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Process the downloaded chunk of data.
    xmlParseChunk(context, (const char *)[data bytes], [data length], 0);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Signal the context that parsing is complete by passing "1" as the last parameter.
    xmlParseChunk(context, NULL, 0, 1);

    // Set the condition which ends the run loop.
    done = YES; 
}

@end

#pragma mark SAX Parsing Callbacks

// The following constants are the XML element names and their string lengths for parsing comparison.
// The lengths include the null terminator, to ensure exact matches.
static const char *kName_Location = "location";
static NSString *kName_Name = @"name";
static NSString *kName_Type = @"type";
static NSString *kName_Message = @"message";
static NSString *kName_Time = @"time";
static NSString *kName_Update = @"prettyDate";


/*
 This callback is invoked when the importer finds the beginning of a node in the XML. For this application,
 out parsing needs are relatively modest - we need only match the node name. An "item" node is a record of
 data about a song. In that case we create a new Song object. The other nodes of interest are several of the
 child nodes of the Song currently being parsed. For those nodes we want to accumulate the character data
 in a buffer. Some of the child nodes use a namespace prefix. 
 */
static void startElementSAX(void *parsingContext, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI, 
                            int nb_namespaces, const xmlChar **namespaces, int nb_attributes, int nb_defaulted, const xmlChar **attributes) {
    
    WaitTimeImporter *importer = (WaitTimeImporter *)parsingContext;

    if(!strcmp((const char *)localname, kName_Location))
    {
        WaitTime *waitTime = [[WaitTime alloc] init];
    
        NSString *name = nil;
        NSString *value = nil;
        int valueLen = 0;
    
        for ( int i = 0; i < nb_attributes; i++ )
        {
            name = [NSString stringWithCString:(const char*)attributes[0] encoding:NSUTF8StringEncoding];
        
            valueLen = attributes[4] - attributes[3];
            value = [[NSString alloc] initWithBytes:attributes[3] length:valueLen encoding:NSUTF8StringEncoding];

            if([name isEqualToString: kName_Name])
            {
                waitTime.name = value;
            }
            else if([name isEqualToString: kName_Type])
            {
                waitTime.type = value;
            }
            else if([name isEqualToString: kName_Message])
            {
                waitTime.message = value;
            }
            else if([name isEqualToString: kName_Time])
            {
                waitTime.time = value;
            }
            else if([name isEqualToString: kName_Update])
            {
                waitTime.update = [importer.dateFormatter dateFromString: value];
            }
        
            [value release];
        
            attributes += 5;
        }
        
        if (importer.delegate != nil && [importer.delegate respondsToSelector:@selector(importerDidParseWaitTime:)])
        {
            [importer.delegate importerDidParseWaitTime:waitTime];
            [waitTime autorelease];
        }
        else 
        {
            [waitTime release];
        }
    }
}

/*
 A production application should include robust error handling as part of its parsing implementation.
 The specifics of how errors are handled depends on the application.
 */
static void errorEncounteredSAX(void *parsingContext, const char *errorMessage, ...) {
    // Handle errors as appropriate for your application.
    NSCAssert(NO, @"Unhandled error encountered during SAX parse.");
}

// The handler struct has positions for a large number of callback functions. If NULL is supplied at a given position,
// that callback functionality won't be used. Refer to libxml documentation at http://www.xmlsoft.org for more information
// about the SAX callbacks.
static xmlSAXHandler simpleSAXHandlerStruct = {
NULL,                       /* internalSubset */
NULL,                       /* isStandalone   */
NULL,                       /* hasInternalSubset */
NULL,                       /* hasExternalSubset */
NULL,                       /* resolveEntity */
NULL,                       /* getEntity */
NULL,                       /* entityDecl */
NULL,                       /* notationDecl */
NULL,                       /* attributeDecl */
NULL,                       /* elementDecl */
NULL,                       /* unparsedEntityDecl */
NULL,                       /* setDocumentLocator */
NULL,                       /* startDocument */
NULL,                       /* endDocument */
NULL,                       /* startElement*/
NULL,                       /* endElement */
NULL,                       /* reference */
NULL,						/* characters */
NULL,                       /* ignorableWhitespace */
NULL,                       /* processingInstruction */
NULL,                       /* comment */
NULL,                       /* warning */
errorEncounteredSAX,        /* error */
NULL,                       /* fatalError //: unused error() get all the errors */
NULL,                       /* getParameterEntity */
NULL,                       /* cdataBlock */
NULL,                       /* externalSubset */
XML_SAX2_MAGIC,             //
NULL,
startElementSAX,            /* startElementNs */
NULL,						/* endElementNs */
NULL,                       /* serror */
};
