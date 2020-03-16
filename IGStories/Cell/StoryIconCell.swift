//
//  StoryIconCell.swift
//  IGStories
//
//  Created by iim jobs on 13/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class StoryIconCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        return iv
    }()
    
    let label: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        icon.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        icon.layer.cornerRadius = frame.width / 2
        addSubview(icon)
        
        label.frame = CGRect(x: 0, y: frame.width, width: frame.width, height: frame.height - frame.width)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


