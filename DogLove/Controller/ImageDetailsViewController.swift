//
//  ImageDetailsViewController.swift
//  DogLove
//
//  Created by Agnidhra Gangopadhyay on 3/1/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    @IBOutlet weak var imageDetails: UIImageView?
    var image: UIImage?
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(self.preferredInterfaceOrientationForPresentation.rawValue, forKey: "orientation")
        if let image = self.image {
            imageDetails!.image = image
            imageDetails?.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        centerImage()
        imageDetails?.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParent) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        centerImage()
        
    }
    
    @objc func canRotate() -> Void {}
    
    @IBAction func doubleTapImage(_ sender: UITapGestureRecognizer) {
        if imageScrollView.zoomScale == imageScrollView.minimumZoomScale {
            imageScrollView.zoom(to: zoomRectangle(scale: imageScrollView.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
        } else {
            imageScrollView.setZoomScale(imageScrollView.minimumZoomScale, animated: true)
        }
    }
    
}

extension ImageDetailsViewController {
    private func setMinZoomScaleForImageSize(_ imageSize: CGSize) {
        let widthScale = view.frame.width / imageSize.width
        let heightScale = view.frame.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        // Scale the image down to fit in the view
        imageScrollView.minimumZoomScale = minScale
        imageScrollView.zoomScale = minScale
        
        // Set the image frame size after scaling down
        let imageWidth = imageSize.width * minScale
        let imageHeight = imageSize.height * minScale
        let newImageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        imageDetails!.frame = newImageFrame
        
        centerImage()
        
    }
    
    public func centerImage() {
        let imageViewSize = imageDetails!.frame.size
        let scrollViewSize = view.frame.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        imageScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let zoomImage = image {
            setMinZoomScaleForImageSize(image!.size)
        }
    }
    
    private func zoomRectangle(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageDetails!.frame.size.height / scale
        zoomRect.size.width  = imageDetails!.frame.size.width  / scale
        zoomRect.origin.x = center.x - (center.x * imageScrollView.zoomScale)
        zoomRect.origin.y = center.y - (center.y * imageScrollView.zoomScale)
        
        return zoomRect
    }
}

extension ImageDetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageDetails
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
