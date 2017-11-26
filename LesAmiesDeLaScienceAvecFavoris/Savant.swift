//
//  Savant.swift
//  LesAmiesDeLaScienceAvecFavoris
//
//  Created by Alain on 17-11-26.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation

import RealmSwift
import Realm // Need to add import if you override default initializer!

/// ATTENTION, realm n'aime pas les caractères accentués dans les noms de classes et de propriétés
class Savant: Object {
    @objc dynamic var nom       = ""
    @objc dynamic var photo     = ""
    @objc dynamic var texte     = ""
    @objc dynamic var naissance = ""

    // Étant donné que les info des savants sont dans un dictionnaire,
    // ce constructeur permet de créer une instance de Savant à partir d'un dictionnaire.
    convenience init(source:Dictionay<String, String>) {
        self.init()
        // self.uid = UUID().uuidString
        self.nom = source["nom"] ?? "Erreur sur le nom!"
        self.photo = source["photo"] ?? "n/a"
        self.texte = source["texte"] ?? "n/a"
        self.naissance = source["naissance"] ?? ""
    }
    
    // Méthodes de classe pour la mise à jour des données dans la BD.
    static func ajouter(unSavant: Savant) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(unSavant)
        }
    } // ajouter

    static func lire() ->  Results<Savant> {
        let realm = try! Realm()
        return realm.objects(Savant.self)
    } // lire
    
    static func modifier(unSavant: Savant) {
        let realm = try! Realm()
    } // modifier
    
    static func effacer(unSavant: Savant) {
        let realm = try! Realm()
    } // effacer

} // class Tache

