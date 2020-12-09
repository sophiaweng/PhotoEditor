//
//  PhotoViewController.swift
//  PhotoEditor
//
//  Created by 翁淑惠 on 2020/12/7.
//

import UIKit

class PhotoViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set default photo ratio 1:1
        containerView.bounds.size = CGSize(width: 350, height: 350)
    }
    
    @IBAction func pickPhoto(_ sender: Any) {
        //choose source from
        let sourceAlertController = UIAlertController(title: "選擇照片來源", message: "", preferredStyle: .actionSheet)
        let imagePickerController = UIImagePickerController()
        let albumAction = UIAlertAction(title: "從相簿選", style: .default) { (UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "拍照", style: .default) { (UIAlertAction) in
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        sourceAlertController.addAction(albumAction)
        sourceAlertController.addAction(cameraAction)
        sourceAlertController.addAction(cancelAction)
        present(sourceAlertController, animated: true, completion: nil)
    }
    
    @IBAction func sharePhoto(_ sender: Any) {
        //render photo
        let imageRenderer = UIGraphicsImageRenderer(size: containerView.bounds.size)
        let imageRendererImage = imageRenderer.image { (UIGraphicsImageRendererContext) in
            containerView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: true)
        }
        //
        let shareActivityViewController = UIActivityViewController(activityItems: [imageRendererImage], applicationActivities: nil)
        present(shareActivityViewController, animated: true, completion: nil)
    }
    
    @IBAction func resizePhoto(_ sender: UISegmentedControl) {
        //set default photo ratio 1:1
        let length: Int = 350
        var width: Int
        var height: Int
        switch sender.selectedSegmentIndex {
        case 0: //1:1
            width = length
            height = length
        case 1: //16:9
            width = length
            height = Int(Double(length) / 16 * 9)
        case 2: //10:8
            width = length
            height = Int(Double(length) / 10 * 8)
        case 3: //7:5
            width = length
            height = Int(Double(length) / 7 * 5)
        case 4: //4:3
            width = length
            height = Int(Double(length) / 4 * 3)
        default: //1:1
            width = length
            height = length
        }
        containerView.bounds.size = CGSize(width: width, height: height)
    }
    
    var scaleX: Int = 1
    @IBAction func mirrorPhoto(_ sender: Any) {
        scaleX *= -1
        photoImageView.transform = CGAffineTransform(scaleX: CGFloat(scaleX), y: 1)
    }
    
    let aDegree = Float.pi/180
    var angle: Int = 0
    @IBAction func rotatePhoto(_ sender: Any) {
        angle += 90
        angle = angle % 360 == 0 ? 0 : angle
        photoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(aDegree * Float(angle)))
    }
    
    @IBAction func scalePhoto(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: false)
        photoImageView.transform = CGAffineTransform(scaleX: CGFloat(sender.value), y: CGFloat(sender.value))
    }
}


extension PhotoViewController: UIImagePickerControllerDelegate {
    //finish picking photo and show
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoImageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}
