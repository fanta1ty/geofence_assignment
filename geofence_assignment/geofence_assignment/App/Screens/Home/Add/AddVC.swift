//
//  AddVC.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import RxSwift
import ReSwift
import UIKit
import SVProgressHUD
import TSwiftHelper
import MapKit

final class AddVC: BaseVC {
    // MARK: - UI Properties
    private let topView = UIView(frame: .zero)
    
    private let topTitleLb = LabelHelper(style: LabelStyle(textFont: .InterBold(size: 18),
                                                           textAlignment: .center),
                                         text: "Add Geofence Item")
    private let topCancelTitleLb = LabelHelper(style: LabelStyle(textColor: .Cerulean,
                                                                 textFont: .InterRegular(size: 18)),
                                               text: "Cancel")
    private let geofenceTypeTitleLb = LabelHelper(style: LabelStyle(),
                                                  text: "Choose Geofence Type:")
    private let geofenceRadiusTitleLb = LabelHelper(style: LabelStyle(),
                                                  text: "Enter Radius:")
    
    private let topCancelBtn = ButtonHelper(style: ButtonStyle())
    private let currentLocationBtn = ButtonHelper(style: ButtonStyle())
    private let saveBtn = ButtonHelper(style: ButtonStyle(backgroundColor: .Cerulean,
                                                          corderRadius: 25,
                                                          textColor: .White,
                                                          textFont: .InterBold(size: 18)),
                                       title: "Save")
    
    private let scrollView = UIScrollView(frame: .zero)
    
    private let containerView = ViewHelper(style: ViewStyle())
    private let radiusView = ViewHelper(style: ViewStyle(borderColor: .Concrete,
                                                         borderWidth: 1,
                                                         corderRadius: 4))
    private let firstSeperateView = ViewHelper(style: ViewStyle(backgroundColor: .Concrete))
    private let secondSeperateView = ViewHelper(style: ViewStyle(backgroundColor: .Concrete))
    
    private let mapView = MKMapView(frame: .zero)
    
    private let radiusTf = TextFieldHelper(style: TextFieldStyle(textAlignment: .right,
                                                                 keyboardType: .numberPad),
                                           placeholder: "Enter Radius Here")
    
    private let geofenceTypeSegmentControl = UISegmentedControl(items: ["Enter", "Exit"])
    
    private let mapPinImageView = ImageViewHelper(style: ImageViewStyle(),
                                                  iconImage: DefinedAssets.mapPinIcon.rawValue.uiImage)
    private let currentLocationImageView = ImageViewHelper(style: ImageViewStyle(),
                                                           iconImage: DefinedAssets.currentLocationIcon.rawValue.uiImage)
    
    // MARK: - Local Properties
    private var appStateStore: Store<AppState> {
        return mainAssemblerResolver.resolve(Store.self,
                                             name: CoreAssemblyType.Store.rawValue)!
    }
    
