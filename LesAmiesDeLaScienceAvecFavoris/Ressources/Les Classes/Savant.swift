//
//  Savant.swift
//  LesAmiesDeLaScienceAvecFavoris
//
//  Created by Alain on 17-11-26.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation
import RealmSwift
// import Realm // Need to add import if you override default initializer!

/// ATTENTION, realm n'aime pas les caractères accentués dans les noms de classes et de propriétés
// NOTE: Pour rendre une classe compatible avec realm il faut la définir à partir de la classe realm: 'Object'.
class Savant: Object, Codable {
    //NOTE: les déclarations débutants par "@objc dynamic" seront ajoutées à la BD
    @objc dynamic var nom:String?
    @objc dynamic var photo:String?
    @objc dynamic var texte:String?
    @objc dynamic var naissance:String?
    /// Pour les nombres, pas d'optionnelles:
    @objc dynamic var _PI:Float = 3.141592
    var extra = "Ce champ ne sera pas sauvegardé dans la BD - il n'a pas : '@objc dynamic' dans sa déclaration."

    // Étant donné que les info des savants sont dans un dictionnaire,
    // Ce constructeur permet de créer une instance de Savant à partir d'un dictionnaire.
    // ATTENTION: Ce n'est CERTAINEMENT pas le cas pour votre projet!!!!!
    convenience init(source:Dictionary<String, String>) {
        self.init()
        // self.uid = UUID().uuidString
        self.nom = source["nom"] ?? "Erreur sur le nom!"
        self.photo = source["photo"] ?? "n/a"
        self.texte = source["texte"] ?? "n/a"
        self.naissance = source["naissance"] ?? ""
    }
    
    // Méthodes de classe pour la mise à jour des données dans la BD.
    // Exemple d'un prédicat: .filter("vegan = true AND ANY lines.canteens.name = %@", selectedCanteenType.rawValue)
    static func ajouter(unSavant: Savant) -> Bool {
        let realm = try! Realm()
        // Vérifier si le savant est déjà présent dans la liste des favoris
        if realm.objects(Savant.self).filter("nom = %@" , unSavant.nom!).count != 0
        { return false }
        
        // Ajouter aux favoris
        try! realm.write {
            realm.add(unSavant)
        }
        return true
    } // ajouter

    static func lire() ->  Results<Savant> {
        let realm = try! Realm()
        return realm.objects(Savant.self)
    } // lire
    
    static func modifier(unSavant: Savant) {
        let realm = try! Realm()
        try! realm.write {
            unSavant.nom = "Youpi"
            unSavant.texte = "Abc Def"
         }
    } // modifier
    
    static func effacer(nomSavant: String) -> Bool {
        let realm = try! Realm()
        // Vérifier si le savant est déjà présent dans la liste des favoris
        let resultat = realm.objects(Savant.self).filter("nom = %@" , nomSavant)
        guard resultat.count != 0 else { return false}

        try! realm.write {
            realm.delete(resultat[0]) // Effacer le premier trouvé - il ne devrait y en avoir qu'un seul!
        }
        return true
   } // effacer

} // class Tache

