//
//  CoreDataController.swift
//  
//
//  Created by Enrico Alberti on 02/12/17.
//

import Foundation
import CoreData
import UIKit

class CoreDataController{
    //controllo e gestione di tutti i dati salvati dall'utente
    
    static let shared = CoreDataController()
    private var context: NSManagedObjectContext
    
    private init() {
        //recupero l'istanza dell'app delegate della proprietà shared
        
        let application = UIApplication.shared.delegate as! AppDelegate
        
        self.context = application.persistentContainer.viewContext
    }
    
    func newImpegno(materia: String, completato: Bool, tipo: String, descrizione: String, perData: String, id : String, colore: String){
        
        //salvo elementi con CoreData nel database.
        
        let entity = NSEntityDescription.entity(forEntityName: "Impegno", in: self.context)
        
        let newImpegnoInFunc = Impegno(entity: entity!, insertInto: self.context)
        
        newImpegnoInFunc.materia = materia
        newImpegnoInFunc.tipo = tipo
        newImpegnoInFunc.completato = completato
        newImpegnoInFunc.descrizione = descrizione
        newImpegnoInFunc.perData = perData
        newImpegnoInFunc.id = id
        newImpegnoInFunc.colore = colore
        
        do {
            
            try self.context.save()
            
        } catch let error{
            
            print("[CDC] Problema salvataggio Impegno: \(newImpegnoInFunc.id!) in memoria")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
        
        print("[CDC] Impegno \(newImpegnoInFunc.descrizione!), materia: \(newImpegnoInFunc.materia!), tipo: \(newImpegnoInFunc.tipo!)---- salvato in memoria correttamente, completato : \(newImpegnoInFunc.completato)")
    }
    
    func newImage(forImpegnoId: String, forMateria: String, ImageString: String, ImageID: String, data: String, descrizione: String){
        let entity = NSEntityDescription.entity(forEntityName: "Immagini", in: self.context)
        
        let newImmagineInFunc = Immagini(entity: entity!, insertInto: self.context)
        newImmagineInFunc.data = data
        newImmagineInFunc.idOfImage = ImageID
        newImmagineInFunc.idOfImpegno = forImpegnoId
        newImmagineInFunc.image = ImageString
        newImmagineInFunc.materia = forMateria
        newImmagineInFunc.descrizione = descrizione
        
        do {
            
            try self.context.save()
            
        } catch let error{
            
            print("[CDC] Problema salvataggio Impegno: \(String(describing: newImmagineInFunc.idOfImage)) in memoria")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
    }
    
    
    func completaEvento(completato: Bool){
        let entity = NSEntityDescription.entity(forEntityName: "Impegno", in: self.context)
        
        let newImpegnoInFunc = Impegno(entity: entity!, insertInto: self.context)
        
        newImpegnoInFunc.completato = completato
        
        do {
            
            try self.context.save()
            
        } catch let error{
            
            print("[CDC] Problema salvataggio Impegno: \(newImpegnoInFunc.id!) in memoria")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
        
        print("")
        
    }
    
    
    
    func caricaTuttiGliImpegni() -> [Impegno]{
        
        print("[CDC] Recupero tutti gli impegni dal context ")
        
        let request: NSFetchRequest<Impegno> = NSFetchRequest(entityName: "Impegno")
        
        request.returnsObjectsAsFaults = false
        
        let impegni = self.loadImpegniFromFetchRequest(request: request)
        
        return impegni
        
    }
    
    func ImpegniPerData(date: String) {
        
        print("[CDC] Recupero tutti gli impegni dal context ")
        
        let request: NSFetchRequest<Impegno> = NSFetchRequest(entityName: "Impegno")
        
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "perData = %@", date)
        
        request.predicate = predicate
        
        let impegni = self.loadImpegniFromFetchRequest(request: request)
        
    }
    
    func ImmaginiPerMateria(materia: String)-> [Immagini] {
        
        print("[CDC] Recupero tutte le immagini dal context ")
        
        let request: NSFetchRequest<Immagini> = NSFetchRequest(entityName: "Immagini")
        
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "materia = %@", materia)
        
        request.predicate = predicate
        
        let immagini = self.loadImmaginiFromFetchRequest(request: request)
        
        return immagini
        
    }
    
    func loadImmaginiFromFetchRequest(request: NSFetchRequest<Immagini>) -> [Immagini] {
        
        var array = [Immagini]()
        
        do {
            
            array = try self.context.fetch(request)
            
            guard array.count > 0 else {print("[CDC] Non ci sono elementi da leggere "); return []}
            
        } catch let error {
            
            print("[CDC] Problema esecuzione FetchRequest")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
        
        return array
        
    }
    
    func ImpegniPerId(Id: String) -> Impegno {
        
        print("[CDC] Recupero tutti gli impegni per id dal context ")
        
        let request: NSFetchRequest<Impegno> = NSFetchRequest(entityName: "Impegno")
        
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "id = %@", Id)
        
        request.predicate = predicate
        
        let impegni = self.loadImpegniFromFetchRequest(request: request)
        
        return impegni[0]
        
    }
    
    func ImmaginiPerId(Id: String) -> Immagini {
        
        print("[CDC] Recupero tutti le img per id dal context ")
        
        let request: NSFetchRequest<Immagini> = NSFetchRequest(entityName: "Immagini")
        
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "idOfImage = %@", Id)
        
        request.predicate = predicate
        
        let impegni = self.loadImmaginiFromFetchRequest(request: request)
        
        return impegni[0]
        
    }
    
