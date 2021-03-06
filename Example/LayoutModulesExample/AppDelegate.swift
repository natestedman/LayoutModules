// LayoutModules
// Written in 2015 by Nate Stedman <nate@natestedman.com>
//
// To the extent possible under law, the author(s) have dedicated all copyright and
// related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with
// this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    @objc lazy var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        func controller(viewController: UIViewController, title: String) -> UIViewController
        {
            viewController.title = title
            return UINavigationController(rootViewController: viewController)
        }

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            controller(ModulesViewController(), title: "Modules"),
            controller(InitialFinalViewController(), title: "Insert & Delete")
        ]

        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}
