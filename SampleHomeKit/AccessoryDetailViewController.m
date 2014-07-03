//
//  AccessoryDetailViewController.m
//  SampleHomeKit
//
//  Created by Porwal, Animesh on 7/3/14.
//  Copyright (c) 2014 AP. All rights reserved.
//

#import "AccessoryDetailViewController.h"
#import "ServiceDetailsViewController.h"

@interface AccessoryDetailViewController (){
    NSMutableArray *accessoryServices;
}

@end

@implementation AccessoryDetailViewController

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
    
    self.title = self.selectedAccessory.name;
    [self updateTableViewData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    accessoryServices = [[NSMutableArray alloc] init];
    
    if (self.selectedAccessory) {
        [self updateTableViewData];
    }
}

-(void) updateTableViewData {
    
    for (HMService *service in self.selectedAccessory.services) {
        [accessoryServices addObject:service];
        [self.serviceTableView reloadData];
    }
}

#pragma mark - Button Action

- (IBAction)renameAccessory:(id)sender {
    
 //   __weak typeof (self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Rename Accessory" message:@"Type new name for this accessory" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:nil];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Rename" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        UITextField *textField = alertController.textFields[0];
        
        [self.selectedAccessory updateName:textField.text completionHandler:^(NSError *error){
            
            self.title = self.selectedAccessory.name;
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - TableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return accessoryServices.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accessoryDetailCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[accessoryServices objectAtIndex:indexPath.row] name];
    cell.detailTextLabel.text = [[accessoryServices objectAtIndex:indexPath.row] serviceType];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *indexPath = [self.serviceTableView indexPathForSelectedRow];
    
    ServiceDetailsViewController *serviceDetailsVC = (ServiceDetailsViewController*)[segue destinationViewController];
    serviceDetailsVC.selectedService = [accessoryServices objectAtIndex:indexPath.row];
}


@end
