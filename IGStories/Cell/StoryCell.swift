//
//  StoryCell.swift
//  IGStories
//
//  Created by iim jobs on 14/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

protocol StoryPreviewProtocol: class {
    func moveToNextStory(from storyIndex: Int)
    func moveToPreviousStory(from storyIndex: Int)
}

class StoryCell: UICollectionViewCell {
    
    weak var delegate: StoryPreviewProtocol?
    
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 30
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.frame = CGRect(x: 20, y: 30, width: 60, height: 60)
        return iv
    }()

    let label: UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.textColor = .white
        return l
    }()

    let snapImage: UIImageView = {
        let iv = UIImageView()
        return iv
    }()

    var progressBar: MyProgressView!
    var story: StoryPreviewModel!
    var parentStoryIndex: Int!
    
    var progressBarPresent = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(icon)
        //addSubview(icon)
        
        label.frame = CGRect(x: 90, y: 25, width: frame.width - 90, height: 60)
        contentView.addSubview(label)
        
        snapImage.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        contentView.addSubview(snapImage)
        contentView.sendSubviewToBack(snapImage)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        self.addGestureRecognizer(recognizer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initProgressbar() {
        if !progressBarPresent {
            progressBar = MyProgressView(arrayStories: story.snaps.count)
            progressBar.delegate = self
            progressBar.frame = CGRect(x: 0, y: 5, width: frame.width, height: 20)
            contentView.addSubview(progressBar)
            progressBarPresent = true
        }
    }
    
    @objc func touch(_ sender: UITapGestureRecognizer) {
        //print("StoryPreviewCell: Touch")
        let touch = sender.location(in: self)
        let screenWidthOneThird = self.frame.width / 3
        let screenWidthTwoThird = screenWidthOneThird * 2
        let absoluteTouch = touch.x

        if absoluteTouch < screenWidthOneThird {
            progressBar.rewind()

        } else if absoluteTouch > screenWidthOneThird && absoluteTouch < screenWidthTwoThird {
            progressBar.pause()
        } else {
            progressBar.skip()
        }
    }
}

extension StoryCell: SegmentedProgressBarDelegate {
    func segmentedProgressBarChangedIndex(index: Int) {
        snapImage.image = UIImage(named: story.snaps[index] )
    }
    
    func segmentedProgressBarsFinished(left: Bool) {
        if left {
            delegate?.moveToPreviousStory(from: parentStoryIndex)
        } else {
            delegate?.moveToNextStory(from: parentStoryIndex)
        }
    }
}


