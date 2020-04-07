//
//  ViewController.swift
//  TableView&ImageList
//
//  Created by abdullah on 14/08/1441 AH.
//  Copyright © 1441 abdullah. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
  
  //MARK:- IB outlets
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var buttonMenu: UIButton!
  @IBOutlet var titleLabel: UILabel!
    
  @IBOutlet var menuHeightConstraint: NSLayoutConstraint!
  @IBOutlet var menuButtonTrailing: NSLayoutConstraint!
  @IBOutlet var titleCenterY: NSLayoutConstraint!
  @IBOutlet var titleCentery_Open: NSLayoutConstraint!
  
  //MARK:- further class variables
  
  var slider: HorizontalItemList!
  var menuIsOpen = false
  var items: [Int] = [7]
  
  //MARK:- class methods
  
  @IBAction func toggleMenu(_ sender: AnyObject) {
    menuIsOpen = !menuIsOpen
    
    titleLabel.text = menuIsOpen ? "اختيار منتج" : "قائمة المتجات"
    view.layoutIfNeeded()
    
    titleCenterY.isActive = !menuIsOpen
    titleCentery_Open.isActive = menuIsOpen
    
    titleLabel.superview?.constraints.forEach { constraint in
        if constraint.firstItem === titleLabel &&
            constraint.firstAttribute == .centerX {
            constraint.constant = menuIsOpen ? -100.0 : 0.0
            return
        }
    }
    
    menuHeightConstraint.constant = menuIsOpen ? 200 : 80
    menuButtonTrailing.constant = menuIsOpen ? 16 : 8
    
    UIView.animate(
        withDuration: 1.0,
        delay: 0.0,
        usingSpringWithDamping: 0.4,
        initialSpringVelocity: 10,
        options: .allowUserInteraction,
        animations: {
            let angle: CGFloat = self.menuIsOpen ? .pi / 4 : 0.0
            self.buttonMenu.transform = CGAffineTransform(rotationAngle: angle)
            self.view.layoutIfNeeded()
    },
        completion: nil
    )
    }
    
    func showItem(_ index: Int) {
        let imageView = makeImageView(index: index)
        let containerView = UIView(frame: imageView.frame)
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let conX = containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let conBottom = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: containerView.frame.height)
        let conWidth = containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33, constant: -50.0)
        let conHeight = containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        
        let imageY = imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        let imageX = imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        let imageWidth = imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        let imageHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        
        NSLayoutConstraint.activate([conX, conBottom, conWidth, conHeight, imageY, imageX, imageWidth, imageHeight])
        view.layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.8,
            delay: 0.0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 10,
            options: [],
            animations: {
                conBottom.constant = -imageView.frame.height * 2
                conWidth.constant = 0.0
                self.view.layoutIfNeeded()
        },
            completion: nil
        )
        
        delay(seconds: 1.0) {
            UIView.transition(
                with: containerView,
                duration: 1.0,
                options: .transitionFlipFromBottom,
                animations: {
                    imageView.removeFromSuperview()
            },
                completion: { _ in
                    containerView.removeFromSuperview()
            }
            )
        }
        
        //    UIView.animate(
        //      withDuration: 0.67,
        //      delay: 2.0,
        //      animations: {
        //        conBottom.constant = imageView.frame.size.height
        //        conWidth.constant = -50.0
        //        self.view.layoutIfNeeded()
        //      }
        //    ) { _ in
        //      imageView.removeFromSuperview()
        //    }
    }
    
    func transitionCloseMenu() {
        delay(seconds: 0.35, completion: {
            self.toggleMenu(self)
        })
        
        let littleBar = slider.superview!
        UIView.transition(
            with: littleBar,
            duration: 0.5,
            options: .transitionFlipFromBottom,
            animations: {
                self.slider.isHidden = true
            }) { _ in
            self.slider.isHidden = false
        }
    }
}


var itemTitles = ["ايسكريم", "اشعة الشمس", "العاب الشاطي", "سروال سباحة", "ملابس سباحة", "العاب الرمل", "لوح مائي", "مشروب بارد", "رحله عائلية", "سيارة"]

//  View Controller

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func makeImageView(index: Int) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "summericons_100px_0\(index).png"))
        imageView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    
    
    func makeSlider() {
        slider = HorizontalItemList(inView: view)
        slider.didSelectItem = {index in
            self.items.append(index)
            self.tableView.reloadData()
            self.transitionCloseMenu()
        }
        self.titleLabel.superview?.addSubview(slider)
    }
    
    // MARK: View Controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSlider()
        self.tableView?.rowHeight = 54.0
    }
    
    // MARK: Table View methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.accessoryType = .none
        cell.textLabel?.text = itemTitles[items[indexPath.row]]
        cell.imageView?.image = UIImage(named: "summericons_100px_0\(items[indexPath.row]).png")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItem(items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
                    _ = items.remove(at: indexPath.row)
                     //  delete(toRemove)
                    // Delete the row from the data source
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    
    
        }
    }
}
