//
//  DeviceManager.swift
//  Unique Identifier Demo
//
//  Created by Pawan kumar on 18/11/19.
//  Copyright © 2019 Pawan Kumar. All rights reserved.
//

import UIKit
import Foundation
import Security

class DeviceManager: NSObject {

    static let sharedInstance = DeviceManager()
        
    //Constructor
    private override init() { }
    
       func deviceNormalIdentifier()-> String {
       
           var identifier: String = ""
           if UIDevice.current.identifierForVendor?.uuidString != nil {
               
              let uuid = UIDevice.current.identifierForVendor?.uuidString
              identifier = String(describing: uuid!)
            
              //print("Normal Identifier: ", identifier)
           }
        return identifier
    }
    
    //Device UUID (Returns a string created from the UUID, such as "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
       func deviceUUID()-> String {
       
           var identifier: String = ""
           if UIDevice.current.identifierForVendor?.uuidString != nil {
               
              let uuid = UIDevice.current.identifierForVendor?.uuidString
              identifier = String(describing: uuid!)
            
              //print("Normal Identifier: ", identifier)
            
               let uuidToke: String =  KeychainService.loadToken()
               
               if uuidToke.count > 0 {
                   
                   identifier = uuidToke
                   
               }else {
                   KeychainService.saveToken(token: identifier as NSString)
               }
           }
        
        //print("Unique Identifier: ", identifier)
          
        return identifier
    }
}


// Identifiers
let serviceIdentifier: String = Bundle.main.bundleIdentifier!
let userAccount = "venderUUDI"
let accessGroup = "AppSerivice"

// see https://stackoverflow.com/a/37539998/1694526
// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class KeychainService: NSObject {
 
 public class func saveToken(token: NSString) {
 
    self.save(service: serviceIdentifier, data: token as String)
 }
 
 public class func loadToken() -> String {
 
    let token = self.load(service: serviceIdentifier)
 
    return token!
 }
    
    /**
     * Internal methods for querying the keychain.
     */
    private class func save(service: String, data: String) {
        
        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            // Instantiate a new default keychain query
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
            
            // Add the new keychain item
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
            
            if (status != errSecSuccess) {    // Always check the status
                if #available(iOS 11.3, *) {
                    if let err = SecCopyErrorMessageString(status, nil) {
                        //print("Write failed: \(err)")
                    }
                } else {
                    // Fallback on earlier versions
                    //print("Nothing was Write from the keychain. Status code \(status)")
                }
            }
        }
    }
    
    private class func load(service: String) -> String?{
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String?
        contentsOfKeychain = ""
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            }
        } else {
            
        }
        
        return contentsOfKeychain
    }
}
