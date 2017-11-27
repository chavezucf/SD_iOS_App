//
//  UploadSoundSetDetailsController.swift
//  Project
//
//  Created by Miguel Chavez on 5/9/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//
import UIKit
import Firebase
import CoreBluetooth
//import Lottie

class UploadSoundSetDeatilsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let cellID = "cellID"
    
    var soundSet: SoundSet? {
        didSet{
            sounds = soundSet?.soundsDictionary
            soundSetName = soundSet?.name
            
        }
    }
    /*
    let loadingAnimation: LOTAnimationView = {
        let AV = LOTAnimationView.animationNamed("glow_loading")
        AV?.contentMode = .scaleAspectFill
        AV?.loopAnimation = true
        AV?.isHidden = true
        return AV!
    }()*/
    
    let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.tag = 100
        return blurView
    }()
    
    let otherView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = "Sending Bluetooth..."
        label.textAlignment = .center
        
        
        
        view.addSubview(label)
        label.anchorCenterXToSuperview()
        label.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 200, heightConstant: 20)
        view.tag = 200
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    func animateIn() {
        super.viewDidLoad()
        
        otherView.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
        otherView.alpha = 0
        blurView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            
            self.otherView.alpha = 1
            self.otherView.transform = CGAffineTransform.identity
            
            self.blurView.alpha = 1
            self.blurView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        print("test")
        UIView.animate(withDuration: 0.3, animations:{
            self.otherView.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            self.otherView.alpha = 0
            self.blurView.alpha = 0
        }){ (success:Bool) in
            
            self.blurView.removeFromSuperview()
            self.otherView.removeFromSuperview()
        }
    }
    
    func Add() {
        animateIn()
        view.addSubview(blurView)
        view.addSubview(otherView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 0)
        otherView.anchorCenterXToSuperview()
        otherView.anchorCenterYToSuperview()
        otherView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 250, heightConstant: 100)
    }
    
    
    
    var sounds:[String:Any]?
    var soundSetName:String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.bluetoothOn = false;
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        collectionView?.register(UploadSoundSetDetailsHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView?.register(UploadSoundSetDetailsFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerId")
        
        collectionView?.register(EditSoundSetCell.self, forCellWithReuseIdentifier: cellID)
        
        
        collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "wood2")!)
        setupNavigationBarItemList()
        
        collectionView?.alwaysBounceVertical = true
        
        //view.addSubview(loadingAnimation)
        //loadingAnimation.anchorCenterXToSuperview()
        //loadingAnimation.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 150, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 240)
        
        
        view.addSubview(blurView)
        view.addSubview(otherView)
        if self.view.viewWithTag(100) != nil {
            blurView.removeFromSuperview()
        }
        
        if self.view.viewWithTag(200) != nil {
            blurView.removeFromSuperview()
            otherView.removeFromSuperview()
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (sounds?.count)!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! EditSoundSetCell
        cell.index = indexPath.item + 1
        let soundDictionaryKey = getSoundDictionaryKey(with: indexPath.item)
        let soundName = mainUser!.soundsDictionary[soundDictionaryKey] as? String ?? dbUser!.soundsDictionary[soundDictionaryKey] as? String ?? "Select a Sound"
        cell.soundName = soundName
        cell.sid = soundDictionaryKey
        cell.showNext = false
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind  == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UploadSoundSetDetailsHeader
            
            header.masterView = self
            return header
        }
        else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerId", for: indexPath) as! UploadSoundSetDetailsFooter
            
            return footer
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 20)
        
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func getSoundDictionaryKey(with indexPathItem: Int) -> String{
        let newIndex = indexPathItem + 1
        let soundKey = "sound" + String(newIndex)
        return sounds?[soundKey] as! String
    }
    
    /* CODE FOR BLUETOOTH */
    var centralManager:CBCentralManager!
    var peripheral:CBPeripheral!
    var characteristic:CBCharacteristic!
    var bluetoothOn:Bool!
    let ourUUIDs: [CBUUID] = [CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")]
    let serviceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    let characteristicUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    var cnt = 0
    
    func write(sound:String, uid:String, sid:String) {
        let uid = uid
        let sid = sid
        var soundUrl: String = ""
        FIRDatabase.database().reference().child("sounds").child(uid).child(sid).child("soundUrl").observeSingleEvent(of: .value, with: { (snapshot) in
            
            soundUrl = String(describing: snapshot.value!)
            
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
                    self.sending(false)
                    self.centralManager.cancelPeripheralConnection(self.peripheral)
                }
                DispatchQueue.main.async {
                }
                }.resume()
            
            print("done")
        }) { (err) in
            print("Failed to fetch user", err)
        }
    }
    
    func startSend(sender: UIButton) {
        if(!self.bluetoothOn){
            print("Bluetooth is Off")
            return
        }
        self.centralManager.scanForPeripherals(withServices: ourUUIDs, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
        self.sending(true)
        
        
    }
    
    func sending(_ isSending:Bool){
        if(isSending){
            //loadingAnimation.isHidden = false
            //loadingAnimation.play()
            //view.addSubview(loadingAnimation)
            Add()

        } else {
            //loadingAnimation.isHidden = true
            //loadingAnimation.pause()
            //loadingAnimation.removeFromsuperview()
            print("dicconect")
            animateOut()
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(advertisementData.count)
        self.peripheral = peripheral
        
        self.centralManager.connect(peripheral, options: nil)
        
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Fail! :(")
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if((error) != nil){
            print(String(describing: error))
        }
        for service in peripheral.services! {
            let thisService = service as CBService
            print(String(describing: thisService))
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics(nil,for: thisService)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service:CBService,
                    error: Error?) {
        if((error) != nil){
            print(String(describing: error))
        }
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            if characteristic.uuid == characteristicUUID {
                print("WE ARE HERE!")
                self.characteristic = thisCharacteristic
                sendSounds(sounds: sounds!)
                
            }
        }
    }
    
    func sendSounds(sounds: [String:Any]){
        let count = sounds.count
        cnt = count
        let value:String = String(count) + "\n"
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
            print("Bluetooth available")
            self.bluetoothOn = true;
            
        } else {
            print("Bluetooth not available.")
            self.bluetoothOn = false;
        }
    }
}
