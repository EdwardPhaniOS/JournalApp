//
//  ComposerViewController.swift
//  JournalApp
//
//  Created by Tan Vinh Phan on 1/2/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit
import CoreData

class ComposerViewController: UIViewController
{
    var entry: Entry!
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        if entry == nil {
            title = "Compose a new entry"
            textView.text = ""
        } else {
            title = "Update current entry"
            textView.text = entry.bodyText
        }
    }
    
    @IBAction func doneButtonDidTap(_ sender: Any)
    {
        if entry == nil {
            if textView.text != "" {
                createNewEntry()
            }
        } else {
            updateEntry()
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    func updateEntry() -> Void {
        self.entry.bodyText = textView.text
        self.entry.createdAt = Date()
        
        saveEntry()
    }
    
    func createNewEntry() -> Void {
        let newEntry = Entry(context: managedObjectContext)
        newEntry.bodyText = textView.text
        newEntry.createdAt = Date()
        
        saveEntry()
    }
    
    func saveEntry() -> Void {
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save the new Entry: \(error.localizedDescription)")
        }
    }
    
}
