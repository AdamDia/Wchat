//
//  RecentChatsTableViewCell.swift
//  my first app
//
//  Created by Adam Essam on 8/21/19.
//  Copyright © 2019 Adam Essam. All rights reserved.
//

import UIKit

protocol RecentChatsTableViewCellDelegate {
    func didTapAvatarImage(indexPath : IndexPath)
}


class RecentChatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var messageCounterLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageCounterBackgroundView: UIView! //el background deh 3bara 3n View ma7tot gowah label hyt3rad feh el missed message fa hn5li background circle
    var indexPath : IndexPath!
    let tapGesture = UITapGestureRecognizer()
    var delegate : RecentChatsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // el goz2 dah na mesh fahmo awiii rage3 3aleh *******
        messageCounterBackgroundView.layer.cornerRadius = messageCounterBackgroundView.frame.width / 2
        
        tapGesture.addTarget(self, action: #selector(self.avatarTap))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // genrate el cells b2a
    //MARK: Generate Cell
    
    func generateCell(recentChat : NSDictionary, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        
        //set userinterFace
        
        self.nameLabel.text = recentChat[kWITHUSERUSERNAME] as? String
        self.lastMessageLabel.text = recentChat[kLASTMESSAGE] as? String
        self.messageCounterLabel.text = recentChat[kCOUNTER] as? String
        
        if let avatarString = recentChat[kAVATAR] {
            imageFromData(pictureData: avatarString as! String) { (avatarImage) in
                if avatarImage != nil {
                    self.avatarImageView.image = avatarImage!.circleMasked
                }
            }
        }
        
        //counter tb3n hyzhar bas lo mesh zero tb3n
        
        if recentChat[kCOUNTER] as! Int != 0 {
            self.messageCounterLabel.text = "\(recentChat[kCOUNTER] as! Int)"
            self.messageCounterBackgroundView.isHidden = false
            self.messageCounterLabel.isHidden = false
        } else {
            
            self.messageCounterBackgroundView.isHidden = true
            self.messageCounterLabel.isHidden = true
            
            
        }
        
        var date: Date!
        
        if let created = recentChat[kDATE] {
            
            if (created as! String).count != 14 { // 14 34an el date ely b3mlo save 3ala firebase el format bta3o men 14 digit
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)!
            }
        } else { // if we don't have any recent chat dates savedn
            date = Date()
        }
        
        self.dateLabel.text = timeElapsed(date: date)
    }
    
    @objc func  avatarTap() {
        
        print("avatar tap \(indexPath)")
        delegate?.didTapAvatarImage(indexPath: indexPath)
    }

}

