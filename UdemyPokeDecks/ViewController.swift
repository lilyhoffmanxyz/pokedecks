//
//  ViewController.swift
//  UdemyPokeDecks
//
//  Created by Lily Hofman on 6/25/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate{

    var pokedeck = [Pokemon]()
    var filtered_pokedeck = [Pokemon]()
    
    var musicPlayer: AVAudioPlayer!

    @IBOutlet var searchBar: UISearchBar!
    var inSearchMode = false
    
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        
        parsePokemonCSV()
        initAudio()
    
    }

    
    func initAudio(){
        let path = Bundle.main.path(forResource: "Game_Of_Thrones_Main_Title-576202", ofType: "mp3")
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    @IBAction func musicButtonPressed(_ sender: Any) {
        if musicPlayer.isPlaying{
            (sender as? UIButton)?.alpha = 0.3
            musicPlayer.pause()
        }else{
            musicPlayer.play()
            (sender as? UIButton)?.alpha = 1.0
        }
    }
    
    
    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows //returns list of rows. each row is a dictionary
            
            for row in rows{
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                let newPoke = Pokemon(name: name, id: pokeID)
                pokedeck.append(newPoke)
            }
            
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            if inSearchMode{
                let pokemon = filtered_pokedeck[indexPath.row]
                cell.configureCell(pokemon)
            }else{
                let pokemon = pokedeck[indexPath.row]
                cell.configureCell(pokemon)
            }
            
            return cell
        }else{
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filtered_pokedeck.count
        }else{
            return pokedeck.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke: Pokemon!
        if(inSearchMode){
            poke = filtered_pokedeck[indexPath.row]
        }else{
            poke = pokedeck[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        }else{
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            filtered_pokedeck = pokedeck.filter({
                $0.name.range(of: lower) != nil
            })
            collectionView.reloadData()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC"{
            if let detailsVC = segue.destination as? PokemonDetailVC{
                if let poke = sender as? Pokemon{
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
    

}

