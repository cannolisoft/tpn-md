/**
 * File: DetailViewController.m 
 * Description: The controller used for displaying a medical office. 
 */

#import "DetailViewController.h"
#import "OfficeAnnotation.h"

@implementation DetailViewController
@synthesize table, imageView, annotation;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib
- (void)viewDidLoad
{
    [super viewDidLoad];	
}


- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
}

-(void)viewWillAppear:(BOOL)animated
{       
  UIImage *hospitalImage = [annotation getUIImage];
  [imageView setImage: hospitalImage];
  [imageView setNeedsDisplay];
}



- (void)dealloc
{
    [super dealloc];
}

- (void)setAnnotation:(id <MKAnnotation>)newAnnotation
{       
	annotation = newAnnotation;

	[table reloadData];
	
	self.navigationItem.title =  [self.annotation title];
}


#pragma mark -
#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  return indexPath;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

  // Deselect the chosen row, making it more like a button
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
  if ( indexPath.section != 0 )
  {
    NSString* uri = [NSString stringWithFormat:@"tel:%@", [annotation phone]];
    NSURL *url = [NSURL URLWithString:uri];
    [[UIApplication sharedApplication] openURL:url];	 
  }
  else
  {

    NSString* startAddr = [NSString stringWithFormat:@"%@,%@", [annotation address], [annotation address2]];
    NSString* urlAddr = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current Location&daddr=%@", startAddr];

    NSURL* url = [NSURL URLWithString:[urlAddr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];

    [[UIApplication sharedApplication] openURL:url];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return 80;
	}
	
	return [tableView rowHeight];
}



#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
	}
	

	
	
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = @"Address";
			cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.detailTextLabel.numberOfLines = 5;
			cell.detailTextLabel.text = annotation.subtitle;
			break;
		case 1:
			cell.textLabel.text = @"Telephone";
			cell.detailTextLabel.text = annotation.phone;
			break;
		default:
			break;
	}
	
	
	return cell;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Number of sections is based on the data
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

@end