    let viewModel: AddVM = AddVM()
    private var disposeBag: DisposeBag?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStoredGeofence()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = nil
    }
    
    deinit {
        Log.verbose("\(nameOfClass) deinit")
    }
    
    // MARK: setupUI
    override func setupUI() {
        view.backgroundColor = .white
        
        // MARK: topView
        topView.makeBigShadow()
        topView.backgroundColor = .white
        view.addSubview(topView)
        
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        // MARK: topTitleLb
        topView.addSubview(topTitleLb)
        
        topTitleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // MARK: topCancelTitleLb
        topView.addSubview(topCancelTitleLb)
        
        topCancelTitleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(topTitleLb)
        }
        
        // MARK: topCancelBtn
        topView.addSubview(topCancelBtn)
        
        topCancelBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
        
        // MARK: scrollView
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        // MARK: containerView
        scrollView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // MARK: mapView
        mapView.delegate = self
        containerView.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(view.frame.height / 2)
        }
        
        // MARK: firstSeperateView
        containerView.addSubview(firstSeperateView)
        
        firstSeperateView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.top.equalTo(mapView.snp.bottom).offset(8)
        }
        
        // MARK: geofenceTypeTitleLb
        containerView.addSubview(geofenceTypeTitleLb)
        
        geofenceTypeTitleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(firstSeperateView.snp.bottom).offset(8)
        }
        
        // MARK: geofenceTypeSegmentControl
        geofenceTypeSegmentControl.selectedSegmentIndex = 0
        containerView.addSubview(geofenceTypeSegmentControl)

        geofenceTypeSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(geofenceTypeTitleLb.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // MARK: secondSeperateView
        containerView.addSubview(secondSeperateView)
        
        secondSeperateView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.top.equalTo(geofenceTypeSegmentControl.snp.bottom).offset(8)
        }
        
        // MARK: geofenceRadiusTitleLb
        containerView.addSubview(geofenceRadiusTitleLb)
        
        geofenceRadiusTitleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(secondSeperateView.snp.bottom).offset(8)
        }
        
        // MARK: radiusView
        containerView.addSubview(radiusView)
        
        radiusView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(geofenceRadiusTitleLb.snp.bottom).offset(8)
            make.height.equalTo(40)
        }
        
        // MARK: radiusTf
        radiusView.addSubview(radiusTf)
        
        radiusTf.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
        }
        
        // MARK: saveBtn
        containerView.addSubview(saveBtn)
        
        saveBtn.snp.makeConstraints { make in
            make.top.equalTo(radiusView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        // MARK: mapPinImageView
        containerView.addSubview(mapPinImageView)
        
        mapPinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.center.equalTo(mapView)
        }
        
        // MARK: currentLocationImageView
        containerView.addSubview(currentLocationImageView)
        
        currentLocationImageView.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.right.equalTo(mapView.snp.right).offset(-4)
            make.bottom.equalTo(mapView.snp.bottom).offset(-4)
        }
        
        // MARK: currentLocationBtn
        containerView.addSubview(currentLocationBtn)
        
        currentLocationBtn.snp.makeConstraints { make in
            make.center.equalTo(currentLocationImageView)
            make.width.height.equalTo(60)
        }
    }
    
    // MARK: setupRx
    override func setupRx() {
        disposeBag = DisposeBag()
        
        // MARK: topCancelBtn
        topCancelBtn.rx.tap
            .bind(to: viewModel.input.onCancelAction)
            .disposed(by: disposeBag!)
        
        // MARK: currentLocationBtn
        currentLocationBtn.rx.tap
            .bind(to: viewModel.input.onCurrentLocationAction)
            .disposed(by: disposeBag!)
        
        // MARK: saveBtn
        saveBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let radius = self.radiusTf.text?.toDouble() else { return }
                let coordinate = self.mapView.centerCoordinate
                let type: GeofenceType = self.geofenceTypeSegmentControl.selectedSegmentIndex == 0 ?
                    .enter : .exit
                let geofence = Geofence(coordinate: coordinate,
                                        radius: radius,
                                        type: type)
                self.viewModel.input.onSaveAction.onNext(geofence)
            })
            .disposed(by: disposeBag!)
        
        // MARK: onStartCancelAction
        viewModel.output.onStartCancelAction
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag!)
        
        // MARK: onStartSaveAction
        viewModel.output.onStartSaveAction
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag!)
        
        // MARK: onStartCurrentLocationAction
        viewModel.output.onStartCurrentLocationAction
            .subscribe(onNext: { [weak self] coordinate in
                self?.focusToCurrentLocation(coordinate: coordinate)
            })
            .disposed(by: disposeBag!)
    }
}

// MARK: - MKMapViewDelegate
extension AddVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard overlay is MKCircle else { return MKOverlayRenderer() }
        
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.lineWidth = 1.0
        circleRenderer.strokeColor = .green
        circleRenderer.fillColor = UIColor.green.withAlphaComponent(0.4)
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Geofence else { return nil }
        
        let identifier = "GeofenceView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView != nil {
            annotationView?.annotation = annotation
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation,
                                                 reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        }
        
        return annotationView
    }
}

// MARK: - Private Functions
extension AddVC {
    // MARK: focusToCurrentLocation
    final private func focusToCurrentLocation(coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    // MARK: updateGeofenceOnMap
    private func addGeofenceOnMap(geofence: Geofence) {
        mapView.addAnnotation(geofence)
        
        let circleOverlay = MKCircle(center: geofence.coordinate,
                                     radius: geofence.radius)
        mapView.addOverlay(circleOverlay)
    }
    
    // MARK: loadStoredGeofence
    private func loadStoredGeofence() {
        let geofenceDataStore = mainAssemblerResolver.resolve(LocalGeofenceDataStore.self)!
        _ = geofenceDataStore.get()
            .done { [weak self] geofences in
                for geofence in geofences {
                    self?.addGeofenceOnMap(geofence: geofence)
                }
            }
    }
}
