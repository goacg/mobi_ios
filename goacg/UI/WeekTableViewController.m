//
//  WeekTableViewController.m
//  test
//
//  Created by mp on 13-8-13.
//  Copyright (c) 2013年 mp. All rights reserved.
//

#import "WeekTableViewController.h"
#import "WeekTableViewCell.h"
#import "SWRevealViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DataManager.h"
#import "Play.h"
#import "Album.h"

@interface WeekTableViewController ()
{
    NSDate* today;
    int today_index;
    int item_num;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

@end

@implementation WeekTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateComponents* today_comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    today = [[NSCalendar currentCalendar] dateFromComponents:today_comps];
    item_num = SHRT_MAX;
    today_index = SHRT_MAX/2;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.rightButton setTarget:self];
    [self.rightButton setAction:@selector(clickBackToday)];
    
    [self.leftButton setTarget:self.revealViewController];
    [self.leftButton setAction:@selector(revealToggle:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return item_num;
}

- (void)backTodayWithAnimate:(BOOL)animated
{
    NSIndexPath* ip = [NSIndexPath indexPathForRow:today_index inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WeekTableViewCell *cell = nil;
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0f  )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    NSAssert(cell != nil, @"cell invalid");
    
    // 颜色
    NSArray* arr = [NSArray arrayWithObjects:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0 alpha:1.0f],
                    [UIColor colorWithRed:255.0f/255.0f green:165.0f/255.0f blue:  0.0f/255.0 alpha:1.0f],
                    [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:  0.0f/255.0 alpha:1.0f],
                    [UIColor colorWithRed:  0.0f/255.0f green:255.0f/255.0f blue:  0.0f/255.0 alpha:1.0f],
                    [UIColor colorWithRed:  0.0f/255.0f green:127.0f/255.0f blue:255.0f/255.0 alpha:1.0f],
                    [UIColor colorWithRed:  0.0f/255.0f green:  0.0f/255.0f blue:255.0f/255.0 alpha:1.0f],
                    [UIColor colorWithRed:139.0f/255.0f green:  0.0f/255.0f blue:255.0f/255.0 alpha:1.0f],
                        nil];
    
    cell.labColor.backgroundColor = [arr objectAtIndex:(indexPath.row - today_index) % [arr count]];
    
    // 显示日期
    NSDate* date = [NSDate dateWithTimeInterval:3600 * 24 * (indexPath.row - today_index) sinceDate:today];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd EEEE"];
    cell.labTitle.text = [df stringFromDate:date];
    
    // 重置所有图标
    [cell.imgView0 setImage:[UIImage imageNamed:@"placeholder-icon.png"]];
    [cell.imgView1 setImage:[UIImage imageNamed:@"placeholder-icon.png"]];
    [cell.imgView2 setImage:[UIImage imageNamed:@"placeholder-icon.png"]];
    [cell.imgView3 setImage:[UIImage imageNamed:@"placeholder-icon.png"]];
    [cell.imgView4 setImage:[UIImage imageNamed:@"placeholder-icon.png"]];
    
    // 重置番数显示
    cell.labNum.text = @"0番";
    
    // 异步请求数据
    NSDate* beginDate = date;
    NSDate* endDate = [NSDate dateWithTimeInterval:3600 * 24 sinceDate:beginDate];
    [[DataManager sharedInstance] asyncQueryPlaysInTimeRange:beginDate
                                                  beforeTime:endDate
                                                  onComplete:^(NSArray* plays) {
                                                      cell.labNum.text = [NSString stringWithFormat:@"%d番", plays.count];
                                                      
                                                      if ( plays.count > 0 ) {
                                                          Play* play = plays[0];
                                                          [cell.imgView0 setImageWithURL:[NSURL URLWithString:play.album.icon_32x32] placeholderImage:[UIImage imageNamed:@"placeholder-icon.png"]];
                                                      }
                                                      if ( plays.count > 1 ) {
                                                          Play* play = plays[1];
                                                          [cell.imgView1 setImageWithURL:[NSURL URLWithString:play.album.icon_32x32] placeholderImage:[UIImage imageNamed:@"placeholder-icon.png"]];
                                                      }
                                                      if ( plays.count > 2 ) {
                                                          Play* play = plays[2];
                                                          [cell.imgView2 setImageWithURL:[NSURL URLWithString:play.album.icon_32x32] placeholderImage:[UIImage imageNamed:@"placeholder-icon.png"]];
                                                      }
                                                      if ( plays.count > 3 ) {
                                                          Play* play = plays[3];
                                                          [cell.imgView3 setImageWithURL:[NSURL URLWithString:play.album.icon_32x32] placeholderImage:[UIImage imageNamed:@"placeholder-icon.png"]];
                                                      }
                                                      if ( plays.count > 4 ) {
                                                          Play* play = plays[4];
                                                          [cell.imgView4 setImageWithURL:[NSURL URLWithString:play.album.icon_32x32] placeholderImage:[UIImage imageNamed:@"placeholder-icon.png"]];
                                                      }
                                                  } onFail:^(void){
                                                      
                                                  }];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self backTodayWithAnimate:NO];
    
    [super viewWillAppear:animated];
}

- (void)clickBackToday
{
    [self backTodayWithAnimate:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if ( scrollView.contentOffset.y == 0 )
//    {
//        today_index += 5;
//        item_num += 5;
//        [self.tableView reloadData];
//        NSIndexPath* ip = [NSIndexPath indexPathForRow:5 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    }
//    else if ( scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height - 50 )
//    {
//        item_num += 5;
//        [self.tableView reloadData];
//    }
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
