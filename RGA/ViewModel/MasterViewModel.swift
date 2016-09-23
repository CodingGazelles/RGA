//
//  MasterViewModel.swift
//  RGA
//
//  Created by Tancrède on 9/23/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift
import RxCocoa
import RxViewModel




class RGAMasterViewModel: RxViewModel {
    
    
    // Output
    var contactListObservable: Observable<Results<RGAContact>>
    var contactAddedVariable: Variable<RGAContact?>
    
    
    // Private
    var dataStack: RGADataStack
    private let disposeBag = DisposeBag()
    
    
    init( dataStack: RGADataStack){
        
        self.dataStack = dataStack
        contactListObservable = Observable.never()
        contactAddedVariable = Variable<RGAContact?>(nil)
        
        super.init()
        
        contactListObservable = dataStack.rx_contacts().shareReplay(1)
        
    }
    
    
    
    /*
    */
    func addContact() {
        
        let contact = RGAContact()
        switch dataStack.writeContact(contact){
        case .Success:
            NSLog("Successfully added Contact")
            
            contactAddedVariable.value = contact
            
        case .Failure(let error):
            NSLog("Failed added Contact \(error)")
        }
        
        
    }
    
}