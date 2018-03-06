//
//  main.swift
//  Bluetooth
//
//  Created by Sumit Chudasama on 06/03/2018.
//  Copyright © 2018 Sumit Chudasama. All rights reserved.
//

import Foundation
import IOBluetooth
import Cocoa

let defaultBluetoothDeviceAddress : String? = nil//"00-00-00-00-00-00"

class BluetoothDeviceInquiryDelegate : IOBluetoothDeviceInquiryDelegate {
    func deviceInquiryStarted(_ sender: IOBluetoothDeviceInquiry) {
    }
    func deviceInquiryDeviceFound(_ sender: IOBluetoothDeviceInquiry, device: IOBluetoothDevice) {
        guard let addressString = device.addressString,
            let deviceName = device.name
            else {
                return
            }
            print("\(deviceName) => \(addressString)")
    }
    
    func deviceInquiryComplete(_ sender: IOBluetoothDeviceInquiry!, error: IOReturn, aborted: Bool) {
    }
}

let bluetoothDeviceInquiryDelegate = BluetoothDeviceInquiryDelegate()
let ibdi = IOBluetoothDeviceInquiry(delegate: bluetoothDeviceInquiryDelegate)
ibdi?.updateNewDeviceNames = true
ibdi?.start()

func showBluetoothDevices() {
    print("Usage:\nBluetooth 00-00-00-00-00-00\n\nGet the MAC address from the list below :\n\nPaired Devices : ");
    
    if IOBluetoothDevice.pairedDevices().count == 0 {
        print("No Paired Devices")
    } else {
        IOBluetoothDevice.pairedDevices().forEach({(device) in
            guard let device = device as? IOBluetoothDevice,
                let addressString = device.addressString,
                let deviceName = device.name
                else {
                    return
            }
            print("\(deviceName) => \(addressString)")
        })
    }
}

if (CommandLine.arguments.count == 2 || defaultBluetoothDeviceAddress != nil) {
    let deviceAddress : String? = defaultBluetoothDeviceAddress == nil ? CommandLine.arguments[1] : nil
    guard let bluetoothDevice = IOBluetoothDevice(addressString: defaultBluetoothDeviceAddress ?? deviceAddress) else {
        print("Device not found")
        exit(0)
    }
    
    if !bluetoothDevice.isPaired() {
        print("Not paired to device")
        exit(0)
    }
    
    if bluetoothDevice.isConnected() {
        bluetoothDevice.closeConnection()
    }
    else {
        bluetoothDevice.openConnection()
    }
}
else {
    showBluetoothDevices()
}

RunLoop.current.run()
