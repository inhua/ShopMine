// CTMediator+Mine.swift - ShopMine 组件的 CTMediator 扩展（通过 Target-Action 调用，无直接业务依赖）
import UIKit
import ShopMediator

public extension CTMediator {

    func mineViewController() -> UIViewController? {
        return performTarget("Mine", action: "viewController", params: nil) as? UIViewController
    }
}
