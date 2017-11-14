//
//  TestBluetooth.swift
//  Project
//
//  Created by Miguel Chavez on 7/15/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit
import Firebase
import CoreBluetooth

import Foundation

class TestBluetoothController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var sounds: [String:Any] = ["sound1":"-Kxw-VcxaYMhyCNKRitl","sound2":"-Kxw-VcxaYMhyCNKRitl"]
    
    var centralManager:CBCentralManager!
    var peripheral:CBPeripheral!
    var characteristic:CBCharacteristic!
    var bluetoothOn:Bool!
    //let ourUUIDs: [CBUUID] = [CBUUID(string: "FFE0")]
    //let serviceUUID = CBUUID(string: "FFE0")
    //let characteristicUUID = CBUUID(string: "FFE1")
    let ourUUIDs: [CBUUID] = [CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")]
    let serviceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    let characteristicUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    var cnt = 0;
    
    let scanButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.setTitle("Set", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(startScan), for: .touchUpInside)
        return button
    }()
    
    let onButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("On", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(On), for: .touchUpInside)
        return button
    }()
    
    let offButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Off", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(Off), for: .touchUpInside)
        return button
    }()
    
    let soundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitle("Sound", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(sound), for: .touchUpInside)
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textAlignment = .center
        label.text = "Test Bluetooth"
        return label
    }()
    
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26)
        label.textAlignment = .center
        label.text = "Lights"
        return label
    }()
    
    
    let moduleImageView: UIImageView = {
        let imageView = UIImageView()
        var color = 0
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "bluetooth")
        return imageView
    }()
    
    let logTextView: UITextView = {
        let tv = UITextView()
        tv.text = "    Start"
        tv.backgroundColor = .white
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()
    
    func addToLog(_ addition: String){
        logTextView.text = "    " + addition + "\n\n" + logTextView.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bluetoothOn = false;
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        self.navigationItem.title = "Bluetooth"
        
        view.backgroundColor = UIColor.blue
        setupNavigationBarItemList()
        
        view.addSubview(moduleImageView)
        view.addSubview(onButton)
        view.addSubview(offButton)
        view.addSubview(nameLabel)
        view.addSubview(captionLabel)
        view.addSubview(logTextView)
        
        nameLabel.anchorCenterXToSuperview()
        nameLabel.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 300, heightConstant: 40)
        
        captionLabel.anchorCenterXToSuperview()
        captionLabel.anchor(top: nameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 400, heightConstant: 35)
        
        moduleImageView.anchorCenterXToSuperview()
        moduleImageView.anchor(top: captionLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 70, heightConstant: 70)
        
        setupTestButtons()
        
        logTextView.anchor(top: onButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 40, paddingBottom: 30, paddingRight: 40, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func setupNavigationBarItemList() {
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.rbg(red: 100, green: 100, blue: 100)
        navBar?.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(launchMenu))
    }
    
    let menuLauncher = MenuLauncher()
    
    func launchMenu() {
        
        menuLauncher.showMenu()
    }
    
    fileprivate func setupTestButtons(){
        
        let stackView = UIStackView(arrangedSubviews: [scanButton, onButton,offButton, soundButton])
        view.addSubview(stackView)
        
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 20
        
        stackView.anchor(top: moduleImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 30, paddingRight: 30, widthConstant: 0, heightConstant: 80)
    }
    
    func On(sender: UIButton) {
        addToLog("on")
        let value:String = "H"
        let data = value.data(using: String.Encoding.utf8)
        peripheral.writeValue(data!, for: self.characteristic, type: CBCharacteristicWriteType.withoutResponse)
    }
    
    func Off(sender: UIButton) {
        addToLog("off")
        let value:String = "L"
        let data = value.data(using: String.Encoding.utf8)
        peripheral.writeValue(data!, for: self.characteristic, type: CBCharacteristicWriteType.withoutResponse)
    }
    
    func sound(sender: UIButton) {
        sendSounds(sounds: sounds)
    }
    func write(sound:String, uid:String, sid:String) {
        addToLog(sound)
        let uid = uid
        let sid = sid
        var soundUrl: String = ""
    FIRDatabase.database().reference().child("sounds").child(uid).child(sid).child("soundUrl").observeSingleEvent(of: .value, with: { (snapshot) in
        
            soundUrl = String(describing: snapshot.value!)
            self.addToLog(soundUrl)
            
            guard let url = URL(string: soundUrl) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err {
                    print("Failed to fetch sound:", err)
                    return
                }
                guard let soundData = data else { return }
                
                var value:String = sound + "\n"
                print(value)
                var data = value.data(using: String.Encoding.utf8)
                self.peripheral.writeValue(data!, for: self.characteristic, type: CBCharacteristicWriteType.withoutResponse)

                soundData.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
                    let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
                    let totalSize = soundData.count
                    var offset = 0
                    
                    while offset < totalSize {
                        
                        let chunkSize = 20
                        let chunk = Data(bytesNoCopy: mutRawPointer+offset, count: chunkSize, deallocator: Data.Deallocator.none)
                        self.peripheral.writeValue(chunk, for: self.characteristic, type: CBCharacteristicWriteType.withoutResponse)
                        offset += chunkSize
                        usleep(5000)
                    }
                }
                
                value = "\n"
                data = value.data(using: String.Encoding.utf8)
                self.peripheral.writeValue(data!, for: self.characteristic, type: CBCharacteristicWriteType.withoutResponse)
                self.peripheral.writeValue(data!, for: self.characteristic, type: CBCharacteristicWriteType.withoutResponse)
                print("done")
                usleep(100000)
                self.cnt -= 1;
                if(self.cnt == 0){
                    self.centralManager.cancelPeripheralConnection(self.peripheral)
                }
                DispatchQueue.main.async {
                }
            }.resume()
                
                self.addToLog("done")
            }) { (err) in
                print("Failed to fetch user", err)
        }
    }
    
    func startScan(sender: UIButton) {
        if(!self.bluetoothOn){
            addToLog("Bluetooth is Off")
            return
        }
        //if(peripheral == nil){
            self.centralManager.scanForPeripherals(withServices: ourUUIDs, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
            addToLog("Scan")
        //} else {
        //    sendSounds(sounds: sounds)
        //}
        
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        addToLog("RSSI: " + String(describing: RSSI))
        addToLog("advertisementData: " + String(describing: advertisementData["name"]))
        print(advertisementData.count)
        self.peripheral = peripheral
        
        self.centralManager.connect(peripheral, options: nil)
        
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        addToLog("Fail! :(")
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        addToLog("Connected!")
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if((error) != nil){
            addToLog(String(describing: error))
        }
        for service in peripheral.services! {
            let thisService = service as CBService
            addToLog(String(describing: thisService))
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics(nil,for: thisService)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service:CBService,
                     error: Error?) {
        if((error) != nil){
            addToLog(String(describing: error))
        }
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            addToLog(String(describing: thisCharacteristic))
            if characteristic.uuid == characteristicUUID {
                addToLog("WE ARE HERE!")
                self.characteristic = thisCharacteristic
                //set up notifications
                sendSounds(sounds: sounds)
                
            }
        }
    }
    
    func sendSounds(sounds: [String:Any]){
        let count = sounds.count
        cnt = count
        let value:String = String(count) + "\n"
        //let value:String = "H"
        let data = value.data(using: String.Encoding.utf8)
        self.peripheral.writeValue(data!, for: self.characteristic, type: CBCharacteristicWriteType.withoutResponse)
        print(value)
        for sound in sounds {
            let keyStr = sound.key
            let index = keyStr.characters.index(keyStr.startIndex, offsetBy: 5)
            var uid:String?
            let sid:String = sound.value as! String
            if(dbUser?.soundsDictionary[sid] != nil){
                uid = dbUID
            }else {
                uid = userUID
            }
            print("Index: " + String(keyStr[index]))
            print("     sid: " + sid)
            print("     uid: " + uid!)
            write(sound: String(keyStr[index]), uid: uid!, sid: sid)
        }
        
    }

    
    func peripheral(peripheral: CBPeripheral,didUpdateValueForCharacteristic characteristic: CBCharacteristic,
                    error: Error?) {
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            addToLog("Bluetooth available")
            self.bluetoothOn = true;
            
        } else {
            addToLog("Bluetooth not available.")
            self.bluetoothOn = false;
        }
    }
}
