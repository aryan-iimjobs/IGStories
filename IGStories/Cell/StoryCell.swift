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
    func didTapCloseButton(from storyIndex: Int)
}

class StoryCell: UICollectionViewCell {
    
    weak var delegate: StoryPreviewProtocol?
    
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 25
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.frame = CGRect(x: 20, y: 25, width: 50, height: 50)
        return iv
    }()

    let label: UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.textColor = .white
        l.font = UIFont(name: "HelveticaNeue",size: 16.0)
        return l
    }()
    
    let cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    let pauseIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "pause.circle.fill")
        iv.tintColor = .white
        iv.isHidden = true
        return iv
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
        
        pauseIv.frame = CGRect(x: frame.width/2 - 15, y: 50, width: 30, height: 30)
        contentView.addSubview(pauseIv)
        
        cancelBtn.frame = CGRect(x: frame.width - 50, y: 30, width: 25, height: 25)
        contentView.addSubview(cancelBtn)
        cancelBtn.addTarget(self,
        action: #selector(cancelBtnAction),
        for: .touchUpInside)
        
        label.frame = CGRect(x: 75, y: 20, width: frame.width - 75, height: 50 )
        contentView.addSubview(label)
        
        snapImage.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        contentView.addSubview(snapImage)
        contentView.sendSubviewToBack(snapImage)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        self.addGestureRecognizer(recognizer)
    }
    
    @objc func cancelBtnAction() {
        delegate?.didTapCloseButton(from: self.parentStoryIndex)
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
            self.pauseIv.isHidden = true
        } else if absoluteTouch > screenWidthOneThird && absoluteTouch < screenWidthTwoThird {
            if self.pauseIv.isHidden {
                self.pauseIv.isHidden = false
                progressBar.pause()
            } else {
                self.pauseIv.isHidden = true
                progressBar.resume()
            }
        } else {
            progressBar.skip()
            self.pauseIv.isHidden = true
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


