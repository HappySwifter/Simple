import Foundation


class NetworkLayerConfiguration {
    
    class func setup() {
        // Backend Configuration
        let conf = BackendConfiguration(baseURL: serverURL)
        BackendConfiguration.shared = conf
        
        // Network Queue
        NetworkQueue.shared = NetworkQueue()
    }
}
