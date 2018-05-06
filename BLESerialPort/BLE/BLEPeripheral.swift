//
//  BLEPeripheral.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/4/26.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Cocoa
import CoreBluetooth

typealias ReciveData = (String, [UInt8]) -> Void

class BLEPeripheral: NSObject {
    internal var peripheralManager: CBPeripheralManager
    let localNameKey =  "BabyBluetoothStubOnOSX";
    var ServiceUUID =  "FFF0";
    var notiyCharacteristicUUID =  "FFF1";

    
    
    fileprivate var reciveData : ReciveData?
    fileprivate var notiyCharacteristic: CBMutableCharacteristic?
    
    override init() {
        peripheralManager = CBPeripheralManager(delegate: nil, queue: nil)
        super.init()
        peripheralManager.delegate = self
    }
    
    //publish service and characteristic
    public func publishService(){
        
        peripheralManager.removeAllServices()
        
        let notiyCharacteristic = CBMutableCharacteristic(type: CBUUID(string: notiyCharacteristicUUID), properties:  [.notify, .read, .write], value: nil, permissions: [.readable, .writeable])

        
        //设置description
        let descriptionStringType = CBUUID(string: CBUUIDCharacteristicUserDescriptionString)
        let description1 = CBMutableDescriptor(type: descriptionStringType, value: "Characteristic")
        notiyCharacteristic.descriptors = [description1];

        
        //设置service
        let service:CBMutableService =  CBMutableService(type: CBUUID(string: ServiceUUID), primary: true)
        service.characteristics = [notiyCharacteristic]
        peripheralManager.add(service);
    }


}

extension BLEPeripheral: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        Logger.info("\(peripheral)")
        
        switch peripheral.state {
        case .poweredOn:
            publishService()
        default:
            break
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        peripheralManager.startAdvertising(
            [
                CBAdvertisementDataServiceUUIDsKey : [CBUUID(string: ServiceUUID)]
                ,CBAdvertisementDataLocalNameKey : localNameKey
            ]
        )
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        Logger.info("\(peripheral)")
        //判断是否有读数据的权限
        if(request.characteristic.properties.contains(CBCharacteristicProperties.read))
        {
            request.value = request.characteristic.value;
            peripheral .respond(to: request, withResult: CBATTError.success);
        }
        else{
            peripheral .respond(to: request, withResult: CBATTError.readNotPermitted);
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        Logger.info("\(peripheral)")
        let request:CBATTRequest = requests[0];
        
        //判断是否有写数据的权限
        if (request.characteristic.properties.contains(CBCharacteristicProperties.write)) {
            //需要转换成CBMutableCharacteristic对象才能进行写值
            let c:CBMutableCharacteristic = request.characteristic as! CBMutableCharacteristic
            c.value = request.value;
            Logger.info("\(String(describing: c.value))")
            
            let reciveData : Data = request.value!
            let data = Array(UnsafeBufferPointer(start: (reciveData as NSData).bytes.bindMemory(to: UInt8.self, capacity: reciveData.count), count: reciveData.count))
            Logger.info("\(data)")
            
            
            peripheral .respond(to: request, withResult: CBATTError.success);
        }else{
            peripheral .respond(to: request, withResult: CBATTError.readNotPermitted);
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        Logger.info("\(peripheral)")
        notiyCharacteristic = characteristic as? CBMutableCharacteristic
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        Logger.info("\(peripheral)")
        notiyCharacteristic = nil
    }
}

extension BLEPeripheral {
    func registerReciveData(call: @escaping (String, [UInt8]) -> Void) {
        reciveData = call
    }
    
    func sendData(data: [UInt8]) {
        guard notiyCharacteristic != nil && !data.isEmpty else {
            return
        }
        
        peripheralManager.updateValue(dataWithHexstring(data), for: notiyCharacteristic!, onSubscribedCentrals: nil)
    }
    
    fileprivate func dataWithHexstring(_ bytes:[UInt8]) -> Data {
        let data = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
        return data
    }
}
