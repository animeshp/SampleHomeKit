//
//  ServiceDetailsViewController.m
//  SampleHomeKit
//
//  Created by Porwal, Animesh on 7/3/14.
//  Copyright (c) 2014 AP. All rights reserved.
//

#import "AppDelegate.h"
#import "ServiceDetailsViewController.h"

@interface ServiceDetailsViewController (){
    NSMutableArray *serviceCharacterstics;

}

@end


@implementation ServiceDetailsViewController

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
    
    self.title = self.selectedService.name;

    [self updateTableViewData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    serviceCharacterstics = [[NSMutableArray alloc] init];
    
    if (self.selectedService) {
        [self updateTableViewData];
    }
}

-(void) updateTableViewData {

    for (HMCharacteristic *characterstic in self.selectedService.characteristics) {
        [serviceCharacterstics addObject:characterstic];
        [self.charactersticsTableView reloadData];
    }
}

#pragma mark - TableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return serviceCharacterstics.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serviceDetailCell" forIndexPath:indexPath];
    
    HMCharacteristic *characteristic = [serviceCharacterstics objectAtIndex:indexPath.row];

    
    if (characteristic.value) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", characteristic.value];
    } else {
        cell.textLabel.text = @"";
    }
    //cell.detailTextLabel.text = [[serviceCharacterstics objectAtIndex:indexPath.row] characteristicType];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *strCharacteristicType = [myDelegate.HomeKitUUIDs objectForKey:[[serviceCharacterstics objectAtIndex:indexPath.row] characteristicType]];
    cell.detailTextLabel.text = strCharacteristicType;

    //FIXME
    if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState])
    {
        
        BOOL lockState = [characteristic.value boolValue];
        
        UISwitch *lockSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        lockSwitch.on = lockState;
        [lockSwitch addTarget:self action:@selector(changeLockState:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = lockSwitch;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - Selectors
-(void)changeLockState:(id)sender{
    
    CGPoint switchOriginInTableView = [sender convertPoint:CGPointZero toView:self.charactersticsTableView];
    NSIndexPath *indexPath = [self.charactersticsTableView indexPathForRowAtPoint:switchOriginInTableView];
    
    HMCharacteristic *characteristic = [serviceCharacterstics objectAtIndex:indexPath.row];

    //FIXME
    if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]) {
        
        BOOL changedLockState = ![characteristic.value boolValue];
        
        [characteristic writeValue:[NSNumber numberWithBool:changedLockState] completionHandler:^(NSError *error){
            
            if(error == nil){
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.charactersticsTableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"%@", characteristic.value] ;
                });
            } else {
                NSLog(@"error in writing characterstic: %@",error);
            }
        }];
    }
}

#pragma mark - Button Action

- (IBAction)renameService:(id)sender {
    
    //   __weak typeof (self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Rename Service" message:@"Type new name for this service." preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:nil];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Rename" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        UITextField *textField = alertController.textFields[0];
        
        [self.selectedService updateName:textField.text completionHandler:^(NSError *error){
            
            self.title = self.selectedService.name;
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
