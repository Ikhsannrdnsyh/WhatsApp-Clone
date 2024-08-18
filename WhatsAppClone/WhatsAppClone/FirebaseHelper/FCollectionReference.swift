//
//  FCollectionReference.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 12/08/24.
//

import Foundation
import Firebase

enum FCollectionReference: String {
    case User
    case Recent
    case Message
    case Typing
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}


