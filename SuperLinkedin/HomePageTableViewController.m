//
//  HomePageTableViewController.m
//  SuperLinkedin
//
//  Created by Eric Wu on 8/10/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import "HomePageTableViewController.h"
#import "CompanyTableViewCell.h"
#import "SWRevealViewController.h"
#import "CompanyDetailViewController.h"

@interface HomePageTableViewController ()

@property (nonatomic, strong)NSArray *companies;

@end

@implementation HomePageTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self =[super initWithCoder:aDecoder];
    if (self) {
        self.parseClassName = @"Company";

        //self.textKey = @"name";

        self.pullToRefreshEnabled = YES;

        self.paginationEnabled = YES;
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Change button color
    _sideBarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    return query;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"CompanyInfoCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"CompanyInfoCell";
    
    CompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[CompanyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *nameLabel = (UILabel *) [cell viewWithTag:101];
    nameLabel.text = [object objectForKey:@"name"];
    
    UILabel *desLabel = (UILabel *) [cell viewWithTag:105];
    desLabel.text = [object objectForKey:@"description"];
    
    UILabel *locationLabel = (UILabel *) [cell viewWithTag:102];
    
    NSString *city = [object objectForKey:@"city"];
    NSString *state = [object objectForKey:@"state"];
    NSString *loc_display = [NSString stringWithFormat:@"%@, %@", city, state];
    
    locationLabel.text = loc_display;
    
    UILabel *sizeLabel = (UILabel *) [cell viewWithTag:103];
    sizeLabel.text = [object objectForKey:@"size"];
    
    UILabel *typeLabel = (UILabel *) [cell viewWithTag:104];
    typeLabel.text = [object objectForKey:@"type"];
    
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:106];
    NSString *url_str = [object objectForKey:@"image_url"];
    
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url_str]]];
    
    // add vertical margin between cells
    UIView *cellSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320,5)];
    [cellSeparator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleWidth];
    [cellSeparator setContentMode:UIViewContentModeTopLeft];
    [cellSeparator setBackgroundColor:[UIColor lightGrayColor]];
    [cell addSubview:cellSeparator];
    
    // delete right arrow in cell
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"referMe"]) {
        UITableViewCell *selectedCell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        CompanyDetailViewController *companyDetailViewController = (CompanyDetailViewController *)segue.destinationViewController;
        
        companyDetailViewController.company = object;
        
    }
}


@end
