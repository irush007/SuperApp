//
//  MessageCenterTableViewController.m
//  SuperLinkedin
//
//  Created by Eric Wu on 8/31/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import "MessageCenterTableViewController.h"
#import "UserClass.h"
#import "ReplyTableViewCell.h"
#import "RequestTableViewCell.h"

@interface MessageCenterTableViewController ()
@property (nonatomic, retain) NSMutableArray *refer_replies;
@property (nonatomic, retain) NSMutableArray *refer_requests;
@property (nonatomic, retain) UserClass *user_class;
@property (nonatomic, retain) NSNumber *MAXIMU_REQUEST_COUT;

@end

@implementation MessageCenterTableViewController
@synthesize refer_replies = _refer_replies;
@synthesize refer_requests = _refer_requests;
@synthesize user_class = _user_class;

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
        self.parseClassName = @"MessageBox";
        
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        
        self.refer_replies = [[NSMutableArray alloc] init];
        self.refer_requests = [[NSMutableArray alloc] init];
        
        self.user_class = [UserClass getInstance];
        
        self.MAXIMU_REQUEST_COUT = [[NSNumber alloc] initWithInt:4];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ReplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"replyCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RequestTableViewCell" bundle:nil] forCellReuseIdentifier:@"requestCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.refer_requests count];
    } else {
        return [self.refer_replies count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"replyCell";
    
        ReplyTableViewCell *cell = (ReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReplyTableViewCell" owner:self options:nil];
            cell = (ReplyTableViewCell *)[nib objectAtIndex:0];
        }
        
        PFObject *reply_single_obj = [self.refer_replies objectAtIndex:indexPath.row];
        PFObject *reqest_relation_to_reply_obj = reply_single_obj[@"request"];
        
        cell.replyLabel.text = @"testing";
        
        return cell;
        
    } else {
        static NSString *CellIdentifier = @"requestCell";
        
        RequestTableViewCell *cell = (RequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RequestTableViewCell" owner:self options:nil];
            cell = (RequestTableViewCell *)[nib objectAtIndex:0];
        }
        
        PFObject *request_obj = [self.refer_requests objectAtIndex:indexPath.row];
        PFObject *requester_obj = request_obj[@"from"];
        
        NSLog(@"The Requester is : %@", requester_obj);
        
        NSString *name = requester_obj[@"formattedName"];
        NSString *image_url = [requester_obj objectForKey:@"picture_url"];
        NSString *position = request_obj[@"position"];
        PFObject *company = [requester_obj objectForKey:@"company"];
        NSString *company_name = [company objectForKey:@"name"];
        
        NSLog(@"the image url is %@", image_url);
        
        NSString *label_text = [NSString stringWithFormat:@"%@ sent you the request for %@ at %@", name, position,company_name];
        
        
        cell.userIconImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]]];
        
        cell.requestLabel.text = label_text;
        
        return cell;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Your pending request";
    }
    else {
        return @"Reply";
    }
}

- (PFQuery *)queryForTable {
    NSLog(@"User is %@", self.user_class.appUser);
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"owner" equalTo:self.user_class.appUser];
    [query includeKey:@"requests"];
    [query includeKey:@"replies"];
    [query includeKey:@"requests.from"];
    [query includeKey:@"requests.from.company"];
    
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    //[self.refer_requests removeAllObjects];
    //[self.refer_replies removeAllObjects];
    
    if ([self.objects count] == 0) {
        // create a message box obj for this user
        
    } else {
        _dataArray = [[NSMutableArray alloc] init];
        
        NSLog(@"The object got is %@", self.objects);
        
        self.refer_requests = [self.objects[0] objectForKey:@"requests"];
        self.refer_replies = [self.objects[0] objectForKey:@"replies"];
        
        NSLog(@"The object is : %@", [self.objects[0] objectForKey:@"replies"]);
        NSLog(@"the length of replies is : %i", [self.refer_replies count]);
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
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