    func loadImpegniFromFetchRequest(request: NSFetchRequest<Impegno>) -> [Impegno] {
        
        var array = [Impegno]()
        
        do {
            
            array = try self.context.fetch(request)
            
            guard array.count > 0 else {print("[CDC] Non ci sono elementi da leggere "); return []}
            
        } catch let error {
            
            print("[CDC] Problema esecuzione FetchRequest")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
        
        return array
        
    }
    
    
    func cancellaImmagine(id: String) {
        
        let immag = self.ImmaginiPerId(Id: id)
        
        self.context.delete(immag)
        
        do {
            
            try self.context.save()
            
        } catch let errore {
            
            print("[CDC] Problema eliminazione libro ")
            
            print("  Stampo l'errore: \n \(errore) \n")
            
        }
        
    }
    
    
    func cancellaImpegno(id: String) {
        
        let impegno = self.ImpegniPerId(Id: id)
        
        self.context.delete(impegno)
        
        do {
            
            try self.context.save()
            
        } catch let errore {
            
            print("[CDC] Problema eliminazione libro ")
            
            print("  Stampo l'errore: \n \(errore) \n")
            
        }
        
    }
    
    //---------mail manage------
    
    func deleteMail(){
        
        let request: NSFetchRequest<Mail> = NSFetchRequest(entityName: "Mail")
        
        request.returnsObjectsAsFaults = false
        
        let mails = self.loadMailFromFetchRequest(request: request)
        
        for c in mails{
            self.context.delete(c)
        }
        
        
        do {
            try self.context.save()
            print("-----elimino-----")
            
        } catch let errore {
            
            print("[CDC] Problema eliminazione mail")
            
            print("  Stampo l'errore: \n \(errore) \n")
            
        }
    }
    
    func loadMailFromFetchRequest(request: NSFetchRequest<Mail>) -> [Mail] {
        
        var array = [Mail]()
        
        do {
            array = try self.context.fetch(request)
            
            guard array.count > 0 else {print("[CDC] Non ci sono elementi da leggere "); return []}
            
        } catch let error {
            
            print("[CDC] Problema esecuzione FetchRequest")
            
            print("  Stampo l'errore: \n \(error) \n")
        }
        return array
        
    }
    
    func checkPsw(mail: String)->String{
        //se la password per quella mail è stata salvata
        let request: NSFetchRequest<Mail> = NSFetchRequest(entityName: "Mail")
        
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "mail = %@", mail)
        
        request.predicate = predicate
        
        let mail = self.loadMailFromFetchRequest(request: request)
        if mail.count > 0{
            print("trovata password \(mail[0].password!)")
        }else{
            return "noPsw"
        }
        
        return mail[0].password!
        
    }
    
