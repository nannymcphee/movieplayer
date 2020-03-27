//
//  VideoListTableViewCell.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 3/27/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//

import UIKit

class VideoListTableViewCell: UITableViewCell {
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    
    static let cellID = "VideoListTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ivThumbnail.image = nil
        lbTitle.text = ""
        lbSubTitle.text = ""
    }
    
    func populateData(with video: Video) {
        ivThumbnail.image = video.thumbImage
        lbTitle.text = video.title
        lbSubTitle.text = video.subtitle
    }
}
