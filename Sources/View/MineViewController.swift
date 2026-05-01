// MineViewController.swift - 我的页面
import UIKit
import ShopBase
import ShopBusinessBase
import ShopRouter
import ShopMediator

public class MineViewController: BaseViewController {

    private let viewModel = MineViewModel()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // 订单状态区（横向4格）
    private let orderStatusView = OrderStatusView()

    public override func setupUI() {
        title = "我的"
        tableView.register(MineMenuCell.self, forCellReuseIdentifier: MineMenuCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 52

        // 顶部用户信息 header
        let headerView = MineHeaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 200)
        headerView.onLoginTap = { [weak self] in self?.goLogin() }
        tableView.tableHeaderView = headerView

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    public override func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.refreshHeader()
            self?.tableView.reloadData()
        }
        refreshHeader()
    }

    private func refreshHeader() {
        guard let header = tableView.tableHeaderView as? MineHeaderView else { return }
        header.configure(user: viewModel.currentUser, isLoggedIn: viewModel.isLoggedIn)
    }

    private func goLogin() {
        let loginVC = CTMediator.shared.loginViewController() ?? UIViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
}

extension MineViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int { viewModel.menuSections.count }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.menuSections[section].count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MineMenuCell.reuseID, for: indexPath) as! MineMenuCell
        cell.configure(with: viewModel.menuSections[indexPath.section][indexPath.row])
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.menuSections[indexPath.section][indexPath.row]
        switch item.title {
        case "设置":       routePush(RouterPath.Mine.setting)
        case "收货地址":   routePush(RouterPath.Mine.address)
        case "我的钱包":   routePush(RouterPath.Mine.wallet)
        case "优惠券":     routePush(RouterPath.Mine.coupon)
        default:           showToast("\(item.title) 功能开发中")
        }
    }

    private func showSettingsAlert() {
        let alert = UIAlertController(title: "设置", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "退出登录", style: .destructive) { [weak self] _ in
            UserSession.shared.logout()
            self?.showToast("已退出登录")
        })
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - MineHeaderView
public class MineHeaderView: UIView {

    public var onLoginTap: (() -> Void)?

    private let avatarView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.systemGray4
        v.layer.cornerRadius = 36
        v.clipsToBounds = true
        let iv = UIImageView(image: UIImage(systemName: "person.fill"))
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(iv)
        NSLayoutConstraint.activate([
            iv.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            iv.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            iv.widthAnchor.constraint(equalToConstant: 40),
            iv.heightAnchor.constraint(equalToConstant: 40)
        ])
        return v
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 18)
        return l
    }()

    private let subLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .gray
        return l
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1)
        [avatarView, nameLabel, subLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 72),
            avatarView.heightAnchor.constraint(equalToConstant: 72),

            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarView.topAnchor, constant: 8),

            subLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6)
        ])
        nameLabel.textColor = .white
        subLabel.textColor = UIColor.white.withAlphaComponent(0.8)

        let tap = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        addGestureRecognizer(tap)
    }
    required init?(coder: NSCoder) { fatalError() }

    public func configure(user: UserModel?, isLoggedIn: Bool) {
        if isLoggedIn, let user = user {
            nameLabel.text = user.nickname
            subLabel.text = user.phone
        } else {
            nameLabel.text = "点击登录"
            subLabel.text = "登录后享受更多权益"
        }
    }

    @objc private func headerTapped() { onLoginTap?() }
}

// MARK: - MineMenuCell
public class MineMenuCell: UITableViewCell {
    public static let reuseID = "MineMenuCell"

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1)
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15)
        return l
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        [iconView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }

    public func configure(with item: MineMenuItem) {
        iconView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
    }
}

// MARK: - OrderStatusView（占位）
public class OrderStatusView: UIView {}
