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
    if (indexPath.section == 0)
    {
        return 80;
    }
    
    return [tableView rowHeight];
}



#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    NSString *imagePath = nil;
    
    //wait time cell
    if(indexPath.section == 2)
    {
        static NSString *SubtitleCellIdentifier = @"subtitleCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:SubtitleCellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SubtitleCellIdentifier] autorelease];
        }
        
        if(annotation.waitTime)
        {
            cell.textLabel.text = [annotation.waitTime waitMsg];
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            
            cell.detailTextLabel.text = [annotation.waitTime relativeDateString];
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            
            imagePath = @"clock.png";
        }
        else
        {
            cell.hidden = YES;
        }

    }
    else
    {
        static NSString *DefaultCellIdentifier = @"defaultCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:DefaultCellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DefaultCellIdentifier] autorelease];
        }
        
        //address cell
        if(indexPath.section == 0)
        {
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.numberOfLines = 5;
            cell.textLabel.text = annotation.subtitle;
            
            imagePath = @"building.png"; 
        }
        //phone cell
        else if(indexPath.section == 1)
        {
            cell.textLabel.text = annotation.phone;
            
            imagePath = @"phone.png";
        }
        else
        {
            cell.hidden = YES;
        }
    }
    
    if ( imagePath != nil )
    {
        [cell.imageView setImage: [UIImage imageNamed: imagePath]];
    }
    return cell;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Number of sections is based on the data
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

@end
