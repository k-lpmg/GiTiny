//
//  GiTinyProvider.swift
//  GiTiny
//
//  Created by DongHeeKang on 22/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya
import RxSwift

class GiTinyProvider<Target: TargetType>: MoyaProvider<Target> {
    
    // MARK: - Class func
    
    private class func networkActivityPluginFactory() -> NetworkActivityPlugin {
        return NetworkActivityPlugin(networkActivityClosure: { (change, target) in
            DispatchQueue.main.async {
                switch change {
                case .began:
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                case .ended:
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        })
    }
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - Con(De)structor
    
    init(plugins: [PluginType]? = nil) {
        var finalPlugins = plugins ?? [PluginType]()
        finalPlugins.append(type(of: self).networkActivityPluginFactory())
        finalPlugins.append(MoyaCacheablePlugin())
        super.init(plugins: finalPlugins)
    }
    
    // MARK: - Internal methods
    
    func request<T>(_ modelType: T.Type, token: Target, callbackQueue: DispatchQueue? = nil) -> Single<T> where T: Decodable {
        return self.rx.request(token, callbackQueue: callbackQueue).map(modelType)
    }
    
    // MARK: - Private methods
    
    private func parse<T>(_ modelType: T.Type, data: Data) throws -> T where T: Decodable {
        return try JSONDecoder().decode(modelType, from: data)
    }
    
}
