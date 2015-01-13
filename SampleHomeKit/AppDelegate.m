//
//  AppDelegate.m
//  SampleHomeKit
//
//  Created by Porwal, Animesh on 7/2/14.
//  Copyright (c) 2014 AP. All rights reserved.
//

#import "AppDelegate.h"
#import <HomeKit/HomeKit.h>

@interface AppDelegate ()
            

@end

@implementation AppDelegate

- (void) InitHomeKitUUIDs {
    self.HomeKitUUIDs = [NSMutableDictionary dictionary];
    NSString * HomeKitUUIDArray[43] =
    {
        HMServiceTypeLightbulb,
        HMServiceTypeSwitch,
        HMServiceTypeThermostat,
        HMServiceTypeGarageDoorOpener,
        HMServiceTypeAccessoryInformation,
        HMServiceTypeFan,
        HMServiceTypeOutlet,
        HMServiceTypeLockMechanism,
        HMServiceTypeLockManagement,
        HMCharacteristicTypePowerState,
        HMCharacteristicTypeHue,
        HMCharacteristicTypeSaturation,
        HMCharacteristicTypeBrightness,
        HMCharacteristicTypeTemperatureUnits,
        HMCharacteristicTypeCurrentTemperature,
        HMCharacteristicTypeTargetTemperature,
        HMCharacteristicTypeCurrentHeatingCooling,
        HMCharacteristicTypeTargetHeatingCooling,
        HMCharacteristicTypeCoolingThreshold,
        HMCharacteristicTypeHeatingThreshold,
        HMCharacteristicTypeCurrentRelativeHumidity,
        HMCharacteristicTypeTargetRelativeHumidity,
        HMCharacteristicTypeCurrentDoorState,
        HMCharacteristicTypeTargetDoorState,
        HMCharacteristicTypeObstructionDetected,
        HMCharacteristicTypeName,
        HMCharacteristicTypeManufacturer,
        HMCharacteristicTypeModel,
        HMCharacteristicTypeSerialNumber,
        HMCharacteristicTypeIdentify,
        HMCharacteristicTypeRotationDirection,
        HMCharacteristicTypeRotationSpeed,
        HMCharacteristicTypeOutletInUse,
        HMCharacteristicTypeVersion,
        HMCharacteristicTypeLogs,
        HMCharacteristicTypeAudioFeedback,
        HMCharacteristicTypeAdminOnlyAccess,
        HMCharacteristicTypeMotionDetected,
        HMCharacteristicTypeCurrentLockMechanismState,
        HMCharacteristicTypeTargetLockMechanismState,
        HMCharacteristicTypeLockMechanismLastKnownAction,
        HMCharacteristicTypeLockManagementControlPoint,
        HMCharacteristicTypeLockManagementAutoSecureTimeout
    };

    NSString * HomeKitNameArray[43] = {
        @"Light Bulb",
        @"Switch",
        @"Thermostat",
        @"Garage Door Opener",
        @"Accessory Information",
        @"Fan",
        @"Outlet",
        @"Lock Mechanism",
        @"Lock Management",
        @"Power State",
        @"Hue",
        @"Saturation",
        @"Brightness",
        @"Temperature Units",
        @"Current Temperature",
        @"Target Temperature",
        @"Current Heating Cooling",
        @"Target Heating Cooling",
        @"Cooling Threshold",
        @"Heating Threshold",
        @"Current Relative Humidity",
        @"Target Relative Humidity",
        @"Current Door State",
        @"Target Door State",
        @"Obstruction Detected",
        @"Name",
        @"Manufacturer",
        @"Model",
        @"Serial Number",
        @"Identify",
        @"Rotation Direction",
        @"Rotation Speed",
        @"Outlet In Use",
        @"Version",
        @"Logs",
        @"Audio Feedback",
        @"Admin Only Access",
        @"Motion Detected",
        @"Current Lock Mechanism State",
        @"Target Lock Mechanism State",
        @"Lock Mechanism Last Known Action",
        @"Lock Management Control Point",
        @"Lock Management Auto Secure Timeout"
    };

    for(int i=0; i < 43; i ++)
    {
        [self.HomeKitUUIDs setObject:HomeKitNameArray[i] forKey:HomeKitUUIDArray[i]];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self InitHomeKitUUIDs];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
