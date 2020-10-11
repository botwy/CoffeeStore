//
//  FirebaseReference.swift
//  iCoffee
//

import Firebase

enum FCollectionReference: String {
    case User
    case Menu
    case Order
    case Cart
    case Promotion
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
