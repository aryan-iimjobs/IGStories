//
//  StoryIconModel.swift
//  IGStories
//
//  Created by iim jobs on 13/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class StoryIconModel: NSObject {
    var title: String
    var image: String
    var story: StoryPreviewModel
    var allseen: Bool = false
    
    init(title: String, image: String,story: StoryPreviewModel) {
        self.title = title
        self.image = image
        self.story = story
    }
}
