//
//  TBVFavoris.swift
//  LesAmiesDeLaScienceAvecFavoris
//
//  Created by Alain on 17-11-26.
//  Copyright © 2017 Alain. All rights reserved.
//

import UIKit
import RealmSwift

class TBVFavoris: UITableViewController {
    @IBOutlet var tableViewFavoris: UITableView!
    
    let realm = try! Realm()
    lazy var tableauDesFavoris: Results<Savant> = {
        realm.objects(Savant.self)}()
    
    override func viewDidAppear(_ animated: Bool) {
        // Charger les données à chaque fois que cette scène est présentée.
        tableauDesFavoris = Savant.lire()
        tableViewFavoris.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableauDesFavoris.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Rien de 'fancy', le modèle de base est suffisant pour afficher le nom.
        let cell = UITableViewCell()
        cell.textLabel?.text = tableauDesFavoris[indexPath.row].nom
        return cell
    }

    // --------------------------------------------------------------------------
    // Méthode de délégation pour gérer la suppression de la cellule sur swap
    // Note: Il suffit d'ajouter cette méthode au projet pour qu'il soit possible
    // d'effacer une cellule d'un TV sur un simple glissement vers la gauche.
    //
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let nomSavantDeLaSélection = tableView.cellForRow(at: indexPath)?.textLabel?.text
            if Savant.effacer(nomSavant: nomSavantDeLaSélection!) {
                print("Favori effacé")
                // Recharger les données
                tableauDesFavoris = Savant.lire()
                tableView.reloadData()
            } else {
                print("Étrangement, le savant n'était pas dans la liste des favoris ... !@#$")
            } // if Savant.effacer
        } // if editingStyle == .delete
    } // tableView commit editingStyle

}
