/**
 * File: DetailViewController.m 
 * Description: The controller used for displaying a medical office. 
 */

#import <QuartzCore/QuartzCore.h>
#import "DocDetailViewController.h"

enum
{
    SPECIALTY_CELL,
    OFFICE_CELL,
    CERT_CELL,
    SCHOOL_CELL,
    RESIDENCE_CELL,
    GENDER_CELL,

    CELL_COUNT /* Must always be last entry */
};

@implementation DocDetailViewController

@synthesize table, headerLabel, doc;

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
    
    self.navigationItem.title = @"Physician";
    
    self.headerLabel.text = self.doc.name;
    
    [table reloadData];
}


- (void)dealloc
{
    doc = nil;
    
    [super dealloc];
}

- (NSInteger)getTranslatedSection:(NSInteger)section
{
    return section;
}

- (NSString *)getSectionLabel:(NSInteger)section
{
    switch (section)
    {
        case SPECIALTY_CELL:
            return @"Specialty";
        case OFFICE_CELL:
            return @"Office";
        case CERT_CELL:
            return @"Certification";
        case SCHOOL_CELL:
            return @"Medical School";
        case RESIDENCE_CELL:
            return @"Residency";
        case GENDER_CELL:
            return @"Gender";
        default:
            return nil;
    }
}

- (NSString *)getSectionText:(NSIndexPath *)indexPath
{
    //NSArray *specialties = [[doc.specialty allObjects] valueForKeyPath:@"@unionOfObjects.name"];
    Specialty *special = [[doc.specialty allObjects] objectAtIndex:indexPath.row];
    switch (indexPath.section)
    {
        case SPECIALTY_CELL:

            return special.name;
        case OFFICE_CELL:
            return doc.office.name;
        case CERT_CELL:
            return doc.certification;
        case SCHOOL_CELL:
            return doc.school;
        case RESIDENCE_CELL:
            return doc.residency;
        case GENDER_CELL:
            return doc.gender;
        default:
            return nil;
    }
}


#pragma mark -
#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self getTranslatedSection:indexPath.section])
    {
        case OFFICE_CELL:
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
    if ( section == OFFICE_CELL )
    {
        //TODO: open office detail
	 
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [self getSectionText:indexPath];
    if(!text || ![text length])
    {
        return 0;
    }


    
    CGSize constraintSize = CGSizeMake(200 , MAXFLOAT);
    CGSize labelSize = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
                            constrainedToSize:constraintSize
                                lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 20;
    
    
    //return [tableView rowHeight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    //cell.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DefaultCellIdentifier = @"defaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DefaultCellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:DefaultCellIdentifier] autorelease];
        //cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.numberOfLines = 0;
            cell.backgroundColor = [UIColor whiteColor];
        //cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
    }
    
    //NSInteger section = [self getTranslatedSection:indexPath.section];
    //cell.textLabel.text = [self getSectionLabel:section];
    cell.detailTextLabel.text = [self getSectionText:indexPath];
    
    if(!cell.detailTextLabel.text || ![cell.detailTextLabel.text length])
    {
        cell.hidden = YES;
    }
    
    return cell;
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Number of sections is based on the data
    return CELL_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger newsection = [self getTranslatedSection:section];
    if(newsection == SPECIALTY_CELL)
    {
        return [doc.specialty count];
    }
    
    
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger newsection = [self getTranslatedSection:section];
    return [self getSectionLabel:newsection];
    //return nil;
}

@end
