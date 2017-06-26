//
//  PokemonDetailVC.swift
//  UdemyPokeDecks
//
//  Created by Lily Hofman on 6/25/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var next_evo_one: UIImageView!
    @IBOutlet var next_evo_two: UIImageView!
    
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var nextEvolutionLabel: UILabel!
    @IBOutlet var defenseLabel: UILabel!
    @IBOutlet var attackLabel: UILabel!
    @IBOutlet var pokeDexIdLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemon.downloadPokemonDetails(completed: {
            self.updateUI()
        })

        // Do any additional setup after loading the view.
    }

    
    func updateUI(){
        
        self.typeLabel.text = pokemon.type
        self.weightLabel.text = pokemon.weight
        self.heightLabel.text = pokemon.height
        
        self.defenseLabel.text = pokemon.defense
        self.pokeDexIdLabel.text = "\(pokemon.id)"
        self.attackLabel.text = pokemon.attack

        self.descriptionLabel.text = pokemon.description
        self.nextEvolutionLabel.text = pokemon.nextEvolutionTxt
        
        if pokemon.nextEvolutionID == ""{
            self.nextEvolutionLabel.text = "No Evolutions"
            self.next_evo_two.isHidden = true
        }else{
            self.next_evo_two.image = UIImage(named: pokemon.nextEvolutionID)
            let str = "Next Evolution: \(pokemon.nextEvolutionTxt) \(pokemon.nextEvolutionLevel)"
            self.nextEvolutionLabel.text! = str

        }
        
        self.mainImage.image = UIImage(named: "\(pokemon.id)")
        self.next_evo_one.image = UIImage(named: "\(pokemon.id)")
        self.nameLabel.text = pokemon.name.capitalized
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
