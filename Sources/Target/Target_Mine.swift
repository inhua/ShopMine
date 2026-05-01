// Target_Mine.swift - 我的组件对外暴露的 Target-Action 入口
import UIKit
import ShopBase
import ShopBusinessBase

@objc(Target_Mine)
public class Target_Mine: NSObject {

    @objc public func action_viewController(_ params: [String: Any]?) -> UIViewController {
        return MineViewController()
    }
}
