import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cameraView: UIView!
    var captureSession = AVCaptureSession();
    var sessionOutput = AVCapturePhotoOutput();
    var previewLayer = AVCaptureVideoPreviewLayer();
    
    override func viewWillAppear(_ animated: Bool) {
        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [
            AVCaptureDeviceType.builtInDualCamera,
            AVCaptureDeviceType.builtInTelephotoCamera,
            AVCaptureDeviceType.builtInWideAngleCamera
            ], mediaType: AVMediaTypeVideo,
               position: AVCaptureDevicePosition.unspecified)
        for device in (deviceDiscoverySession?.devices)! {
            if(device.position == AVCaptureDevicePosition.back){
                do{
                    try device.lockForConfiguration();
                    device.focusMode = .locked
                    device.setFocusModeLockedWithLensPosition(0.0, completionHandler: nil)
                    device.unlockForConfiguration();
                    let input = try AVCaptureDeviceInput(device: device)
                    if(captureSession.canAddInput(input)){
                        captureSession.addInput(input);
                        
                        if(captureSession.canAddOutput(sessionOutput)){
                            captureSession.addOutput(sessionOutput);
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                            cameraView.layer.addSublayer(previewLayer);
                        }
                    }
                }
                catch{
                    print("exception!");
                }
            }
            captureSession.startRunning();
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = cameraView.bounds
    }
}
