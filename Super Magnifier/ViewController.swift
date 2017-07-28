import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cameraView: UIView!
    var captureSession = AVCaptureSession();
    var sessionOutput = AVCapturePhotoOutput();
    var previewLayer = AVCaptureVideoPreviewLayer();
    let focusArray: [Float] = [0.0, 0.5, 1.0];
    var focusArrayIndex = 0;
    
    
    @IBAction func toggleLight(_ sender: UIButton) {
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasTorch {
            do {
                try device.lockForConfiguration()
                let torchOn = !device.isTorchActive
                try device.setTorchModeOnWithLevel(1.0)
                device.torchMode = torchOn ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("error")
            }
        }
    }
    
    @IBAction func toggleFocus(_ sender: UIButton) {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)!
        do {
            if(focusArrayIndex == focusArray.count){
                focusArrayIndex = 0;
            }
            try device.lockForConfiguration();
            device.focusMode = .locked
            device.setFocusModeLockedWithLensPosition(focusArray[focusArrayIndex], completionHandler: nil)
            device.unlockForConfiguration();
            focusArrayIndex += 1
        }
        catch{
            print("exception!");
        }
    }
    override func viewDidLoad() {
        
    }
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
