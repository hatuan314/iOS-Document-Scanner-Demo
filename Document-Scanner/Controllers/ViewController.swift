//
//  ViewController.swift
//  Document-Scanner
//
//  Created by Tuan Hoang on 29/10/24.
//

import PhotosUI
import UIKit

enum DocumentSourceType {
    case camera
    case photos
}

class ViewController: UIViewController, PHPickerViewControllerDelegate {
    let cameraScannerModel = CameraScannerModel()
    
    var selectedImages: [UIImage] = []
    private var selectedDocumentSourceType: DocumentSourceType?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onPressedCameraButton(_ sender: UIButton) {
        print("Hello, Camera")
        selectedDocumentSourceType = DocumentSourceType.camera
        cameraScannerModel.startDocumentScanning()
        cameraScannerModel.completeHandler = {
            self.pushToPhotosView()
        }
        
    }
    
    @IBAction func onPressedPhotosButton(_ sender: Any) {
        print("Hello, Photos")
        selectedDocumentSourceType = DocumentSourceType.photos
        openImagePicker()
//        pushToPhotosView()
    }
    
    func pushToPhotosView() {
        if let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "photos_view") as? PhotosViewController {
                // Thực hiện push màn hình mới
                self.navigationController?.pushViewController(destinationVC, animated: true)
                if (self.selectedDocumentSourceType == .camera) {
                    destinationVC.images = cameraScannerModel.images
                } else if (self.selectedDocumentSourceType == .photos) {
                    destinationVC.images = self.selectedImages
                }
                
            }
    }
    
    func openImagePicker() {
        // Cấu hình PHPicker cho phép chọn nhiều ảnh
        var config = PHPickerConfiguration()
        config.filter = .images // Chỉ hiển thị ảnh
        config.selectionLimit = 0 // Cho phép chọn không giới hạn ảnh
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: {
                print("Open Image Picker, complete")
        })
    }

    // Hàm delegate được gọi khi người dùng chọn xong ảnh
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        selectedImages.removeAll() // Làm rỗng danh sách trước khi thêm ảnh mới

        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.selectedImages.append(image) // Thêm ảnh vào mảng
                        }
                    }
                }
            }
        }
        
        picker.dismiss(animated: true, completion: {
            self.pushToPhotosView()
        }) // Đóng picker sau khi chọn xong
    }
}

