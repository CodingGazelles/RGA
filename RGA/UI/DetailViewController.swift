//
//  DetailViewController.swift
//  RGA
//
//  Created by Tancrède on 9/20/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit
import CoreImage
import RxSwift
import RxCocoa




class RGADetailViewController: UIViewController {

    
    // Storyboard ID
    static let Identifier = "RGADetailViewController"
    
    
    // MVVM
    var viewModel: RGADetailViewModel!
    
    
    // Rx
    let disposeBag = DisposeBag()
    
    
    //Oulets
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    
    
    
    // Core Image
    let context = CIContext(options:nil)
    
    
    
    /*
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        bindViewModel()
        
    }
    
    
    
    /*
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.active = true
    }
    
    
    
    /*
     */
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.active = false
    }
    
    
    
    /*
     */
    func bindViewModel() {
        
        
        // Binding background image
        viewModel.contactBackgroundImageVariable.asObservable()
            .subscribeNext { image in
                
                
                // Set background image
                let ciImage = CIImage(image: image)
                
                let monoFilter = CIFilter(name: "CIPhotoEffectMono")
                monoFilter!.setValue(ciImage, forKey: kCIInputImageKey)
                var cgimg = self.context.createCGImage(monoFilter!.outputImage!, fromRect: monoFilter!.outputImage!.extent)
                
                let ctFilter = CIFilter( name: "CIColorControls")
                ctFilter!.setValue(CIImage(CGImage: cgimg), forKey: kCIInputImageKey)
                ctFilter!.setValue( 0.4, forKey: kCIInputBrightnessKey)
                cgimg = self.context.createCGImage(ctFilter!.outputImage!, fromRect: ctFilter!.outputImage!.extent)
                
                self.backgroundImage.image = UIImage(CGImage: cgimg)
                
                
//                // Set TextFields color
//                let avFilter = CIFilter(name: "CIAreaAverage")
//                avFilter!.setValue(ciImage, forKey: kCIInputImageKey)
//                cgimg = self.context.createCGImage(ctFilter!.outputImage!, fromRect: ctFilter!.outputImage!.extent)
                
                
            }
            .addDisposableTo( disposeBag)

        
        
        // Resize textfields
        viewModel.contactNameVariable
            .asObservable().subscribeNext{ text in
                self.nameTextField.text = text
                self.nameTextField.sizeToFit()
        }
        .addDisposableTo(disposeBag)
        
        viewModel.contactEmailVariable
            .asObservable().subscribeNext{ text in
                self.emailTextField .text = text
                self.emailTextField.sizeToFit()
            }
            .addDisposableTo(disposeBag)
        
        
        
        // Observe keybord inputs
        _ = self.nameTextField.rx_text.subscribeNext{ text in
            self.viewModel.contactNameVariable.value = text
        }
        .addDisposableTo(disposeBag)
        _ = self.emailTextField.rx_text.bindTo( viewModel.contactEmailVariable).addDisposableTo(disposeBag)
        _ = self.bioTextView.rx_text.bindTo( viewModel.contactBioVariable).addDisposableTo(disposeBag)
        _ = viewModel.contactPhotoVariable.asObservable().map{ Optional($0)}.bindTo( self.contactImage.rx_image).addDisposableTo(disposeBag)
        
        
        
        // Binding edit button
        editBarButtonItem.rx_tap.subscribeNext {
            NSLog("Edit button clicked")
            
            self.viewModel.editContact()
            
            
            // Show borders
            self.nameTextField.superview!.layer.borderWidth = 1.0
            self.nameTextField.superview!.layer.borderColor = UIColor(red: 127/255, green: 60/255, blue: 76/255, alpha: 1.0).CGColor
            
            self.emailTextField.superview!.layer.borderWidth = 1.0
            self.emailTextField.superview!.layer.borderColor = UIColor(red: 127/255, green: 60/255, blue: 76/255, alpha: 1.0).CGColor
            
            self.bioTextView.superview!.layer.borderWidth = 1.0
            self.bioTextView.superview!.layer.borderColor = UIColor(red: 127/255, green: 60/255, blue: 76/255, alpha: 1.0).CGColor
            
        }
        .addDisposableTo(disposeBag)
        
        
        
        // Binding delete button
        deleteBarButtonItem.rx_tap.subscribeNext {
            NSLog("Delete button clicked")
            
            
            // Deleting contact
            self.viewModel.deleteContact()
            
            
            // Back to Master View
            self.navigationController!.popViewControllerAnimated(true)
            
        }
        .addDisposableTo(disposeBag)
        
        
        
        // Binding Done button
        doneButtonItem.rx_tap.subscribeNext {
            NSLog("Done button clicked")
            
            if self.viewModel.shouldEditVariable.value {
                
                
                //Mode edition
                self.viewModel.doneEditing()
                
                
                // Hide borders
                self.nameTextField.superview!.layer.borderWidth = 0
                self.emailTextField.superview!.layer.borderWidth = 0
                self.bioTextView.superview!.layer.borderWidth = 0
                
                
            } else {
                
                
                // Mode consulttion
                // Back to Master View
                self.navigationController!.popViewControllerAnimated(true)
                
            }
            
        }
        .addDisposableTo(disposeBag)
        
    }
    
    
    
    /*
    */
    func initUI() {
        
        
        // Update nav bar
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Menlo-Bold", size: 21)!, NSForegroundColorAttributeName: UIColor(red: 127/255, green: 60/255, blue: 76/255, alpha: 1.0)]
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 127/255, green: 60/255, blue: 76/255, alpha: 1.0)
        
        
        // Delegate
        nameTextField.delegate = self
        emailTextField.delegate = self
        bioTextView.delegate = self
        
        
        // Padding
//        nameTextField.superview!.bounds = CGRectInset(nameTextField.superview!.frame, 10.0, 10.0)
//        emailTextField.superview!.bounds = CGRectInset(emailTextField.superview!.frame, 10.0, 10.0)
        
        
    }
    
    
    
}




// MARK: - Conformance to UITextFieldDelegate
/*
 */
extension RGADetailViewController: UITextFieldDelegate {
    
    
    /*
    */
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return viewModel.shouldEditVariable.value
    }
    
}




// MARK: - Conformance to UITextViewDelegate
/*
 */
extension RGADetailViewController: UITextViewDelegate {
    
    
    /*
    */
    func textViewShouldBeginEditing( textView: UITextView) -> Bool {
        return viewModel.shouldEditVariable.value
    }
    
}

