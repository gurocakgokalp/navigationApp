//
//  MainViewController.swift
//  MapsUsage
//
//  Created by Gökalp Gürocak on 1.10.2025.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var nameLocs = [String]()
    var idLocs = [UUID]()
    
    var secilenName: String = ""
    var choisedID = UUID()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getDatas()

        navigationController?.navigationBar.topItem?.title = "Navigation App"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addBtn))
        
        // Do any additional setup after loading the view.
    }
    
    @objc func addBtn (){
        secilenName = ""
        segue()
    }
    
    func segue (){
        //secilenName = ""
        performSegue(withIdentifier: "details", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = nameLocs[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameLocs.count
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getDatas), name: NSNotification.Name("posted"), object: nil)
        print("Getted")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tiklandi
        print(nameLocs[indexPath.row])
        secilenName = nameLocs[indexPath.row]
        choisedID = idLocs[indexPath.row]
        
        performSegue(withIdentifier: "details", sender: nil)
    }
    
    @objc func getDatas(){
        
        nameLocs.removeAll(keepingCapacity: false)
        idLocs.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do {
            let sonuclar = try context.fetch(fetchRequest)
            if sonuclar.count > 0 {
                for sonuc in sonuclar as! [NSManagedObject]{
                    if let name = sonuc.value(forKey: "name") as? String{
                        nameLocs.append(name)
                    }
                    if let id = sonuc.value(forKey: "id") as? UUID{
                        idLocs.append(id)
                    }
                    tableView.reloadData()
                }
            }
        }catch{
            print("something went wrong when getting datas")
        }
        
        
    }
    
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sureDialog = UIAlertController(title: "Are you sure?", message:" \(nameLocs[indexPath.row]) will be deleting...", preferredStyle: UIAlertController.Style.alert)
            
            let okBtn = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { UIAlertAction in
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
                do{
                    let sonuclar = try context.fetch(fetchRequest)
                    for sonuc in sonuclar as! [NSManagedObject] {
                        context.delete(sonuc)
                        self.nameLocs.remove(at: indexPath.row)
                        self.idLocs.remove(at: indexPath.row)
                        
                        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
                        
                        do {
                            try context.save()
                        }catch{
                            
                        }
                        tableView.reloadData()
                        
                        // bu break atmazsan index out of range verecek. bir şey döngüyü durdurmalı. o da break
                        break
                        
                    }
                }catch{
                    
                }
                
            }
            
            let cancelBtn = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in
                //
            }
            sureDialog.addAction(okBtn)
            sureDialog.addAction(cancelBtn)
            
            present(sureDialog, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details"{
            let destVC = segue.destination as! ViewController
            
            print(secilenName)
            destVC.gelenName = secilenName
            destVC.gelenUUID = choisedID
        }
    }
    
}

