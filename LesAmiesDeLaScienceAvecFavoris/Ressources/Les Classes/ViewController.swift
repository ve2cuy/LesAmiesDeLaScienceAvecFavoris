//
//  ViewController.swift
//  module 03.solution
//
//  Created by Alain on 2015-09-13.
//  Copyright (c) 2015 Production sur support. All rights reserved.
//  Module 4

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var CVSavant: UICollectionView!
    
    @IBOutlet weak var collectionDeSavants: UICollectionView!
    
    var lesAmisDeLaScienceData:[Savant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Charger les données
        obtenirLesDonnées()
//        let pathFichierPlist = Bundle.main.path(forResource: "amisDelaScience", ofType: "plist")!
//        lesAmisDeLaScienceData = NSArray(contentsOfFile: pathFichierPlist) as! Array
    }
    
    /**
 
     */
    func obtenirLesDonnées(){
        let uneURL = Bundle.main.url(forResource: "amisDeLaScience", withExtension: "json")
        if let _data = NSData(contentsOf: uneURL!) as Data? {
            // Note: Class.self veut dire "de type Class"
            lesAmisDeLaScienceData = try! JSONDecoder().decode(Array<Savant>.self, from: _data)
            print(lesAmisDeLaScienceData)
            
            for contenu in lesAmisDeLaScienceData {
                // Note: ?? est le 'nil-coalescing operator'
                let nom = contenu.nom ?? "Erreur: Nom non disponible"
                let texte = contenu.texte  ?? "Erreur: Texte non disponible"
                print ("\(nom) -> Réalisations:\n\t \(texte)\n\n")
            }
        } // if let
    } // obtenirLesDonnées()
    
    // MARK: - Les méthodes de protocoles de UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lesAmisDeLaScienceData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Attention, avec un CollectionView, il faut absolument utiliser le recyclage:
        
        var celluleCourante:CVCSavant
        
        let nomModele = (indexPath as NSIndexPath).row % 2 == 0 ? "modeleCelluleSavant":"modeleCelluleSavant2"
        
        // Recyclage obligatoire pour un UICollectionViewCell
        if let unPersonnageScientifique =
            collectionView.dequeueReusableCell(withReuseIdentifier: nomModele, for:indexPath) as? CVCSavant {
            celluleCourante = unPersonnageScientifique
        } else
        {
            print("# Erreur lors de la récupération de 'UICollectionViewCell'\n")
            celluleCourante = CVCSavant()
        }  //  if let unPersonnageScientifique = tableView.dequeueReusableCellWithIdentifier
        
        // Renseigner les élements de la cellule courante
        
        // Recette pour obtenir la valeur de l'année courante
        let date = Date()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year], from: date)
        let anneeCourante = components.year
        let stringAnneeNaissance = lesAmisDeLaScienceData[(indexPath as NSIndexPath).row].naissance ?? "" // naissance non dispobible
        let anneeNaissance = Int(stringAnneeNaissance) ?? anneeCourante
        
        let age = " - \(anneeCourante! - anneeNaissance!) ans"
        
        celluleCourante.savantNom.text = lesAmisDeLaScienceData[indexPath.row].nom! + age
        celluleCourante.savantTexte.text = lesAmisDeLaScienceData[(indexPath as NSIndexPath).row].texte!
        
        celluleCourante.savantImage.image = UIImage(named: lesAmisDeLaScienceData[(indexPath as NSIndexPath).row].photo!)
        
        return celluleCourante
    }
    
    // MARK: - Préparation du segue
    
    // Méthode exécutée automatiquement avant un segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let selection = (CVSavant.indexPath(for: sender as! UICollectionViewCell)! as NSIndexPath).row
        
        print("Exécution de la méthode: prepareForSegue pour la cellule numéro: \(selection)\n")
        
        // 2 - Créer un objet pointant sur l'instance de classe de la destination
        let destination = segue.destination as! VCDetails
        
        // 3 - Passer les informations au controleur de destination
        destination.informationsDuSavantCourant = lesAmisDeLaScienceData[selection]
        
        //destination.details = amis[selection]
    }  // prepareForSegue
}

