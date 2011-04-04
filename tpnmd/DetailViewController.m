/**
 * File: DetailViewController.m 
 * Description: The controller used for displaying a medical office. 
 */

#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"

enum
{
  WAITTIME_CELL,
  ADDRESS_CELL,
  TELEPHONE_CELL,

  PHYSICIANS_SECTION,
    
  CELL_COUNT /* Must always be last entry */
};

@implementation DetailViewController
@synthesize headerLabel, headerImageView, office;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];	
}

-(void)viewWillAppear:(BOOL)animated
{           
    [super viewWillAppear:animated];
    
    self.navigationItem.title = office.type;
    
    self.headerLabel.text = self.office.name;
    
    [self.tableView reloadData];
    
    //TODO: add back in functionality
    //[self.headerImageView setImage: [UIImage imageNamed:self.office.imagePath]];
    
    
    UIBarButtonItem *actionBtn = [[UIBarButtonItem alloc]
                          initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
                          target:self 
                          action:@selector(showAction)];
    self.navigationItem.rightBarButtonItem = [actionBtn autorelease];
}


- (void)dealloc
{

    [headerLabel release];
    [headerImageView release];
    
    [office release];
    
    [super dealloc];
}


- (NSInteger)getTranslatedSection:(NSInteger)section
{
    if(!office.waitTime)
    {
        return section + 1;
    }
    return section;
}


- (void) callCenter
{
    NSString* uri = [NSString stringWithFormat:@"tel:%@", office.phone];
    NSURL *url = [NSURL URLWithString:uri];
    [[UIApplication sharedApplication] openURL:url];
}


- (void) directionsToCenter
{
    NSString* startAddr = [office fullAddress:NO];
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
    switch ([self getTranslatedSection:indexPath.section])
    {
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
        
        if(office.waitTime)
        {
            cell.textLabel.text = [office.waitTime waitMsg];
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            
            cell.detailTextLabel.text = [office.waitTime relativeDateString];
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
            cell.textLabel.text = [office fullAddress:TRUE];
            
            imagePath = @"building.png"; 
        }
        //phone cell
        else if(section == TELEPHONE_CELL)
        {
            cell.textLabel.text = office.phone;
            
            imagePath = @"phone.png";
        }
        else if(section == PHYSICIANS_SECTION)
        {                             
            NSSortDescriptor *descrip = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            NSArray *docs = [[office.physicians allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descrip]];
         
            Physician *doc = [docs objectAtIndex:indexPath.row];
            cell.textLabel.text = doc.name;
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
    else
    {
        [cell.imageView setImage: nil];
    }

    return cell;
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Number of sections is based on the data
    if(!office.waitTime)
    {
        return CELL_COUNT-1;
    }
    return CELL_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger newSection = [self getTranslatedSection:section];
    //wait time cell
    if(newSection == PHYSICIANS_SECTION)
    {
        NSSet *docs = office.physicians;
        NSInteger size = [docs count];
        return size;
    }
    
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger newSection = [self getTranslatedSection:section];
    if(newSection == PHYSICIANS_SECTION && office.physicians && [office.physicians count])
    {
        return @"Physicians";
    }
    return nil;
}

@end
