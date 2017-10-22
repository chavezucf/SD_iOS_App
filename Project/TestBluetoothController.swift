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

class TestBluetoothController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager:CBCentralManager!
    var peripheral:CBPeripheral!
    var bluetoothOn:Bool!
    
    
    let scanButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.setTitle("Scan", for: .normal)
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
        
        let stackView = UIStackView(arrangedSubviews: [scanButton, onButton,offButton])
        view.addSubview(stackView)
        
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 20
        
        stackView.anchor(top: moduleImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 30, paddingRight: 30, widthConstant: 0, heightConstant: 80)
    }
    
    func On(sender: UIButton) {
        addToLog("on")

    }
    
    func Off(sender: UIButton) {
        addToLog("off")
    }
    
    func startScan(sender: UIButton) {
        if(!self.bluetoothOn){
            addToLog("Bluetooth is Off")
            return
        }
        self.centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
        addToLog("Scan")
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("centralManager")
        addToLog("Test")
        
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Fail")
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("Connect")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
    }
    
    func peripheral( peripheral: CBPeripheral, didDiscoverCharacteristicsForService service:CBService,
                     error: Error?) {
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