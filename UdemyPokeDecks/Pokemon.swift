//
//  Pokemon.swift
//  UdemyPokeDecks
//
//  Created by Lily Hofman on 6/25/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    //Attributes
    private var _name: String!
    private var _id: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionString: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!

    
    //Getters
    var name: String{
        return _name
    }
    var id: Int{
        return _id
    }
    var description: String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    var defense: String{
        if _defense == nil{
            _defense = ""
        }
        
        return _defense
    }
    var height: String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    var nextEvolutionTxt: String{
        if _nextEvolutionTxt == nil{
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    var nextEvolutionString: String{
        if _nextEvolutionString == nil{
            _nextEvolutionString = ""
        }
        return _nextEvolutionString
    }
    var nextEvolutionID: String{
        if _nextEvolutionID == nil{
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    var nextEvolutionLevel: String{
        if _nextEvolutionLevel == nil{
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }

    
    init(name: String, id: Int){
        self._name = name
        self._id = id
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._id!)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        Alamofire.request(_pokemonURL).responseJSON(completionHandler: { (response) in
            if let dict = response.result.value as? Dictionary<String, Any>{
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                if let height = dict["height"] as? String{
                    self._height = height
                }
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0{
                    if let name = types[0]["name"]{
                        self._type = name.capitalized
                    }
                    if types.count > 1{
                        for x in 1..<types.count{
                            if let name = types[x]["name"]{
                                self._type! += "/\(name)"
                            }
                        }
                    }
                }
                if let descriptions_array = dict["descriptions"] as? [Dictionary<String, String>], descriptions_array.count > 0{
                    if let url = descriptions_array[0]["resource_uri"]{
                        let full_url = "\(URL_BASE)\(url)"
                        Alamofire.request(full_url).responseJSON(completionHandler: { (response) in
                            if let descriptions_dictionary = response.result.value as? Dictionary<String, Any>{
                                if let description = descriptions_dictionary["description"] as? String{
                                    self._description = description
                                }
                            }
                        completed()
                        })
                    }
                }
                if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>], evolutions.count > 0{
                    if let nextEvolution = evolutions[0]["to"] as? String{
                        if nextEvolution.range(of: "mega") == nil{
                            self._nextEvolutionTxt = nextEvolution
                            if let uri = evolutions[0]["resource_uri"] as? String{
                                let newString = uri.replacingOccurrences(of: "api/v1/pokemon/", with: "")
                                let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionID = nextEvoId
                                if let lvlExist = evolutions[0]["level"]{
                                    if let lvl = lvlExist as? Int{
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
            completed()
            
        })
        
        
    }
}
