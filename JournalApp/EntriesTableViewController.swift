//
//  EntriesTableViewController.swift
//  JournalApp
//
//  Created by Tan Vinh Phan on 1/2/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var entries = [Entry]()
    
    @IBAction func composeDidTap(_ sender: Any)
    {
        self.performSegue(withIdentifier: "ComposeSegue", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Journal"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchEntries()
    }
    
    func fetchEntries() -> Void {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        
        do {
            self.entries = try self.managedObjectContext.fetch(fetchRequest) as! [Entry]
        } catch let error {
            print("Could not fetch entries: \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath)
        let entry = entries[indexPath.row]
        
        cell.textLabel?.text = entry.bodyText
        cell.detailTextLabel?.text = dateTimeFormattedAsTimeAgo(entry.createdAt!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = entries[indexPath.row]
        self.performSegue(withIdentifier: "ComposeSegue", sender: entry)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ComposeSegue" {
            let composeVC = segue.destination as? ComposerViewController
            composeVC?.entry = sender as? Entry
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entries[indexPath.row]
            self.managedObjectContext.delete(entry)
            entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save the new entry: \(error.localizedDescription)")
        }
    }
    
}





