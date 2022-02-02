//
//  DetailVieViewController.swift
//  Project1
//
//  Created by BERAT ALTUNTAŞ on 25.01.2022.
//

import UIKit

class DetailVieViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedImgIndex:String?
    var imageCount:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(selectedImgIndex!) / \(imageCount!)"
        navigationItem.largeTitleDisplayMode = .never
        if let imageToLoad=selectedImage{
            imageView.image=UIImage(named: imageToLoad)
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap=true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap=false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}