//
//  StoryPreviewModel.swift
//  IGStories
//
//  Created by iim jobs on 13/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class StoryPreviewModel: NSObject {
    var snaps: [String]
    var arraySeen: [Int] = [1,1]
    var isCompletelyVisible = false
    
    init(snaps: [String]) {
        self.snaps = snaps
    }
}
