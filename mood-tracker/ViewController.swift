//
//  ViewController.swift
//  mood-tracker
//
//  Created by Lucia Reynoso on 11/8/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {
    
    @IBOutlet weak var moodsTable: UITableView!
    
    var entries: [MoodEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        moodsTable.dataSource = self
        moodsTable.delegate = self
        
        let goodEntry = MoodEntry(mood: .good, date: Date())
        let badEntry = MoodEntry(mood: .bad, date: Date())
        let neutralEntry = MoodEntry(mood: .neutral, date: Date())
        
        entries = [goodEntry, badEntry, neutralEntry]
        moodsTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = moodsTable.indexPathForSelectedRow {
            moodsTable.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    @IBAction func pressCalendar(_ sender: UIBarButtonItem) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let calendarVC = mainStoryboard.instantiateViewController(withIdentifier: "calendarVC") as? CalendarViewController else {
            return print("storyboard not set up correctly, check the identity of \"calendarVC\"")
        }
        present(calendarVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "showEntryDetails":
            guard let selectedCell = sender as? UITableViewCell, let indexPath = moodsTable.indexPath(for: selectedCell) else {
                return print("failed to locate index path from sender")
            }
            guard let entryDetailsViewController = segue.destination as? MoodDetailedViewController else {
                return print("storyboard not setup correctly")
            }
            let entry = entries[indexPath.row]
            entryDetailsViewController.mood = entry.mood
            entryDetailsViewController.date = entry.date
        case "showNewEntry":
            guard let entryDetailsViewController = segue.destination as? MoodDetailedViewController else {
                return print("storyboard not setup correctly")
            }
            entryDetailsViewController.mood = MoodEntry.Mood.none
            entryDetailsViewController.date = Date()
        default:
            break
        }
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        guard let identifier = segue.identifier else {
            return
        }
        
        guard let detailedEntryViewController = segue.source as? MoodDetailedViewController else {
            return print("storyboard unwind segue not set up correctly")
        }
        
        switch identifier {
        case "unwindFromSave":
            let newMood: MoodEntry.Mood = detailedEntryViewController.mood
            let newDate: Date = detailedEntryViewController.date
            if detailedEntryViewController.isEditingEntry {
                if detailedEntryViewController.isEditingEntry {
                    guard let selectedIndexPath = moodsTable.indexPathForSelectedRow else {
                        return
                    }
                    updateEntry(mood: newMood, date: newDate, at: selectedIndexPath.row)
                } else {
                    createEntry(mood: newMood, date: newDate)
                }
            } else {
                print("from save button and adding a new entry")
            }
        case "unwindFromCancel":
            print("from cancel button")
        default:
            break
        }
    }
    
    func createEntry(mood: MoodEntry.Mood, date: Date) {
        let newEntry = MoodEntry(mood: mood, date: date)
        entries.insert(newEntry, at: 0)
        moodsTable.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func updateEntry(mood: MoodEntry.Mood, date: Date, at index: Int) {
        entries[index].mood = mood
        entries[index].date = date
        moodsTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func deleteEntry(at index: Int) {
        entries.remove(at: index)
        moodsTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    //Watch connectivity
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error != nil {
            print("Error: \(String(describing: error))")
        }else{
            print("Ready to communicate with apple watch.")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Deactivated")
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            print("This is the user info \(userInfo)")
            
            guard let mood = userInfo["mood"] as? String, let date =  userInfo["date"] as? Date else{ return}
            let newEntry : MoodEntry!
            
            switch mood {
            case "Amazing":
                newEntry = MoodEntry(mood: .amazing, date: date)
            case "Good":
                newEntry = MoodEntry(mood: .good, date: date)
            case "Bad":
                newEntry = MoodEntry(mood: .bad, date: date)
            case "Terrible":
                newEntry = MoodEntry(mood: .terrible, date: date)
            case "Neutral":
                newEntry = MoodEntry(mood: .neutral, date: date)
            default:
                return
            }
            
            self.entries.append(newEntry)
            self.moodsTable.reloadData()
        }
        
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moodEntryCell", for: indexPath) as? MoodEntryTableViewCell
        guard let moodCell = cell else {
            return MoodEntryTableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        let entry = entries[indexPath.row]
        moodCell.configure(entry)
        return moodCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntry = entries[indexPath.row]
        print ("Selected mood was \(selectedEntry.mood.stringValue)")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteEntry(at: indexPath.row)
        default:
            break
        }
    }
}
