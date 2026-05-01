// ShopMineRouteRegistrar.swift - ShopMine 路由注册
import ShopRouter
import UIKit

public final class ShopMineRouteRegistrar: NSObject, MTRouteRegistrable {
    public static func registerRoutes() {
        MTRouter.shared.register(RouterPath.Mine.main)    { _ in MineViewController() }
        MTRouter.shared.register(RouterPath.Mine.address) { _ in UIViewController() }
        MTRouter.shared.register(RouterPath.Mine.wallet)  { _ in UIViewController() }
        MTRouter.shared.register(RouterPath.Mine.coupon)  { _ in UIViewController() }
        MTRouter.shared.register(RouterPath.Mine.setting) { _ in UIViewController() }
    }
}
