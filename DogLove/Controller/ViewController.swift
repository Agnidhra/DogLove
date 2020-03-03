//
//  ViewController.swift
//  DogLove
//
//  Created by Agnidhra Gangopadhyay on 2/27/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var breeds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        self.showSpinner(onView: self.view)
        if(breeds.count<1){
                DogApi.requestAllBreeds(completionHandler: handleBreedsListResponse(breeds:error:))
        }
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func handleBreedsListResponse(breeds: [String]?, error: Error?){
        self.breeds = breeds!
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
        //self.title = self.breeds[0].capitalized
        DogApi.requestRandomImage(breed: self.breeds[0], completionHandler: handleRandomImageResponse(imageData:error:))
    }
    
    func handleRandomImageResponse(imageData: DogImage?, error: Error?) {
        guard let imageURL = URL(string: imageData?.message ?? "") else {
             return
        }
        DogApi.requestImageFile(url: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
        
    }
    
    
    
    func handleImageFileResponse(image: UIImage?, error: Error?){
        DispatchQueue.main.async {
            self.removeSpinner()
            self.imageView.image = image
           
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.showSpinner(onView: self.view)
        self.title = self.breeds[row].capitalized
        DogApi.requestRandomImage(breed: breeds[row], completionHandler: handleRandomImageResponse(imageData:error:))
        
    }
    
    @objc func imageTapped(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageDetailsViewController") as! ImageDetailsViewController
        vc.image = self.imageView.image
        self.navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true, completion: nil)
    }
    
}
var vSpinner : UIView?
extension UIViewController {
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    
    
}

