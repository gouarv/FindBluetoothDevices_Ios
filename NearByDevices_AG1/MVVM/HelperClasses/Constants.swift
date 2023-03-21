//
//  Constants.swift
//  NearByDevices_AG1
//
//  Created by Mac on 13/03/23.
//

import Foundation
import UIKit

enum AppInfo {
    static let AppName = "Nearby Devices"
    static let DeviceName =  UIDevice.current.name
    static let DeviceId =  UIDevice.current.identifierForVendor!.uuidString
}

enum AlertMessages {
    static let unknown = "Unknown Device"
    static let reSetting = "Resetting Connection"
    static let unSupported = "Unsupported Device"
    static let unAuthorized = "Unauthorized Device"
    static let bluetooth = "Bluetooth is Power Off"
    static let unNamed = "Unnamed"
    static let devicesFound = "Devices Found"
    static let noDevice = "No Device Found"
}

enum AlertsTitle {
    static let okay = "Ok"
    static let disconnected = "Disconnected"
    static let connected = "Connected"
    static let connecting = "Connecting"
    static let noConnected = "No Connected"

}

