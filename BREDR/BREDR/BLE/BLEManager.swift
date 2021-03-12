//
//  BLEManager.swift
//  BREDR
//
//  Created by ShenYj on 2021/03/12.
//
//  Copyright (c) 2021 ShenYj <shenyanjie123@foxmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import Foundation
import CoreBluetooth

public class BLEManager: NSObject {
    
    static let shared: BLEManager = {
        let manager = BLEManager()
        return manager
    }()
    var central_manager: CBCentralManager
    
    
    // MARK: private
    private let ble_queue = DispatchQueue.init(label: "ble.manager.queue", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .none)
    
    private var ble_service_UUIDs: [CBUUID] = []
    private var ble_characteristic_UUIDs: [CBUUID] = []
    
    private var ble_scan_option: [String : Any] = [
        CBCentralManagerScanOptionAllowDuplicatesKey: false
    ]
    private let ble_central_init_option: [String: Any] = [
        CBCentralManagerOptionShowPowerAlertKey: false
    ]
    private let ble_connect_option: [String: Any] = [
        CBConnectPeripheralOptionNotifyOnConnectionKey: true,
        CBConnectPeripheralOptionNotifyOnDisconnectionKey: true,
        CBConnectPeripheralOptionNotifyOnNotificationKey: true,
        CBConnectPeripheralOptionEnableTransportBridgingKey: true
    ]
    
    /// 构造函数
    ///
    /// - Note: 初始化`CoreBluetooth`中央管理者;  参数配置
    ///
    override init() {
        
        if let backgroundModes = Bundle.main.infoDictionary?["UIBackgroundModes"] as? Array<String>, backgroundModes.contains("bluetooth-central") { print(" ****** 已开启蓝牙的后台模式 ****** ") }
        else {
            let warning = """

                Please adding the UIBackgroundModes key to your Info.plist file and setting the key’s value to an array containing one of the following strings
                    * bluetooth-central—The app communicates with Bluetooth low energy peripherals using the Core Bluetooth framework

            """
            print(" ****** 没有开启蓝牙后台模式 ****** ")
            print(warning)
        }
        
        
        central_manager = CBCentralManager(delegate: nil, queue: ble_queue, options: ble_central_init_option)
        super.init()
        central_manager.delegate = self
        
        // MARK: REGISTERING FOR BR/EDR CONNECTION EVENTS
        if #available(iOS 13.0, *) {
            let matchingOptions = [CBConnectionEventMatchingOption.serviceUUIDs:[
                                    CBUUID(string: "1108"),
                                    CBUUID(string: "110A"),
                                    CBUUID(string: "110B"),
                                    CBUUID(string: "110C"),
                                    CBUUID(string: "110D"),
                                    CBUUID(string: "110E"),
                                    CBUUID(string: "110F"),
                                    CBUUID(string: "111F"),
                                    CBUUID(string: "1203"),
                                    CBUUID(string: "1204"),
                                    CBUUID(string: "111E"),
                                    CBUUID(string: "0017"),
                                    CBUUID(string: "0019")]
            ];
            
            print(" REGISTERING FOR BR/EDR CONNECTION EVENTS! ");
            central_manager.registerForConnectionEvents(options: matchingOptions);
        }
    }
}

extension BLEManager {
    
    func scan(with serviceUUIDs: [CBUUID] = []) {
        
        if serviceUUIDs == ble_service_UUIDs { guard central_manager.isScanning == false else { return } }
        if central_manager.isScanning { central_manager.stopScan() }
        ble_service_UUIDs = serviceUUIDs
        ble_scan_option[CBCentralManagerScanOptionSolicitedServiceUUIDsKey] = ble_service_UUIDs
        central_manager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScan() { if central_manager.isScanning { central_manager.stopScan() } }
}

extension BLEManager: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) { print("\(central.state) + \(String(describing: Thread.current.name))") }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let distance = powl(Double(10), fabs(RSSI.doubleValue - 59 / (10.0 * 2.0)))
        
        print("距离: \(lround(distance)) 米 - 数据: \(advertisementData)")
    }
}


extension BLEManager {
    
    // MARK: BR/EDR CONNECTION EVENTS
    public func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        debugPrint("BR/EDR CONNECTED!")
        print(peripheral)
    }
}
