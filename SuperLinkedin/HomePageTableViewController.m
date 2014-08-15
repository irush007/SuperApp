//
//  HomePageTableViewController.m
//  SuperLinkedin
//
//  Created by Eric Wu on 8/10/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import "HomePageTableViewController.h"
#import "CompanyTableViewCell.h"

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

        self.paginationEnabled = NO;
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
