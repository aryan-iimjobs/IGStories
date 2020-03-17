//
//  ViewController.swift
//  IGStories
//
//  Created by iim jobs on 13/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let TEST_DATA_COUNT = 5
    let COLLECTION_VIEW_HEIGHT = CGFloat(90)

    var arrayDemoIcons = ["logo0", "logo1", "logo2", "logo3", "logo4"]
    var arrayDemoSnaps = [["image0", "image1"], ["image2", "image3"], ["image4","image0"], ["image1", "image2"], ["image3","image4"]]
    
    var isDarkStatusBar = true {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
            
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .horizontal;
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout);
        cv.register(StoryIconCell.self, forCellWithReuseIdentifier: "cell")
        cv.translatesAutoresizingMaskIntoConstraints = false;
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        return cv;
    }();
    
    var arrayStories: [StoryIconModel] = []
    
    //if views are light-dark then dark-light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isDarkStatusBar ? .darkContent : .lightContent
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        collectionView.rightAnchor.constraint(equalTo:  view.rightAnchor).isActive = true;
        collectionView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor).isActive = true;
        collectionView.heightAnchor.constraint(equalToConstant: COLLECTION_VIEW_HEIGHT).isActive = true;
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true;
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //create demo data
        for i in 0...TEST_DATA_COUNT - 1 {
            arrayStories.append(StoryIconModel(title: "User \(i + 1)", image: arrayDemoIcons[i], story: StoryPreviewModel(snaps: arrayDemoSnaps[i])))
        }
    }
    
    
}

//MARK:- CollectionView DataSource
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayStories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoryIconCell
        
        cell.icon.layer.borderColor = UIColor.blue.cgColor
        cell.icon.layer.borderWidth = 1
        cell.icon.image = UIImage(named: arrayStories[indexPath.item].image)!.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        cell.label.text = arrayStories[indexPath.item].title
        
        return cell
    }
}

//MARK:- CollectionView Delegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = StoryViewController(arrayStories: arrayStories, selectedStoryIndex: indexPath.item)
        vc.modalPresentationStyle = .overFullScreen
        //vc.modalTransitionStyle = .crossDissolve
        self.isDarkStatusBar.toggle()
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK:- CollectionView FlowLayout Delegate
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height * 0.8, height: collectionView.frame.height)
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: 8.0)
    }
}

//MARK:- UIImage extension to add margins to the image
extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}
