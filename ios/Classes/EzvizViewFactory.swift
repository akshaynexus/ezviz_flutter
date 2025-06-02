//
//  EzvizPlayerViewFactory.swift
//  ezviz_flutter
//
//  Created by 江鴻 on 2019/8/25.
//
import Foundation
import Flutter

@objc
public class EzvizViewFactory: NSObject,FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    @objc
    public init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    @objc
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return EzvizView.init(messenger: messenger, viewId: viewId, frame: frame)
    }
}
