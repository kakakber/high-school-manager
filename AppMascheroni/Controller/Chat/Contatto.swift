//
//  Contatto.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 12/10/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import Foundation



class Contatto{
    
    private var _nomeContatto = ""
    private var _idContatto = ""
    
    init(id: String, nome: String){
        _nomeContatto = nome
        _idContatto = id
    }
    
    var nomeContatto: String {
        get {
            return _nomeContatto
        }
    }
    
    var idContatto: String {
        get {
            return _idContatto
        }
    }
    
}
