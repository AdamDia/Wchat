//
//  CollectionReference.swift
//  my first app
//
//  Created by Adam Essam on 7/27/19.
//  Copyright © 2019 Adam Essam. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
}


func reference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}
