//
//  cellIdentifier.swift
//  RGA
//
//  Created by Tancrède on 9/22/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit




class RGAContactCellView: UITableViewCell {
    
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactEmail: UILabel!
    @IBOutlet weak var contactAge: UILabel!
    
    
    /*
     Finalizing configuration
     */
    override func awakeFromNib() {
        layoutMargins = UIEdgeInsetsZero
    }
    
}
