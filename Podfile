source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

def shared_pods
    ui_pods
    rx_pods
    db_pods
    networking_pods
    etc_pods
end

def ui_pods
    pod 'FluidHighlighter'
    pod 'AwaitToast'
    pod 'PanModal'
end

def rx_pods
    pod 'RxSwift'
    pod 'RxDataSources', '~> 3.0'
    pod 'RxGesture'
end

def db_pods
    pod 'RealmWrapper'
end

def networking_pods
    pod 'Moya/RxSwift', '~> 12.0'
    pod 'Kingfisher', '~> 5.0'
end

def etc_pods
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'SwiftLint'
    pod 'AcknowList'
end

target 'GiTiny' do
    shared_pods

    target 'GiTinyTests' do
        inherit! :search_paths
    end
end

target 'GiTinyUITests' do
    shared_pods
end