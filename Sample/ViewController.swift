//
//  ViewController.swift
//  Sample
//
//  Created by Jorge Leandro Perez on 11/14/22.
//

import UIKit


class MainViewController: UIViewController {

    @IBOutlet private var referenceSegmentedControl: UISegmentedControl!


    @IBAction
    func presentChildController() {
        guard let targetController = storyboard?.instantiateViewController(withIdentifier: "ChildViewController") as? ChildViewController else {
            return
        }


        targetController.useParentConstraints = referenceSegmentedControl.selectedSegmentIndex == .zero

        let navigationController = UINavigationController(rootViewController: targetController)
        present(navigationController, animated: true)
    }
}


class ChildViewController: UIViewController {

    @IBOutlet private var textView: UITextView!
    private let toolbarView = UIView()
    private(set) lazy var accessoryController: UIInputViewController? = {
        storyboard?.instantiateViewController(withIdentifier: "ToolbarViewController") as? UIInputViewController
    }()


    var useParentConstraints: Bool = false


    override var inputAccessoryViewController: UIInputViewController? {
        accessoryController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.keyboardDismissMode = .interactive
        textView.text = useParentConstraints ?
                            "👉 Using Parent's KeyboardLayoutGuide. Animation works as expected" :
                            "Using the toolbarView's keyboardLayoutGuide. Note that the Keyboard Animation is broken! ☹️"


        toolbarView.backgroundColor = .red
        view.addSubview(toolbarView)

        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbarView.heightAnchor.constraint(equalToConstant: 90),
            buildKeyboardConstraint()
        ])
    }

    @IBAction func resignWasPressed() {
        textView.resignFirstResponder()
    }

    @IBAction func dismissWasPressed() {
        dismiss(animated: true)
    }


    private func buildKeyboardConstraint() -> NSLayoutConstraint {
        if useParentConstraints {
            return view.keyboardLayoutGuide.topAnchor.constraint(equalTo: toolbarView.bottomAnchor)
        }

        return toolbarView.keyboardLayoutGuide.topAnchor.constraint(equalTo: toolbarView.bottomAnchor)
    }
}



class ToolbarViewController: UIInputViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let targetHeight = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        view.frame.size.height = targetHeight
    }
}
