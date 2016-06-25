//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Ilya Dolgopolov on 24.06.16.
//  Copyright © 2016 Ilya Dolgopolov. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {
    
    private struct Storyboard {
        static let ShowImageSegue = "Show Image"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.ShowImageSegue {
            if let ivc = segue.destinationViewController.contentViewConroller as? ImageViewController {
                let imageName = (sender as? UIButton)?.currentTitle
                ivc.imageURL = DemoURL.NASAImageNamed(imageName)
                ivc.title = imageName
            }
        }
    }
    
    //вместо создания каждый раз нового view, используем один, вызывая этот метод,
    //приэтом в storyboard протягивае segue от одной формы к другой, выбириаем Show
    @IBAction func showImage(sender: UIButton) {
        if let ivc = splitViewController?.viewControllers.last?.contentViewConroller as? ImageViewController {
            let imageName = sender.currentTitle
            ivc.imageURL = DemoURL.NASAImageNamed(imageName)
            ivc.title = imageName
        } else {
            performSegueWithIdentifier(Storyboard.ShowImageSegue, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //делегат, чтобы в начале запуска приложения показывался master, если данные не загружены
        splitViewController?.delegate = self
    }
    
    /*реализация метода протокола UISplitViewControllerDelegate:
     даем системе знать важно ли нам, что содержиться в detailed части splitView
     если важно, возвращаем true
     В нашем случае проверяем есть ли данные в detailed, если их нет, будет показан Master
     */
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        //проверям действительно ли мастер это наш контроллер
        if primaryViewController.contentViewConroller == self {
            //извелкаем detailed контроллер, как наш контроллер, и дополнительно проверям, что данные (URL) пусты
            if let ivc = secondaryViewController.contentViewConroller as? ImageViewController where ivc.imageURL == nil {
                return true
            }
        }
        return false
    }
    
}

//расшерение для контроллера в случае комбинации UINavigationController 
// и splitViewController
extension UIViewController {
    var contentViewConroller: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else{
            return self
        }
    }
}
