//
//  AddNewAccesoryViewController.m
//  SampleHomeKit
//
//  Created by Porwal, Animesh on 7/3/14.
//  Copyright (c) 2014 AP. All rights reserved.
//

#import "AddNewAccesoryViewController.h"

@interface AddNewAccesoryViewController (){
    HMAccessoryBrowser *accessoryBrowser;
    NSMutableArray *newAccessories;
}

@end

@implementation AddNewAccesoryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    accessoryBrowser = [[HMAccessoryBrowser alloc] init];
    accessoryBrowser.delegate = self;
    
    newAccessories = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [accessoryBrowser startSearchingForNewAccessories];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [accessoryBrowser stopSearchingForNewAccessories];
}
- (IBAction)doneAddingAccessories:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView datasource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return newAccessories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newAccessoryCell" forIndexPath:indexPath];
    
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"accessoryCell"];
    //    }
    
    cell.textLabel.text = [[newAccessories objectAtIndex:indexPath.row] name];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.homeManager.primaryHome addAccessory:[newAccessories objectAtIndex:indexPath.row] completionHandler:^(NSError *error){
        
        if (error) {
            NSLog(@"error in adding accessory: %@", error);
        }
    }];
    
}

#pragma mark - HMAccessoryBrowserDelegate

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory {
    
    [newAccessories addObject:accessory];
    [self.accessoryTableView reloadData];
}

-(void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory {
    
    [newAccessories removeObject:accessory];
    [self.accessoryTableView reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
