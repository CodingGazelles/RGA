//
//  MasterViewController.swift
//  RGA
//
//  Created by Tancrède on 9/20/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa




/*
 */
class RGAMasterViewController: UITableViewController {
    
    
    
    // MVVM
    let viewModel = RGAMasterViewModel( dataStack: RGADataStack())
    
    
    
    // Rx
    let disposeBag = DisposeBag()
    
    
    
    // Outlet
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    
    
    
    // TableCell
    let cellIdentifier = "ContactCellView"
    var cellViewNib: UINib!

    
    
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
        
        
        // Delete default delegate because conflicting with Rx
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
        
        // Binding contacts
        viewModel.contactListObservable
            .bindTo(tableView.rx_itemsWithCellIdentifier(self.cellIdentifier, cellType: RGAContactCellView.self)) { ( row, element, cell) in
                
                cell.contactName.text = element.name
                cell.contactEmail.text = element.email
                cell.contactImage.image =  RGAContactImageSerializer.toUIImage( element.imageData)
                cell.contactAge.text = " (" + String( element.birthDate.yearsTillNow()) + "y)"
                
            }
            .addDisposableTo(disposeBag)
        
        
        // Binding row selection
        tableView
            .rx_modelSelected( RGAContact)
            .subscribeNext { contact in
                
                
                // Push DetailViewController
                let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier(RGADetailViewController.Identifier) as! RGADetailViewController
                
                detailVC.viewModel = RGADetailViewModel( contact: contact, dataStack: self.viewModel.dataStack)
                
                self.navigationController!.pushViewController(detailVC, animated: true)
                
                
            }
            .addDisposableTo(disposeBag)
        
        
        // Binding Nav bar button
        addBarButtonItem
            .rx_tap
            .subscribeNext { [unowned self] _ in
                NSLog("Add button clicked")
                
                
                self.viewModel.addContact()
                
                
                // Change VC
                if let contact = self.viewModel.contactAddedVariable.value {
                    
                    
                    // Push DetailViewController
                    let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier(RGADetailViewController.Identifier) as! RGADetailViewController
                    
                    detailVC.viewModel = RGADetailViewModel( contact: contact, dataStack: self.viewModel.dataStack)
                    
                    self.navigationController!.pushViewController(detailVC, animated: true)
                    
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

        
        
        // Register table cell view
        cellViewNib = UINib.init(nibName: cellIdentifier, bundle: nil)
        tableView.registerNib( cellViewNib, forCellReuseIdentifier: cellIdentifier)
        
        
        // Configure tablerow
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = 110
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        
    }
    
}




// MARK: - Actions on the View
/*
*/
extension RGAMasterViewController {

    
    /*
     Insert a new Contact in DB
    */
    func insertNewObject(sender: AnyObject) {
        RGADataStack().writeContact(RGAContact())
    }
    
}





