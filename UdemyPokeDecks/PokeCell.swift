//
//  PokeCell.swift
//  UdemyPokeDecks
//
//  Created by Lily Hofman on 6/25/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet var pokeIcon: UIImageView!
    @IBOutlet var pokeName: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //each view has a layer cell where you can implement things to modify how it looks
        layer.cornerRadius = 5.0
    }
    
    func configureCell(_ pokemon: Pokemon){
        self.pokemon = pokemon
        pokeName.text = self.pokemon.name.capitalized
        pokeIcon.image = UIImage(named: "\(self.pokemon.id)")
    }
}
