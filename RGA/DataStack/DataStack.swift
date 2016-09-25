//
//  FSDataStack.swift
//  TestA
//
//  Created by Tancrède on 9/14/16.
//  Copyright © 2016 William Vasconcelos. All rights reserved.
//

import UIKit
import BrightFutures
import Alamofire
import AlamofireImage
import RealmSwift
import RxRealm
import RxSwift




/*
 Doesn't support multithreading
 All operations must be executed in the same thread
 This is due to a limitation of Realm
 */
class RGADataStack {
    

    // Realm
    let realm: Realm
    
    
    /*
    */
    init(){
        self.realm = try! Realm()
    }
    
    
    
    // MARK: - Rx Observables Queries
    /*
    */
    func rx_contacts() -> Observable<Results<RGAContact>> {
        NSLog("rx_contacts")
        
        return realm.objects(RGAContact).asObservable()
    }
    
    
    // MARK: - DB CRUD operations
    /*
     Update
    */
    func update( updates: () -> Void ) -> Result< NoResult, RGADataStackError> {
        do {
            try self.realm.write {
                updates()
            }
        } catch let error as NSError {
            return .Failure(RGADataStackError( rootError: error))
        }
        
        return .Success(NoResult())
        
    }
    
    
    /*
     Insert
    */
    func writeContact( contact: RGAContact) -> Result< NoResult, RGADataStackError> {
        
        
        do {
            try self.realm.write {
                self.realm.add(contact, update: true)
            }
        } catch let error as NSError {
            return .Failure(RGADataStackError( rootError: error))
        }
        
        return .Success(NoResult())
        
    }
    
    
    
    /*
     Insert or Update
    */
    func writeContactList( list: RGAContactList) -> Result< NoResult, RGADataStackError> {
        
        
        do {
            try self.realm.write {
                
                for contact in list {
                    self.realm.add(contact, update: true)
                }
                
            }
        } catch let error as NSError {
            return .Failure(RGADataStackError( rootError: error))
        }
        
        return .Success(NoResult())
        
    }
    
    
    
    /*
     Delete
    */
    func deleteContact( contact: RGAContact) -> Result<NoResult, RGADataStackError> {
        
            
        do {
            try self.realm.write {
                self.realm.delete(contact)
            }
        } catch let error as NSError {
            return .Failure(RGADataStackError( rootError: error))
        }
        
        return .Success(NoResult())
        
    }
    
    
    
    /*
     Set Image
     */
    func writeImage( image: UIImage, contact: RGAContact) -> Result< NoResult, RGADataStackError> {
        
        
        do {
            try self.realm.write {
                contact.imageData = RGAContactImageSerializer.toData(image)
            }
        } catch let error as NSError {
            return .Failure(RGADataStackError( rootError: error))
        }
        
        return .Success(NoResult())
        
    }
    
    
    
    /*
     Delete
     */
    func deleteAll() -> Result<NoResult, RGADataStackError> {
        NSLog("DeleteAll \(NSThread.isMainThread() )")
        
        
        do {
            try self.realm.write {
                self.realm.deleteAll()
            }
        } catch let error as NSError {
            return .Failure(RGADataStackError( rootError: error))
        }
        
        return .Success(NoResult())
        
    }
    
    
}









