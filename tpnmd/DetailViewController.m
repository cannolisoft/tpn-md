/**
 * File: DetailViewController.m 
 * Description: The controller used for displaying a medical office. 
 */

#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "OfficeAnnotation.h"

enum
{
  WAITTIME_CELL,
  ADDRESS_CELL,
  TELEPHONE_CELL,
    
  CELL_COUNT /* Must always be last entry */
};

@implementation DetailViewController
@synthesize table, headerLabel, headerImageView, annotation;

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
    //UIImage *hospitalImage = [annotation getUIImage];
    //[imageView setImage: hospitalImage];
    //[imageView setNeedsDisplay];
    
    self.headerLabel.text = [self.annotation title];
    
    //self.headerImageView.layer.masksToBounds = YES;
    //self.headerImageView.layer.cornerRadius = 10.0;
    [self.headerImageView setImage: [UIImage imageNamed:self.annotation.imagePath]];
    
    
    UIBarButtonItem *actionBtn = [[UIBarButtonItem alloc]
                          initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
                          target:self 
                          action:@selector(showAction)];
    self.navigationItem.rightBarButtonItem = [actionBtn autorelease];
}


- (void)dealloc
{
    [super dealloc];
}

- (void)setAnnotation:(id <MKAnnotation>)newAnnotation
{       
    annotation = newAnnotation;

    [table reloadData];
    
    
    if(annotation.type)
    {
        self.navigationItem.title = annotation.type;
    }else {
        self.navigationItem.title = @"Practice";
    }

}


- (NSInteger)getTranslatedSection:(NSInteger)section
{
    if(!annotation.waitTime)
    {
        return section + 1;
    }
    return section;
}


- (void) callCenter {
    NSString* uri = [NSString stringWithFormat:@"tel:%@", [annotation phone]];
    NSURL *url = [NSURL URLWithString:uri];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) directionsToCenter {
    NSString* startAddr = [NSString stringWithFormat:@"%@,%@", [annotation address], [annotation address2]];
    NSString* urlAddr = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current Location&daddr=%@", startAddr];
    NSURL* url = [NSURL URLWithString:[urlAddr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark -
#pragma mark ButtonActions

- (void)showAction
{
    
    UIActionSheet *filterAlert = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Directions", @"Call",
                                  nil, nil];
    
    
    
    filterAlert.actionSheetStyle = self.navigationController.navigationBar.barStyle;
    [filterAlert showInView: self.view];
    [filterAlert release];
}


#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            // Get Directions
            [self directionsToCenter];
            break;
        case 1:
            // Call number
            [self callCenter];
            break;
        default:
            break;
    }
}



#pragma mark -
#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self getTranslatedSection:indexPath.section]) {
        case ADDRESS_CELL:
        case TELEPHONE_CELL:
            return indexPath;
            break;
        default:
            return nil;
            break;
    }
}


- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect the chosen row, making it more like a button
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
          
    NSInteger section = [self getTranslatedSection:indexPath.section];
    if ( section == TELEPHONE_CELL )
    {
        [self callCenter];
	 
    }
    else if ( section == ADDRESS_CELL )
    {
        [self directionsToCenter];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [self getTranslatedSection:indexPath.section];
    if (section == ADDRESS_CELL)
    {
        return 90;
    }
    
    return [tableView rowHeight];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    NSString *imagePath = nil;
    
    NSInteger section = [self getTranslatedSection:indexPath.section];
    //wait time cell
    if(section == WAITTIME_CELL)
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
            cell.detailTextLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            
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
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DefaultCellIdentifier] autorelease];
        }
        
        //address cell
        if(section == ADDRESS_CELL)
        {
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.numberOfLines = 5;
            cell.textLabel.text = annotation.subtitle;
            
            imagePath = @"building.png"; 
        }
        //phone cell
        else if(section == TELEPHONE_CELL)
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

/*
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSInteger oSection = [self getTranslatedSection:section];
    if(oSection == WAITTIME_CELL)
    {
        return [annotation.waitTime relativeDateString];
    }
    return nil;
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Number of sections is based on the data
    if(!annotation.waitTime)
    {
        return CELL_COUNT-1;
    }
    return CELL_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

@end
