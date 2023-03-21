//
//  NearByDevicesVC.swift
//  NearByDevices_AG1
//
//  Created by Mac on 13/03/23.
//

import UIKit

class NearByDevicesVC: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var tblVwDevices: UITableView!
    @IBOutlet weak var lblDeviceStatus: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    
    //MARK: Variables
    var bluetoothManager = CoreBluetoothManager()
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.startScanning()
    }
    
    //MARK: Custom Method
    func setup(){
        tblVwDevices.registeredXibCell("DevicesListTVC")
        tblVwDevices.dataSource = self
        tblVwDevices.delegate = self
    }
    
    func startScanning() {
        bluetoothManager.delegate = self
        bluetoothManager.startScanning()
    }
    
    //MARK: IBActions
    @IBAction func actionSearchToggel(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected == true ? bluetoothManager.stopScanning() : bluetoothManager.startScanning()
    }
}

extension NearByDevicesVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = bluetoothManager.nearByPeripherals[indexPath.row]
        bluetoothManager.connectDevice(selectedPeripheral: peripheral)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

extension NearByDevicesVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetoothManager.nearByPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListTVC", for: indexPath) as! DevicesListTVC
        cell.lblDeviceName.text = bluetoothManager.nearByPeripherals[indexPath.row].name ?? AlertMessages.unNamed
        
        switch bluetoothManager.nearByPeripherals[indexPath.row].state{
            case .connected:
            cell.lblStatus.text = AlertsTitle.connected
            case .disconnected:
            cell.lblStatus.text = AlertsTitle.noConnected
            case .connecting:
            cell.lblStatus.text = AlertsTitle.connecting
            case .disconnecting:
                // Case not handel yet
            break
            @unknown default:
                break
        }
        return cell
    }
    
}

extension NearByDevicesVC: BluetoothManagerDelegate {
    
    func peripheralsAlert(messages: String) {
        self.displayAlertMessage(messages)
    }
    
    func peripheralsDidUpdate() {
        lblDeviceStatus.text = bluetoothManager.nearByPeripherals.count > 0 ? AlertMessages.devicesFound : AlertMessages.noDevice
        btnSearch.isSelected = false
        tblVwDevices.reloadData()
    }
}
