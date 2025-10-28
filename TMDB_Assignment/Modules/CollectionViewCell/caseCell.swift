//
//  caseCell.swift
//  TMDB_Assignment
//
//  Created by Tarun on 28/10/25.
//

import UIKit

class caseCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var castLbl: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 10
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.borderWidth = 1
        
        profileImg.layer.cornerRadius = 20
        profileImg.layer.borderColor = UIColor.gray.cgColor
        profileImg.layer.borderWidth = 1
    }
    
    func configure(data: Movie) {
        
    }

}
