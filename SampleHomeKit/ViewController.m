//
//  ViewController.m
//  SampleHomeKit
//
//  Created by Porwal, Animesh on 7/2/14.
//  Copyright (c) 2014 AP. All rights reserved.
//

#import "ViewController.h"
#import "AddNewAccesoryViewController.h"
#import "AccessoryDetailViewController.h"

@interface ViewController (){
    NSMutableArray *accessories;
}
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.homeManager = [[HMHomeManager alloc] init];
    self.homeManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    accessories = [[NSMutableArray alloc] init];
    
    if (self.homeManager && self.homeManager.primaryHome) {
        for (HMAccessory *accessory in self.homeManager.primaryHome.accessories) {
            [accessories insertObject:accessory atIndex:0];
            accessory.delegate = self;
            [self.tableView reloadData];
        }
    }
}

- (IBAction)addHome:(id)sender {
    
    __weak typeof (self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add New Home" message:@"Type name for the new home. This app works with only one home right now." preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:nil];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        UITextField *textField = alertController.textFields[0];
        
        [self.homeManager addHomeWithName:textField.text completionHandler:^(HMHome *home, NSError *error){
            if (error == nil) {
                [weakSelf.homeManager updatePrimaryHome:home completionHandler:^(NSError *error){
                    if (error) {
                        NSLog(@"Error updating primary home: %@", error);
                    } else {
                        NSLog(@"Primary home updated.");
                    }
                }];
            } else {
                NSLog(@"Error adding new home: %@", error);
            }
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - HMHomeManagerDelegate

- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
    
    if (manager.primaryHome) {
        self.primaryHome = manager.primaryHome;
        self.primaryHome.delegate = self;
        
        for (HMAccessory *accessory in self.homeManager.primaryHome.accessories) {
            [accessories addObject:accessory];
            accessory.delegate = self;
            [self.tableView reloadData];
        }
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add New Home" message:@"Click on the \"Add Home\" button to continue." preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

#pragma mark - HMHomeDelegate

- (void)home:(HMHome *)home didAddAccessory:(HMAccessory *)accessory {
    
    for (HMAccessory *accessory in self.homeManager.primaryHome.accessories) {
        [accessories addObject:accessory];
        accessory.delegate = self;
        [self.tableView reloadData];
    }
}

- (void)home:(HMHome *)home didRemoveAccessory:(HMAccessory *)accessory {
    
    if ([accessories containsObject:accessory]) {
        NSUInteger index = [accessories indexOfObject:accessory];
        [accessories removeObjectAtIndex:index];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - HMAccessoryDelegate
- (void)accessoryDidUpdateReachability:(HMAccessory *)accessory {
    
    if ([accessories containsObject:accessory]) {
        NSUInteger index = [accessories indexOfObject:accessory];

        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        if (accessory.reachable) {
            cell.detailTextLabel.text = @"Available";
            cell.detailTextLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:108.0/255.0 blue:73.0/255.0 alpha:1.0];
        } else {
            cell.detailTextLabel.text = @"Not Available";
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
    }
}

- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"characteristicValueChanged" object:nil userInfo:@{@"accessory": accessory,
                                                                                                                   @"service": service,
                                                                                                                   @"characteristic": characteristic}];
    
}

#pragma mark - TableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return accessories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accessoryCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"accessoryCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSLog(@"accessories: %@", accessories);
    
    HMAccessory *accessory = [accessories objectAtIndex:indexPath.row];
    
    cell.textLabel.text = accessory.name;
    if (accessory.reachable) {
        cell.detailTextLabel.text = @"Available";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:108.0/255.0 blue:73.0/255.0 alpha:1.0];
    } else {
        cell.detailTextLabel.text = @"Not Available";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showAccessoryDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      //  HMAccessory *selectedAccessory = [accessories objectAtIndex:indexPath.row];
        
        AccessoryDetailViewController *accessoryDetailVC = (AccessoryDetailViewController*)[segue destinationViewController];
        accessoryDetailVC.selectedAccessory = [accessories objectAtIndex:indexPath.row];
        
    } else if ([segue.identifier isEqualToString:@"addNewAccessory"]) {
        AddNewAccesoryViewController *addNewAccessoryVC = (AddNewAccesoryViewController*)[segue destinationViewController];
        addNewAccessoryVC.homeManager = self.homeManager;
    }
}


@end
