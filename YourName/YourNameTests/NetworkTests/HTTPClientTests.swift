//
//  RouterImplTests.swift
//  AppStoreTests
//
//  Created by dongyoung.lee on 2021/03/21.
//
@testable import YourName
import XCTest

final class RemoteDataLoaderTests: XCTestCase {
  
  // 🥸 Mock
  var mockURL: URL!
  var mockURLRequest: URLRequest!
  var mockURLSession: MockSession!
  
  // 🧪 System Under Test
  var httpClient: HTTPClient!
  
  override func setUp() {
    super.setUp()
    
    mockURL = URL(string: "https://itunes.apple.com/search?term=kakaobank&media=software&country=KR&lang=ko_KR")!
    mockURLRequest = URLRequest(url: mockURL)
    mockURLSession = MockSession()
    httpClient = HTTPClient(session: mockURLSession)
  }
  
  override func tearDown() {
    mockURL = nil
    mockURLRequest = nil
    mockURLSession = nil
    httpClient = nil
    
    super.tearDown()
  }
  
  func test_load_with_URL를_호출하면_주입된_Session_task메소드가_호출된_상태여야한다() {
    httpClient.loadData(with: mockURL)
    XCTAssertTrue(mockURLSession.calledDataTask)
  }
  
  func test_load_with_URLRequest를_호출하면_주입된_Session_task메소드가_호출된_상태여야한다() {
    httpClient.loadData(with: mockURLRequest)
    XCTAssertTrue(mockURLSession.calledDataTask)
  }
  
  func test_load_with_URL의_결과로_반환된_Task는_resume이_호출된_상태여야한다() {
    let task = httpClient.loadData(with: mockURL) as! MockDataTask
    XCTAssertTrue(task.calledResume)
  }
  
  func test_load_with_URLRequest의_결과로_반환된_Task는_resume이_호출된_상태여야한다() {
    let task = httpClient.loadData(with: mockURLRequest) as! MockDataTask
    XCTAssertTrue(task.calledResume)
  }
  
  func test_load_with_URL의_결과로_반환된_Task는_의도한_URL을_가르켜야한다() {
    let task = httpClient.loadData(with: mockURL) as! MockDataTask
    XCTAssertEqual(task.url, mockURL)
  }
  
  func test_load_with_URLRequest의_결과로_반환된_Task는_의도한_URL을_가르켜야한다() {
    let task = httpClient.loadData(with: mockURLRequest) as! MockDataTask
    XCTAssertEqual(task.url, mockURL)
  }
  
  func test_load의_응답의_HTTPStatusCode가_500이면_Error를_뱉어야한다() {
    let expectation = XCTestExpectation()
    defer { wait(for: [expectation], timeout: 1) }
    
    let task = httpClient.loadData(with: mockURLRequest) { result in
      expectation.fulfill()
      switch result {
      case .success:
        XCTFail()
        
      case .failure(let error):
        XCTAssertNotNil(error)
      }
    } as! MockDataTask
    
    task.whenCompletion(statusCode: 500)
  }
  
  func test_load의_응답의_HTTPStatusCode가_200이면_성공해야한다() {
    let expectation = XCTestExpectation()
    defer { wait(for: [expectation], timeout: 1) }
    
    let task = httpClient.loadData(with: mockURLRequest) { result in
      expectation.fulfill()
      switch result {
      case .success(let data):
        XCTAssertNotNil(data)
        
      case .failure:
        XCTFail()
      }
    } as! MockDataTask
    
    task.whenCompletion(data: Data(), statusCode: 200)
  }
  
}
