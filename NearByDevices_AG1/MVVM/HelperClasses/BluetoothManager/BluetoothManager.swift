//
//  BluetoothManager.swift
//  NearByDevices_AG1
//
//  Created by Mac on 13/03/23.
//

import Foundation
import CoreBluetooth

protocol BluetoothManagerDelegate: AnyObject {
    func peripheralsDidUpdate()
    func peripheralsAlert(messages:String)
}

protocol BluetoothManager {
    var nearByPeripherals: [CBPeripheral] { get }
    var delegate: BluetoothManagerDelegate? { get set }
    func startScanning()
}


class CoreBluetoothManager: NSObject, BluetoothManager {

    // MARK: - Public properties
    weak var delegate: BluetoothManagerDelegate?
    
    // MARK: - Private properties
    private var centralManager: CBCentralManager?
    
    private(set) var nearByPeripherals = [CBPeripheral]() {
        didSet {
            delegate?.peripheralsDidUpdate()
        }
    }

    // MARK: - Public methods
    func startScanning() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
//            self.stopScanning()
//        }
    }
    
    func stopScanning() {
        centralManager?.stopScan()
    }
    
    func connectDevice(selectedPeripheral: CBPeripheral) {
        centralManager?.connect(selectedPeripheral, options: nil)
    }

}

extension CoreBluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            delegate?.peripheralsAlert(messages: AlertMessages.unknown)
        case .resetting:
            delegate?.peripheralsAlert(messages: AlertMessages.reSetting)
        case .unsupported:
            delegate?.peripheralsAlert(messages: AlertMessages.unSupported)
        case .unauthorized:
            delegate?.peripheralsAlert(messages: AlertMessages.unAuthorized)
        case .poweredOff:
            debugPrint(AlertMessages.bluetooth)
        case .poweredOn:
            centralManager?.scanForPeripherals(withServices: nil)
        @unknown default:
            debugPrint("UnKnown")
        }
    }

    internal func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !nearByPeripherals.contains(peripheral){
            nearByPeripherals.append(peripheral)
        }
    }
    
    internal func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral:
    CBPeripheral, error: Error?) {
        delegate?.peripheralsAlert(messages: error == nil ? "\(peripheral.name ?? AlertMessages.unNamed) \(AlertsTitle.disconnected)" : "\(peripheral.name ?? AlertMessages.unNamed) \(error?.localizedDescription ?? "")")
     }
    
    internal func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.peripheralsAlert(messages: "\(peripheral.name ?? AlertMessages.unNamed) Connected")
    }
    
    internal func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.peripheralsAlert(messages: error?.localizedDescription ?? "")
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                     didUpdateValueFor characteristic: CBCharacteristic,
                     error: Error?) {
    
    }
}
