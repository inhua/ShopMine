// ShopMineRouteRegistrar.swift - ShopMine 路由自注册
import ShopRouter

public final class ShopMineRouteRegistrar: NSObject, MTRouteRegistrable {
    override public class func initialize() {
        super.initialize()
        guard self === ShopMineRouteRegistrar.self else { return }
        registerRoutes()
    }

    public static func registerRoutes() {
        MTRouter.shared.register(RouterPath.Mine.main)    { _ in MineViewController() }
        MTRouter.shared.register(RouterPath.Mine.address) { _ in UIViewController() }
        MTRouter.shared.register(RouterPath.Mine.wallet)  { _ in UIViewController() }
        MTRouter.shared.register(RouterPath.Mine.coupon)  { _ in UIViewController() }
        MTRouter.shared.register(RouterPath.Mine.setting) { _ in UIViewController() }
    }
}
