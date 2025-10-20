// Test file for pre-commit hook validation
import Foundation

class TestClass {
    func testFunction() {
        // This should trigger a warning about print statements
        print("Testing the hook")

        // This should trigger a warning about force unwrapping
        let value: String? = "test"
        let unwrapped = value!.uppercased()

        // TODO: This should be detected
        // FIXME: This should also be detected
    }
}