    func newPassword(psw: String, email: String){
        //salvare password
        let entity = NSEntityDescription.entity(forEntityName: "Mail", in: self.context)
        
        let newPassw = Mail(entity: entity!, insertInto: self.context)
        
        newPassw.password = psw
        newPassw.mail = email
        print("salvato \(email) di psw \(psw)")
        do {
            
            try self.context.save()
            
        } catch let error{
            
            print("[CDC] Problema salvataggio Password: \(String(describing: newPassw.mail)) in memoria")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
        
    }
    
    
    //----registro
    
    func newValutazione(materia: String, codice: String, idMateria: String, data: String, votoDecimale: Int32, votoDisplay: String, posizione: Int16, notePerFam: String, tipoVoto: String, periodoPos: Int16){
        
        //salvo elementi con CoreData nel database.
        
        let entity = NSEntityDescription.entity(forEntityName: "Registro", in: self.context)
        
        let newValutazioneInFunc = Registro(entity: entity!, insertInto: self.context)
        
        newValutazioneInFunc.materia = materia
        newValutazioneInFunc.codice = codice
        newValutazioneInFunc.idMateria = idMateria
        newValutazioneInFunc.data = data
        newValutazioneInFunc.votoDecimale = votoDecimale
        newValutazioneInFunc.votoDisplay = votoDisplay
        newValutazioneInFunc.posizione = posizione
        newValutazioneInFunc.notePerFamiglia = notePerFam
        newValutazioneInFunc.tipoVoto = tipoVoto
        newValutazioneInFunc.periodoPos = periodoPos
        
        
        do {
            
            try self.context.save()
            
        } catch let error{
            
            print("[CDC] Problema salvataggio valutazione: \(newValutazioneInFunc.codice) in memoria")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
        
        //print("[CDC] valutazione: materia: \(newValutazioneInFunc.materia), voto decimale: \(newValutazioneInFunc.votoDecimale), voto display: \(newValutazioneInFunc.votoDisplay), posizione: \(newValutazioneInFunc.posizione)---- salvato in memoria correttamente")
    }
    
    func loadValutazFromFetchRequest(request: NSFetchRequest<Registro>) -> [Registro] {
        
        var array = [Registro]()
        
        do {
            
            array = try self.context.fetch(request)
            
            guard array.count > 0 else {print("[CDC] Non ci sono elementi da leggere "); return []}
            
        } catch let error {
            
            print("[CDC] Problema esecuzione FetchRequest")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
        
        return array
        
    }
    
    var sa = 0
    func caricaTuttiLeValutazioniVoto() -> [voto]{//ritorna dato di tipo voto utilizzato nel view did load del registro
        
        print("[CDC] Recupero tutte le valutazioni ")
        
        let request: NSFetchRequest<Registro> = NSFetchRequest(entityName: "Registro")
        
        request.returnsObjectsAsFaults = false
        
        var array = [Registro]()
        
        do {
            
            array = try self.context.fetch(request)
            
            guard array.count > 0 else {print("[CDC] Non ci sono elementi da leggere "); return []}
            
        } catch let error {
            
            print("[CDC] Problema esecuzione FetchRequest")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
        
        var votoUsc : [voto] = []
        
        var cnt = 0
        for gp in array{
            var dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd"// yyyy-MM-dd"
            
            let date = dateFormatter.date(from: array[cnt].data!)
            
            let newww = voto(materia: array[cnt].materia!, idMateria: array[cnt].idMateria!, voto: Double(array[cnt].votoDecimale)/100, votoMostrabile: array[cnt].votoDisplay!, data: date!, diminutivo: "", displayPos: Double(array[cnt].posizione), notesForFamily: array[cnt].notePerFamiglia!, colore: "null", periodPos: Double(array[cnt].periodoPos), tipoVoto: array[cnt].tipoVoto!)
            
            votoUsc.append(newww)
            
            cnt += 1;
        }
        
        //let impegni = self.loadValutazFromFetchRequest(request: request)
        sa += 1
        print("doin core data num \(sa)")
        return votoUsc
        
    }
    
    func caricaTuttiLeValutazioni() -> [Registro]{
        
        print("[CDC] Recupero tutte le valutazioni ")
        
        let request: NSFetchRequest<Registro> = NSFetchRequest(entityName: "Registro")
        
        request.returnsObjectsAsFaults = false
        
        var array = [Registro]()
        
        do {
            
            array = try self.context.fetch(request)
            
            guard array.count > 0 else {print("[CDC] Non ci sono elementi da leggere "); return []}
            
        } catch let error {
            
            print("[CDC] Problema esecuzione FetchRequest")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
        
        
        //let impegni = self.loadValutazFromFetchRequest(request: request)
        
        return array
        
    }
    
    func ValutPerMateria(mat: String) -> [Registro] {
        
        print("[CDC] Recupero tutti gli impegni dal context ")
        
        let request: NSFetchRequest<Registro> = NSFetchRequest(entityName: "Registro")
        
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "materia = %@", mat)
        
        request.predicate = predicate
        
        let regt = self.loadValutazFromFetchRequest(request: request)
        
        return regt
        
    }
    
    func cancellaValutaz() {
        
        let vals = self.caricaTuttiLeValutazioni()
        
        for vg in vals{
            self.context.delete(vg)
        }
        
        do {
            
            try self.context.save()
            
        } catch let errore {
            
            print("[CDC] Problema eliminazione  ")
            
            print("  Stampo l'errore: \n \(errore) \n")
            
        }
        
    }
    
    //orario
    
    func newOrario(materia: String, descrizione: String, from: String, to: String, giorno: String, colore : String, id : String){
        
        //salvo elementi con CoreData nel database.
        
        let entity = NSEntityDescription.entity(forEntityName: "OrarioD", in: self.context)
        
        let newOrarioInFunc = OrarioD(entity: entity!, insertInto: self.context)
        
        
        newOrarioInFunc.materia = materia
        newOrarioInFunc.from = from
        newOrarioInFunc.to = to
        newOrarioInFunc.descrizione = descrizione
        newOrarioInFunc.giorno = giorno
        newOrarioInFunc.colore = colore
        newOrarioInFunc.id = id
        
        do {
            
            try self.context.save()
            
        } catch let error{
            
            print("[CDC] Problema salvataggio valutazione: \( newOrarioInFunc.materia) in memoria")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
        
        //print("[CDC] valutazione: materia: \(newValutazioneInFunc.materia), voto decimale: \(newValutazioneInFunc.votoDecimale), voto display: \(newValutazioneInFunc.votoDisplay), posizione: \(newValutazioneInFunc.posizione)---- salvato in memoria correttamente")
    }
    
    func loadOrarioFromFetchRequest(request: NSFetchRequest<OrarioD>) -> [OrarioD] {
        
        var array = [OrarioD]()
        
        do {
            
            array = try self.context.fetch(request)
            
            guard array.count > 0 else {print("[CDC] Non ci sono elementi da leggere "); return []}
            
        } catch let error {
            
            print("[CDC] Problema esecuzione FetchRequest")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
        
        return array
        
    }
    
    func caricaTuttiGliOrari() -> [OrarioD]{
        
        print("[CDC] Recupero tutti orari")
        
        let request: NSFetchRequest<OrarioD> = NSFetchRequest(entityName: "OrarioD")
        
        request.returnsObjectsAsFaults = false
        
        var array = [OrarioD]()
        
        do {
            
            array = try self.context.fetch(request)
            
            guard array.count > 0 else {print("[CDC] Non ci sono elementi da leggere "); return []}
            
        } catch let error {
            
            print("[CDC] Problema esecuzione FetchRequest")
            
            print("  Stampo l'errore: \n \(error) \n")
            
        }
        
        print(array)
        //let impegni = self.loadValutazFromFetchRequest(request: request)
        
        return array
        
    }
    
    func OrarPerGiorno(gio: String) -> [OrarioD] {
        
        print("[CDC] Recupero tutti gli impegni dal context ")
        
        let request: NSFetchRequest<OrarioD> = NSFetchRequest(entityName: "OrarioD")
        
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "giorno = %@", gio)
        
        request.predicate = predicate
        
        let regt = self.loadOrarioFromFetchRequest(request: request)
        
        print(regt)
        
        return regt
        
    }
    
    func cancellaOrar(id: String) {
        
        let request: NSFetchRequest<OrarioD> = NSFetchRequest(entityName: "OrarioD")
        
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "id = %@", id)
        
        request.predicate = predicate
        
        let regt = self.loadOrarioFromFetchRequest(request: request)
        
        for vg in regt{
            self.context.delete(vg)
        }
        
        do {
            
            try self.context.save()
            
        } catch let errore {
            
            print("[CDC] Problema eliminazione  ")
            
            print("  Stampo l'errore: \n \(errore) \n")
            
        }
        
    }
    
    func cancellaOrarTut() {
        
        let vals = self.caricaTuttiGliOrari()
        
        for vg in vals{
            self.context.delete(vg)
        }
        
        do {
            
            try self.context.save()
            
        } catch let errore {
            
            print("[CDC] Problema eliminazione  ")
            
            print("  Stampo l'errore: \n \(errore) \n")
            
        }
        
    }
    
    func OrariPerId(Id: String) -> OrarioD {
        
        print("[CDC] Recupero tutti orari per id dal context ")
        
        let request: NSFetchRequest<OrarioD> = NSFetchRequest(entityName: "OrarioD")
        
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "id = %@", Id)
        
        request.predicate = predicate
        
        let impegni = self.loadOrarioFromFetchRequest(request: request)
        
        return impegni[0]
        
    }
    
    
}
