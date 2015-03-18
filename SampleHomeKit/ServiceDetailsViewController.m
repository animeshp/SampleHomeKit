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

    serviceCharacterstics = [[NSMutableArray alloc] init];

    [self updateTableViewData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCharacteristicValue:) name:@"characteristicValueChanged" object:nil];
    
    for (HMCharacteristic* charateristic in serviceCharacterstics) {
        if ([charateristic.properties containsObject:HMCharacteristicPropertySupportsEventNotification]) {
            [charateristic enableNotification:YES completionHandler:^(NSError *error){
               
                if (error) {
                    NSLog(@"%@", error.description);
                }
                
            }];
        }
    }
    
//    serviceCharacterstics = [[NSMutableArray alloc] init];
//    
//    if (self.selectedService) {
//        [self updateTableViewData];
//    }
}

#pragma mark - Selectors


-(void)updateTableViewData{
    
    for (HMCharacteristic *characterstic in self.selectedService.characteristics) {
        [serviceCharacterstics addObject:characterstic];
        [self.charactersticsTableView reloadData];
    }
}

-(void)updateCharacteristicValue:(NSNotification*)notification {
    
    HMCharacteristic *characteristic = [[notification userInfo] objectForKey:@"characteristic"];
    
    if ([serviceCharacterstics containsObject:characteristic]) {
        NSInteger index = [serviceCharacterstics indexOfObject:characteristic];
        
        UITableViewCell *cell = [self.charactersticsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            cell.textLabel.text = [NSString stringWithFormat:@"%@",characteristic.value];
        });
    }
    
}

-(void)changeLockState:(id)sender{
    
    CGPoint switchOriginInTableView = [sender convertPoint:CGPointZero toView:self.charactersticsTableView];
    NSIndexPath *indexPath = [self.charactersticsTableView indexPathForRowAtPoint:switchOriginInTableView];
    
    HMCharacteristic *characteristic = [serviceCharacterstics objectAtIndex:indexPath.row];
    
    //FIXME
    if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]  || [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState]) {
        
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

-(void)changeSliderValue:(id)sender {
    
    UISlider *slider = (UISlider*) sender;
    
    NSLog(@"%f", slider.value);
    
    CGPoint sliderOriginInTableView = [sender convertPoint:CGPointZero toView:self.charactersticsTableView];
    NSIndexPath *indexPath = [self.charactersticsTableView indexPathForRowAtPoint:sliderOriginInTableView];
    
    HMCharacteristic *characteristic = [serviceCharacterstics objectAtIndex:indexPath.row];
    
    [characteristic writeValue:[NSNumber numberWithFloat:slider.value] completionHandler:^(NSError *error){
        
        if(error == nil){
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.charactersticsTableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"%.0f", slider.value] ;
            });
        } else {
            NSLog(@"error in writing characterstic: %@",error);
        }
    }];
    
}

-(void)changeCharacteristic:(HMCharacteristic*)characteristic atIndexPath:(NSIndexPath*)indexPath withValue:(NSNumber*)value {
    
    [characteristic writeValue:value completionHandler:^(NSError *error){
        
        if(error == nil){
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.charactersticsTableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"%@", value] ;
            });
        } else {
            NSLog(@"error in writing characterstic: %@",error);
        }
        
    }];
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
    
    if ([characteristic.properties containsObject:HMCharacteristicPropertyWritable]) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState] || [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState])
    {
        
        BOOL lockState = [characteristic.value boolValue];
        
        UISwitch *lockSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        lockSwitch.on = lockState;
        [lockSwitch addTarget:self action:@selector(changeLockState:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = lockSwitch;
        
    } else if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeSaturation] ||
             [characteristic.characteristicType isEqualToString:HMCharacteristicTypeBrightness] ||
             [characteristic.characteristicType isEqualToString:HMCharacteristicTypeHue] ||
             [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetTemperature] ||
             [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetRelativeHumidity] ||
             [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCoolingThreshold] ||
             [characteristic.characteristicType isEqualToString:HMCharacteristicTypeHeatingThreshold])
    {
        UISlider *slider = [[UISlider alloc] init];
        slider.bounds = CGRectMake(0, 0, 125, slider.bounds.size.height);
        slider.maximumValue = [characteristic.metadata.maximumValue floatValue];
        slider.minimumValue = [characteristic.metadata.minimumValue floatValue];
        slider.value = [characteristic.value floatValue];
        slider.continuous = true;
        [slider addTarget:self action:@selector(changeSliderValue:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = slider;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HMCharacteristic *characteristic = [serviceCharacterstics objectAtIndex:indexPath.row];
    
    UIAlertController *alertController;

    if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTemperatureUnits])
    {
        alertController = [UIAlertController alertControllerWithTitle:@"Choose Unit" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Celsius" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self changeCharacteristic:characteristic atIndexPath:indexPath withValue:@0];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Fahrenheit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self changeCharacteristic:characteristic atIndexPath:indexPath withValue:@1];

        }]];
        
    } else if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetHeatingCooling]) {
        
        alertController = [UIAlertController alertControllerWithTitle:@"Choose Heating/Cooling Mode" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Off" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self changeCharacteristic:characteristic atIndexPath:indexPath withValue:@0];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Heat" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self changeCharacteristic:characteristic atIndexPath:indexPath withValue:@1];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cool" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self changeCharacteristic:characteristic atIndexPath:indexPath withValue:@2];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Auto" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self changeCharacteristic:characteristic atIndexPath:indexPath withValue:@3];
            
        }]];
        
    }
    
    [self presentViewController:alertController animated:YES completion:nil];

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
