// MineViewModel.swift
import Foundation
import ShopBase
import ShopBusinessBase

public struct MineMenuItem {
    public var icon: String
    public var title: String
    public var badge: String?

    public init(icon: String, title: String, badge: String? = nil) {
        self.icon = icon
        self.title = title
        self.badge = badge
    }
}

public class MineViewModel {

    public var currentUser: UserModel? { UserSession.shared.currentUser }
    public var isLoggedIn: Bool { UserSession.shared.isLoggedIn }

    public var menuSections: [[MineMenuItem]] = []
    public var onDataUpdated: (() -> Void)?

    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(sessionChanged),
                                               name: .userDidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionChanged),
                                               name: .userDidLogout, object: nil)
        loadMenus()
    }

    @objc private func sessionChanged() {
        loadMenus()
        onDataUpdated?()
    }

    public func loadMenus() {
        menuSections = [
            [
                MineMenuItem(icon: "shippingbox", title: "待付款"),
                MineMenuItem(icon: "clock", title: "待发货"),
                MineMenuItem(icon: "car", title: "待收货"),
                MineMenuItem(icon: "star", title: "待评价")
            ],
            [
                MineMenuItem(icon: "heart", title: "我的收藏"),
                MineMenuItem(icon: "location", title: "收货地址"),
                MineMenuItem(icon: "creditcard", title: "我的钱包"),
                MineMenuItem(icon: "gift", title: "优惠券")
            ],
            [
                MineMenuItem(icon: "headphones", title: "联系客服"),
                MineMenuItem(icon: "questionmark.circle", title: "帮助中心"),
                MineMenuItem(icon: "gearshape", title: "设置")
            ]
        ]
        onDataUpdated?()
    }

    deinit { NotificationCenter.default.removeObserver(self) }
}
