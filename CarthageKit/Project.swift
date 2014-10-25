//
//  Project.swift
//  Carthage
//
//  Created by Alan Rogers on 12/10/2014.
//  Copyright (c) 2014 Carthage. All rights reserved.
//

import Foundation
import LlamaKit

/// Represents a Project that is using Carthage.
public struct Project {
	/// Path to the root folder
    public var path: String

	/// The project's cart file
	public let cartfile: Cartfile?

	public init(path: String) {
		self.path = path

		if let cartfileURL = NSURL.fileURLWithPath(self.path)?.URLByAppendingPathComponent("Cartfile") {
			if let cartfile = NSString(contentsOfURL: cartfileURL, encoding: NSUTF8StringEncoding, error: nil) {
				self.cartfile = Cartfile.fromString(cartfile).value()
			}
		}
	}

	public func cloneDependencies() -> Result<()> {
		if let dependencies = cartfile?.dependencies {
			for dependency in dependencies {

                // Ignore the result for now
                cloneOrUpdateDependency(dependency)

				let projectPath = path.stringByAppendingPathComponent("Libraries").stringByAppendingPathComponent(dependency.repository.name)

				checkoutDependency(dependency, projectPath)
			}
		}
		return success()
	}
}