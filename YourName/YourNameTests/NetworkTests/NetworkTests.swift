//
//  HTTPClientTests.swift
//  AppStoreTests
//
//  Created by dongyoung.lee on 2021/03/19.
//

@testable import YourName
import XCTest
import RxTest
import RxBlocking

final class HTTPClientTests: XCTestCase {
    
    // 🥸 Mock
    var mockAPI: MockAPI!
    var mockDataLoader: MockDataLoader!
    var mockDecodingService: MockDecodingService!
    
    // 🧪 System Under Test
    private var network: Network!
    
    override func setUp() {
        super.setUp()
        
        mockAPI = MockAPI()
        mockDataLoader = MockDataLoader()
        mockDecodingService = MockDecodingService()
        
        network = Network(
            dataLoader: mockDataLoader,
            decodingService: mockDecodingService
        )
    }
    
    override func tearDown() {
        mockAPI = nil
        mockDataLoader = nil
        mockDecodingService = nil
        network = nil
        super.tearDown()
    }
    
    private func setupStub() {
        mockDataLoader.stubedData = .testFake
        mockDecodingService.stubedResponse = TestResponse.stub
    }
    
    func test_request를_호출하면_router의_route가_호출되어야한다() {
        setupStub()
        do {
            _ = try network.response(of: mockAPI).toBlocking(timeout: 1).toArray()
            XCTAssertTrue(mockDataLoader.calledLoadData)
        } catch {
            XCTFail("\(error.localizedDescription) occur")
        }
    }
    
    func test_request의_API의_Response타입이_decodingService가_decode를_호출해야한다() {
        setupStub()
        do {
            _ = try network.response(of: mockAPI).toBlocking(timeout: 1).toArray()
            XCTAssertTrue(mockDecodingService.calledDecode)
        } catch {
            XCTFail("\(error.localizedDescription) error occur")
        }
    }
    
    func test_request의_API의_Response타입이_decodingService에게_전달되어야한다() {
        setupStub()
        do {
            _ = try network.response(of: mockAPI).toBlocking(timeout: 1).toArray()
            XCTAssertEqual(mockDecodingService.passedTypeName, "\(TestResponse.self)")
        } catch {
            XCTFail("\(error.localizedDescription) error occur")
        }
    }
}
