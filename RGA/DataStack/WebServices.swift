//
//  WebServices.swift
//  RGA
//
//  Created by Tancrède on 9/21/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit
import BrightFutures
import RealmSwift
import Alamofire
import AlamofireImage




class RGAWebServices {
    
    
    // Singleton
    private init(){}
    private static let defaultInstance = RGAWebServices()
    static func defaultServices() -> RGAWebServices {
        return defaultInstance
    }

    
    
    
    // MARK: - Network operations

    /*
     Deep load of all contacts (includes photos)
     */
    func loadContacts() -> Future<RGAContactList, RGADataStackError> {
        
        
        // Promise
        let promise = Promise<RGAContactList, RGADataStackError>()
        
        
        // async operation
        Queue.global.context {
            
            
            // Download the json file
            self.getJson()
                
                
                // Continuing working with the json file
                .onSuccess{ jsonValue in
                    
                    
                    // Parses the json file and returns the list of contacts
                    // Using an inner func to capture variables 'jsonValue' and 'promise'
                    // And avoid passing parameters :-)
                    func parseJson() -> RGAContactList? {
                        
                        
                        // Parsing Json
                        let parser = RGAContactListJsonParser( json: jsonValue)
                        
                        
                        switch parser.parse(){
                            
                        // OK cool, it is a success, we have a list of Contact
                        case let .Success(contactList):
                            return contactList
                            
                            
                        // Parser failed
                        case let .Failure(error):
                            promise.failure(error)
                            return nil
                        }
                        
                    }
                    
                    
                    // Parsing the json file
                    let contactList = parseJson()!
                    
                    
                    // Launch the promise with the contact list
                    promise.success(contactList)
                    
                    
                }
                
                
                // getJson failed
                .onFailure{ error in
                    promise.failure(error)
            }
            
        }
        
        return promise.future
        
    }
    
    
    
    /*
    */
    func loadUIImage( url: String) -> Future<UIImage, RGADataStackError>{
        
        
        // 
        let promise = Promise<UIImage, RGADataStackError>()
        
        Queue.global.context {
            
                
            Alamofire.request( .GET, url).responseImage { response in
                
                
                // Simulate 5 sec download time
//                 NSThread.sleepForTimeInterval(5)
                
                
                switch response.result {
                    
                case .Success( let value):
                    promise.success( value)
                    
                case .Failure( let error):
                    promise.failure( RGAGetImageError(rootError: error))
                    
                }
                
            }
        
            
        }
        
        return promise.future
        
    }
    
    
    
    /*
     */
    private func getJson() -> Future<[JsonDictionary], RGAGetJsonError> {
        
        let promise = Promise<[JsonDictionary], RGAGetJsonError>()
        
        Queue.global.context {
            
            
            //
            Alamofire.request( .GET, RGAUrlStore.ContactList.rawValue)
                .responseJSON { response in
                    
                    
                    // Simulate 5 sec download time
                    // NSThread.sleepForTimeInterval(5)
                    
                    
                    switch response.result {
                        
                    case .Success( let value):
                        promise.success( value as! [JsonDictionary])
                        
                        
                    case .Failure(let error):
                        promise.failure( RGAGetJsonError( rootError: error))
                    }
            }
            
            
        }
        
        
        return promise.future
        
    }
    
    
}