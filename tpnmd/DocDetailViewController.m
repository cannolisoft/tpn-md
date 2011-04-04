/**
 * File: DetailViewController.m 
 * Description: The controller used for displaying a medical office. 
 */

#import <QuartzCore/QuartzCore.h>
#import "DocDetailViewController.h"
#import "DetailViewController.h"

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
    //Specialty *special = [[doc.specialty allObjects] objectAtIndex:indexPath.row];
    switch (indexPath.section)
    {
        case SPECIALTY_CELL:
        {
            Specialty* special = [[doc.specialty allObjects] objectAtIndex:indexPath.row];
            return special.name;
        }
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


- (BOOL)hasSectionText:(NSInteger)section
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:section];
    NSString *str = [self getSectionText:path];
    return str && [str length];
}

- (NSIndexPath *)getTranslatedIndexPath:(NSIndexPath *)indexPath
{
    NSNumber* section = [sections objectAtIndex:indexPath.section];
    return [NSIndexPath indexPathForRow:indexPath.row inSection:[section integerValue]];
}

- (NSInteger)getTranslatedSection:(NSInteger)section
{
    NSNumber* translatedSection = [sections objectAtIndex:section];
    return [translatedSection integerValue];
}


- (void)dealloc
{
    [table release];
    [headerLabel release];
    [doc release];
    [sections release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    sections = [[NSMutableArray arrayWithCapacity:CELL_COUNT] retain];
    for (int i=0; i<CELL_COUNT; i++)
    {
        if( [self hasSectionText:i] )
        {
            [sections addObject:[NSNumber numberWithInt:i]];
        }
    }
}


- (void)viewDidUnload
{
    [sections release];
    
    [super viewDidUnload];	
}

-(void)viewWillAppear:(BOOL)animated
{           
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Physician";
    
    self.headerLabel.text = self.doc.name;
    
    [table reloadData];
}




#pragma mark -
#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* translatedPath = [self getTranslatedIndexPath:indexPath];
    switch ( translatedPath.section )
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
    
    NSIndexPath* translatedPath = [self getTranslatedIndexPath:indexPath];
    if ( translatedPath.section == OFFICE_CELL )
    {
        //TODO: open office detail
        
        
        DetailViewController *detail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        
        
        // The detail view does not want a toolbar so hide it
        //detail.hidesBottomBarWhenPushed = YES;
        
        detail.office = doc.office;
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
        
	 
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
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
        cell.detailTextLabel.numberOfLines = 0;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    
    NSIndexPath* translatedPath = [self getTranslatedIndexPath:indexPath];
    cell.detailTextLabel.text = [self getSectionText:translatedPath];
    
    if(translatedPath.section == OFFICE_CELL)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Number of sections is based on the data
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger translatedSection = [self getTranslatedSection:section];
    if( translatedSection == SPECIALTY_CELL )
    {
        return [doc.specialty count];
    }
    
    
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger translatedSection = [self getTranslatedSection:section];
    return [self getSectionLabel:translatedSection];
}

@end
