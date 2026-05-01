// RouterPath+Mine.swift - ShopMine 组件路由路径常量
import ShopRouter

public extension RouterPath {
    struct Mine {
        public static let main    = "\(RouterPath.scheme)://mine/main"
        public static let address = "\(RouterPath.scheme)://mine/address"
        public static let wallet  = "\(RouterPath.scheme)://mine/wallet"
        public static let coupon  = "\(RouterPath.scheme)://mine/coupon"
        public static let setting = "\(RouterPath.scheme)://mine/setting"
    }
}
