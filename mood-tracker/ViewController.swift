//
//  ViewController.swift
//  mood-tracker
//
//  Created by Lucia Reynoso on 11/8/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var moodsTable: UITableView!
    
    struct MoodEntry {
        var mood: Mood
        var date: Date
        
        enum Mood: Int {
            case none
            case amazing
            case good
            case neutral
            case bad
            case terrible
            
            var stringValue: String {
                switch self {
                case .none:
                    return ""
                case .amazing:
                    return "Amazing"
                case .good:
                    return "Good"
                case .neutral:
                    return "Neutral"
                case .bad:
                    return "Bad"
                case .terrible:
                    return "Terrible"
                }
            }
            
            var colorValue: UIColor {
                switch self {
                case .none:
                    return .clear
                case .amazing:
                    return .green
                case .good:
                    return .blue
                case .neutral:
                    return .gray
                case .bad:
                    return .orange
                case .terrible:
                    return .red
                }
            }
        }
    }
    
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


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moodEntryCell", for: indexPath)
        
        let entry = entries[indexPath.row]
        cell.textLabel?.text = entry.mood.stringValue
        cell.detailTextLabel?.text = String(describing: entry.date)
        
        return cell
    }
    
    
    
}
