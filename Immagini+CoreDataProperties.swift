//
//  Immagini+CoreDataProperties.swift
//  
//
//  Created by Enrico Alberti on 24/03/18.
//
//


import Foundation
import CoreData


extension Impegno {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Impegno> {
        return NSFetchRequest<Impegno>(entityName: "Impegno")
    }
    
    @NSManaged public var materia: String?
    @NSManaged public var completato: Bool
    @NSManaged public var descrizione: String?
    @NSManaged public var perData: String?
    @NSManaged public var id: String?
    @NSManaged public var tipo: String?
    @NSManaged public var colore: String?
    
}

extension Immagini {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Immagini> {
        return NSFetchRequest<Immagini>(entityName: "Immagini")
    }
    
    @NSManaged public var materia: String?
    @NSManaged public var image: String?
    @NSManaged public var idOfImpegno: String?
    @NSManaged public var idOfImage: String?
    
}

extension Mail {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mail> {
        return NSFetchRequest<Mail>(entityName: "Mail")
    }
    
    @NSManaged public var password: String?
    @NSManaged public var mail: String?
}

extension Registro {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Registro> {
        return NSFetchRequest<Registro>(entityName: "Registro")
    }
    
    @NSManaged public var materia: String?
    @NSManaged public var codice: String?
    @NSManaged public var idMateria: String?
    @NSManaged public var data: String?
    @NSManaged public var votoDecimale: Int32
    @NSManaged public var votoDisplay: String?
    @NSManaged public var posizione: Int16
    @NSManaged public var notePerFamiglia: String?
    @NSManaged public var tipoVoto: String?
    @NSManaged public var periodoPos: Int16
    
}

extension OrarioD {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrarioD> {
        return NSFetchRequest<OrarioD>(entityName: "OrarioD")
    }
    
    @NSManaged public var from: String?
    @NSManaged public var to: String?
    @NSManaged public var materia: String?
    @NSManaged public var descrizione: String?
    @NSManaged public var giorno: String?
    @NSManaged public var colore: String?
    @NSManaged public var id: String?
}
