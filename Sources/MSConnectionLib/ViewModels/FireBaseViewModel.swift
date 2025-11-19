//
//  FireBaseViewModel.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation
import UIKit
import FirebaseRemoteConfig
import FirebaseDatabase

public class FireBaseViewModel : ObservableObject {
    
    public init() {}
    
    //MARK: Firebase related
    var remoteConfig: RemoteConfig!
    let settings = RemoteConfigSettings()
    var ref: DatabaseReference!
    @Published public var appVersion : Double = 1
    @Published public var appVersionString : String = "1"
    @Published public var currentVerion = ""
    @Published public var currentVersionNumber : Double = 0
    @Published public var must_update_ios = false
    @Published public var paymentLiveKey = ""
    @Published public var paymentTestKey = ""
    
    @Published public var mainUrl = ""
    @Published public var testUrl = ""
    
    var fireBaseSettings = FirebaseSettings.init([String:Any]())
    
    func setFirebaseSettings(afterFetch : @escaping ([String:Any])-> Void){
        ref = Database.database().reference().child("settings")
        print("config real time started")
        ref.observe(DataEventType.value, with: { [self] snapshot in
            fireBaseSettings = FirebaseSettings.init(snapshot.value as! [String:Any])
            mainUrl = fireBaseSettings.base_url
            testUrl = fireBaseSettings.test_url
            appVersion = fireBaseSettings.ios_store_version
            must_update_ios = fireBaseSettings.must_update
            paymentLiveKey = fireBaseSettings.paymentLiveKey
            paymentTestKey = fireBaseSettings.paymentTestKey
            URLPrefHelper.shared.setUrls(mainUrl: fireBaseSettings.base_url , testUrl: fireBaseSettings.test_url)
            print("TAG PRINT::: AFTERCONFIG:::MAIN URL ::: \(fireBaseSettings.base_url)")
            print("TAG PRINT::: AFTERCONFIG:::TEST URL ::: \(fireBaseSettings.test_url)")
            afterFetch(snapshot.value as! [String:Any])
        })
    }
    
    public func getAppVersionThenSetConfig(afterFetch : @escaping ([String:Any])-> Void){
        setAppVersion()
        setFirebaseSettings(afterFetch: afterFetch)
    }

    func setAppVersion(){
        currentVerion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        if let currentVerionNum = Double.init(currentVerion){
            currentVersionNumber = currentVerionNum
        }
        
    }
    
    public func isNewerVersion(_ version : String) -> Bool {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        print("VERSION ::: \(currentVersion)")
        
        let isNewerVersion = currentVersion.compare(version, options: .numeric) != .orderedAscending
        print("Is newer version: \(isNewerVersion)")
        return isNewerVersion
    }
    
    func setRemoteConfig(_ action : Selector ,_ target : UIViewController){
        remoteConfig = RemoteConfig.remoteConfig()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        print("Config is getting fetched")
        var sendingDate = Date()
        remoteConfig.fetchAndActivate() { [self] (status, error) -> Void in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                print("config time elapsed = \(sendingDate.timeIntervalSinceNow * -1) milliseconds" , true)
                print("Config fetched!")
                remoteConfig.activate() { [self] (changed, error) in
                    mainUrl = remoteConfig.getStringVal(.app_url)
                    testUrl = remoteConfig.getStringVal(.test_url)
                    appVersion = remoteConfig.getDoubleVal(.version)
                    appVersionString = remoteConfig.getStringVal(.version)
                    must_update_ios = remoteConfig.getBoolVal(.mustUpdate)
                    target.perform(action)
                }
            } else {
                print("Config not fetched")
                print("Config Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}

extension RemoteConfig {
    
    func getStringVal(_ value : ConfigKeys) -> String {
        let returnVal = configValue(forKey: value.rawValue).stringValue
        return returnVal
    }
    
    func getNumVal(_ value : ConfigKeys) -> NSNumber {
        let returnVal = configValue(forKey: value.rawValue).numberValue
        return returnVal
    }
    
    func getDoubleVal(_ value : ConfigKeys) -> Double {
        let returnVal = configValue(forKey: value.rawValue).numberValue.doubleValue
        return returnVal
    }
    
    func getBoolVal(_ value : ConfigKeys) -> Bool {
        let returnVal = configValue(forKey: value.rawValue).boolValue
        return returnVal
    }
    
}

class FirebaseSettings{
    var base_url = "https://sonqr.com"
    var must_update = true
    var test_url = "https://sonqr.xyz"
    var ios_store_version = 0.001
    var ios_store_versionString = "0.001"
    var paymentLiveKey = ""
    var paymentTestKey = ""
    
    init(_ data: [String:Any]) {
        base_url = HandlingData.shared.getString(data: data, dataName: "main_url")
        ios_store_version = HandlingData.shared.getDouble(data: data, dataName: "store_version_ios")
        ios_store_versionString = HandlingData.shared.getString(data: data, dataName: "store_version_ios")
        must_update = HandlingData.shared.getBool(data: data as [String:AnyObject], dataName: "must_update_ios")
        test_url = HandlingData.shared.getString(data: data, dataName: "test_url")
        paymentLiveKey = HandlingData.shared.getString(data: data, dataName: "payment_live_key")
        paymentTestKey = HandlingData.shared.getString(data: data, dataName: "payment_test_key")
        
    }
}

enum ConfigKeys : String {
    case app_url = "main_url"
    case test_url = "test_url"
    case version = "store_version_ios"
    case mustUpdate = "must_update_ios"
    case paymentLiveKey = "payment_live_key"
    case paymentTestKey = "payment_test_key"
}
