import XCTest
@testable import Plugin

class GimmeImageTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    ffunc testGimmeMediaItem() {
        let plugin = GimmeImagePlugin()
        let call = CAPPluginCall(callbackId: "testCallbackId", options: ["identifier": "testIdentifier"], success: { (result, call) in
            // Verify that the result is a JSObject
            XCTAssertTrue(result is JSObject)

            // Verify that the result contains the expected keys
            // let resultObject = result as! JSObject
            // XCTAssertTrue(resultObject.keys.contains("identifier"))
            // XCTAssertTrue(resultObject.keys.contains("data"))
            // XCTAssertTrue(resultObject.keys.contains("creationDate"))
            // XCTAssertTrue(resultObject.keys.contains("fullWidth"))
            // XCTAssertTrue(resultObject.keys.contains("fullHeight"))
            // XCTAssertTrue(resultObject.keys.contains("thumbnailWidth"))
            // XCTAssertTrue(resultObject.keys.contains("thumbnailHeight"))
            // XCTAssertTrue(resultObject.keys.contains("location"))

            // Verify that the identifier in the result matches the identifier in the call options
            // XCTAssertEqual(resultObject["identifier"] as! String, "testIdentifier")

            // Verify that the data in the result is a base64-encoded string
            // let data = resultObject["data"] as! String
            // XCTAssertTrue(data.isBase64Encoded)

            // Verify that the creationDate in the result is a string in ISO8601 format
            // let creationDate = resultObject["creationDate"] as! String
            // let formatter = ISO8601DateFormatter()
            // XCTAssertNotNil(formatter.date(from: creationDate))

            // Verify that the other values in the result are of the expected types
            // XCTAssertTrue(resultObject["fullWidth"] is Int)
            // XCTAssertTrue(resultObject["fullHeight"] is Int)
            // XCTAssertTrue(resultObject["thumbnailWidth"] is Int)
            // XCTAssertTrue(resultObject["thumbnailHeight"] is Int)

            // Verify that the location in the result is a JSObject with the expected keys
            // in the future...
            // XCTAssertTrue(resultObject["location"] is JSObject)
            // let location = resultObject["location"] as! JSObject
            // XCTAssertTrue(location.keys.contains("latitude"))
            // XCTAssertTrue(location.keys.contains("longitude"))
            // XCTAssertTrue(location.keys.contains("altitude"))
            // XCTAssertTrue(location.keys.contains("heading"))
            // XCTAssertTrue(location.keys.contains("speed"))
        }, error: { (error, call) in
            XCTFail("Unexpected error: \(error)")
        }, isSaved: false, plugin: plugin)

        plugin.gimmeMediaItem(call)
    }
}
}
