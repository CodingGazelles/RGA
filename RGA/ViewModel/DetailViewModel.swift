//
//  DetailViewModel.swift
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




class RGADetailViewModel: RxViewModel {
    
    
    // Input
    var contactNameVariable: Variable<String>
    var contactEmailVariable: Variable<String>
    var contactBioVariable: Variable<String>
    var contactPhotoVariable: Variable<UIImage>
    var contactBackgroundImageVariable: Variable<UIImage>
    
    
    
    // Output
    var shouldEditVariable: Variable<Bool>
    
    
    
    // Private
    var dataStack: RGADataStack
    private let disposeBag = DisposeBag()
    private var contact: RGAContact
    
    
    
    /*
    */
    init( contact: RGAContact, dataStack: RGADataStack){
        
        self.dataStack = dataStack
        self.contact = contact
        
        shouldEditVariable = Variable<Bool>(false)
        
        contactNameVariable = Variable<String>( contact.name)
        contactEmailVariable = Variable<String>( contact.email)
        contactBioVariable = Variable<String>( contact.bio)
        contactPhotoVariable = Variable<UIImage>( contact.image)
        contactBackgroundImageVariable = Variable<UIImage>( contact.image)
        
        super.init()
        
    }
    
    
    
    /*
    */
    func deleteContact() {
        dataStack.deleteContact(contact )
    }
    
    
    
    /*
     */
    func editContact() {
        self.shouldEditVariable.value = true
    }
    
    
    
    /*
    */
    func doneEditing() {
        self.shouldEditVariable.value = false
        
        dataStack.update {
            
            self.contact.name = self.contactNameVariable.value
            self.contact.email = self.contactEmailVariable.value
            self.contact.bio = self.contactBioVariable.value
            
        }
    }
    
}
