import Foundation

public enum ViewModelState<Value> {
    case idle
    case loading
    case loaded(Value)
    case empty
    case error(String)
}
