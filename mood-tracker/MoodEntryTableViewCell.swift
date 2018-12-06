//
//  MoodEntryTableViewCell.swift
//  mood-tracker
//
//  Created by Lucia Reynoso on 11/8/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import UIKit

class MoodEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var labelMoodTitle: UILabel!
    @IBOutlet weak var labelMoodDate: UILabel!
    @IBOutlet weak var imageViewMoodColor: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ entry: MoodEntry) {
        imageViewMoodColor.backgroundColor = entry.mood.colorValue
        labelMoodTitle.text = entry.mood.stringValue
        labelMoodDate.text = entry.date.stringValue
    }

}
