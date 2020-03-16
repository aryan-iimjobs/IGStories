//
//  StoryViewController.swift
//  IGStories
//
//  Created by iim jobs on 14/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

class StoryViewController: UIViewController {

    var firstLaunch = true
    var selectedStoryIndex = 0
    var arrayStories: [StoryIconModel] = []
    var currentStoryIndex: Int?
    
    //retreive value in viewWillLayoutSubViews
    var topSafeAreaMargin: CGFloat?
    
    //touch point for swipeDown to dismiss animation
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    let mainView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .black
        return uiView
    }()
    
    private var story_copy: StoryPreviewModel?
    
    let collectionView: UICollectionView = {
        let layout = AnimatedCollectionViewLayout()
        layout.animator = CubeAttributesAnimator(perspective: -1/500, totalAngle: .pi/2)
        layout.scrollDirection = .horizontal;
        let cv = UICollectionView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height:  UIScreen.main.bounds.height), collectionViewLayout: layout);
        cv.register(StoryCell.self, forCellWithReuseIdentifier: "cell")
        cv.translatesAutoresizingMaskIntoConstraints = false;
        cv.showsHorizontalScrollIndicator = true
        cv.isPagingEnabled = true
        return cv;
    }();
    
    init(arrayStories: [StoryIconModel], selectedStoryIndex: Int ) {
        self.selectedStoryIndex = selectedStoryIndex
        self.arrayStories = arrayStories
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        collectionView.rightAnchor.constraint(equalTo:  view.rightAnchor).isActive = true;
        collectionView.topAnchor.constraint(equalTo:  view.topAnchor, constant: 0).isActive = true;
        collectionView.bottomAnchor.constraint(equalTo:  view.bottomAnchor).isActive = true;
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        collectionView.layer.cornerRadius = 10
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.swipeDown(_:)))
        view.addGestureRecognizer(recognizer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.topSafeAreaMargin = view.safeAreaInsets.top
    }
    
    @objc func swipeDown(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)

        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.collectionView.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y + 0, width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.height)
                self.view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha:1 - (touchPoint.y - initialTouchPoint.y) / 200)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 200 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.backgroundColor = .black
                    self.collectionView.frame = CGRect(x: 0, y: 0, width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.height)
                })
            }
        }
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let indexPath = IndexPath(item: self.selectedStoryIndex, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        if let firstVC = presentingViewController as? ViewController {
            firstVC.isDarkStatusBar.toggle()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let cell = collectionView.visibleCells[0] as! StoryCell
        cell.progressBar.resetBar()
    }
}

//MARK:- CollectionView DataSource
extension StoryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayStories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoryCell
        
        cell.parentStoryIndex = indexPath.item
        cell.story = arrayStories[indexPath.item].story
        cell.initProgressbar()
        
        cell.icon.image = UIImage(named: arrayStories[indexPath.item].image)
        cell.label.text = arrayStories[indexPath.item].title
        cell.snapImage.image = UIImage(named: arrayStories[indexPath.item].story.snaps[0])
        
        cell.delegate = self
        
        if firstLaunch && selectedStoryIndex == indexPath.row {
            print("StoryVC: first launch")
            cell.progressBar.animate(index: 0)
            firstLaunch = false
            self.currentStoryIndex = selectedStoryIndex
        }
        
        return cell
    }
}

//MARK:- CollectionView FlowLayout Delegate
extension StoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.safeAreaLayoutGuide.layoutFrame.width, height: collectionView.safeAreaLayoutGuide.layoutFrame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
//MARK:- Handle progressView when scrolling over stories
    //not called when programmatically scrolling, like on tap/auto
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var cell: StoryCell
        let visibleCells = collectionView.visibleCells
        
        if visibleCells.count > 1 {
            cell = collectionView.cellForItem(at: scrollToMostVisibleCell()) as! StoryCell
        } else {
            cell = visibleCells.first as! StoryCell
        }
        
        print("StoryVC: endedDecel on \(cell.parentStoryIndex!) .. countvisible \(visibleCells.count)")
        if cell.parentStoryIndex != currentStoryIndex {
            cell.progressBar.animate(index: 0)
            currentStoryIndex = cell.parentStoryIndex
        } else {
            print("..but same cell")
        }
    }
    
//MARK:- Handle progressView when auto/tap scroll over stories
    //not called when scrolling over cells(stories)
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        var cell: StoryCell
        let visibleCells = collectionView.visibleCells
        
        if visibleCells.count > 1 {
            cell = collectionView.cellForItem(at: scrollToMostVisibleCell()) as! StoryCell
        } else {
            cell = visibleCells.first as! StoryCell
        }
        
        print("StoryVC: endedScrollAnim on \(cell.parentStoryIndex!) .. countvisible \(visibleCells.count) .. currentIndex \(currentStoryIndex!)")
        if cell.parentStoryIndex != currentStoryIndex {
            cell.progressBar.animate(index: 0)
            currentStoryIndex = cell.parentStoryIndex
        } else {
            print("..but same cell")
        }
    }
    
    func scrollToMostVisibleCell() -> IndexPath{
      let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        print("StoryVC: mostVisibleCell is\(visibleIndexPath.item)")
        return visibleIndexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("StoryVC: endedDisplay of \(indexPath.item)")
        let oldCell = cell as! StoryCell
        oldCell.progressBar.resetBar()
    }
}

//MARK:- StoryCell delegates
extension StoryViewController: StoryPreviewProtocol {
    func moveToNextStory(from storyIndex: Int) {
        if storyIndex < arrayStories.count - 1 {
            print("StoryVC: next Story")
            let indexPath = IndexPath(item: storyIndex + 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        } else {
            print("StoryVC: exit from right")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func moveToPreviousStory(from storyIndex: Int) {
        if storyIndex >= 1 {
            print("StoryVC: previous Story")
            let indexPath = IndexPath(item: storyIndex - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        } else {
            print("StoryVC: exit from left")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
