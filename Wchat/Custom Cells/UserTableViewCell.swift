//
//  UserTableViewCell.swift
//  my first app
//
//  Created by Adam Essam on 8/3/19.
//  Copyright © 2019 Adam Essam. All rights reserved.
//

import UIKit

//3mla leh el delegate 34an n3raf emta el user 3mal tap 3ala el avatar bta3t ay user mwgod fel contacts w tb3n el delegate hyn3l el info bta3t el user ely et3ml 3aleh tap
protocol UserTableViewCellDelegate {
    func didTapAvatarImage(indexPath : IndexPath)
}


class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var indexPath: IndexPath!
    
    var delegate: UserTableViewCellDelegate?
    
    //34an n2dar n3ml click 3ala el image b2a m7tagen tapGesture
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // hena el fuction deh zy didload ay 7aga mktoba gowaha bttnfez ama el app yegy y2om
        tapGestureRecognizer.addTarget(self, action: #selector(self.avatarTap))
        //el satr dah 34an el user y3raf y3ml interact with our imageView
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    /*generating the cells
    we are gonna pass user object and our cell we take the name of the user and
    the avatar and presented */
    //m7tagen el indexPath 34an ama a press 3ala el avatar I can present my profile 34an b2a el mwdo3 dah kolo ysht8al m7tag el IndexPath
    func generateCellWith(fUser: FUser, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        //hena bro7 ageb el fullname ely mwgod fel firebase w asaweh bel label ely na 3mlo hena 34an a3rdo feh
        self.fullNameLabel.text = fUser.fullname
        
        /* tb3n e7a olna enna 34an n3ml save ll sora 3ala el firestore kona m7tagen n7wlha l String fa 34an ngeb el sora b2a men el firestore w n7o4ha
        m7tagen n3ml 3aks el 3mlya deh m7tagen n7wlha men String L data and then convert this data to UI Image to presented */
        
        if fUser.avatar != "" {
            imageFromData(pictureData: fUser.avatar) { (avatarImage) in
                if avatarImage != nil {
                    //circleMasked mwgoda fel HelperFunctions bt5li el avatar circle bas
                 self.avatarImageView.image = avatarImage!.circleMasked
                }
            }
        }
    }
    
    //el 7eta bta3t el objective C deh 34an na est5dem selector fo2 m3 avatartap() lazem 22olo @objc
    
    @objc func avatarTap() {
        
        delegate!.didTapAvatarImage(indexPath: indexPath) // dah by listen 3ala 3ala el avatarImage lo et3mlo tapped
    }

}
