//
//  zaico_ios_codingtestUITests.swift
//  zaico_ios_codingtestUITests
//
//  Created by ryo hirota on 2025/03/11.
//

import XCTest

final class zaico_ios_codingtestUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testAllScreen() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // 在庫一覧で在庫データが取得できているか
        let inventoryListTable = app.tables.element(boundBy: 0)
        let inventoryListCells = inventoryListTable.cells
        XCTAssertGreaterThan(inventoryListCells.count, 0)
        
        // 在庫詳細へ
        inventoryListCells.element(boundBy: 0).tap()
        // 在庫詳細で正しい在庫が表示されているかチェック
        let InventoryDetailTable = app.tables.element(boundBy: 0)
        let cell = InventoryDetailTable.cells.element(boundBy: 2)
        let rightLabel = cell.staticTexts["InventoryCell_rightText"]
        XCTAssertTrue(rightLabel.exists)
        XCTAssertEqual(rightLabel.label, "おにぎり")
        
        // 在庫一覧へ戻る
        app.navigationBars.buttons.element(boundBy: 0).tap()
        // 在庫データ作成画面へ
        app.navigationBars.buttons["InventoryListViewController_addButton"].tap()
        
        // 在庫作成画面で正しくデータが作成できる
        let textField = app.textFields["InventoryCreateView_titleTextField"]
        XCTAssertTrue(textField.exists)
        textField.tap()
        let text = "test\(Date.now)"
        textField.typeText(text)
        let createButton = app.buttons["InventoryCreateView_createButton"]
        XCTAssertTrue(createButton.exists)
        createButton.tap()
        // 作成後のアラートを消す
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 3))
        alert.buttons.firstMatch.tap()  // ボタンタイトルが「OK」の場合
        
        // 在庫一覧の在庫データに追加できているか
        let inventoryListTable2 = app.tables.element(boundBy: 0)
        let inventoryListCells2 = inventoryListTable2.cells
        XCTAssertGreaterThan(inventoryListCells2.count, 0)
        
        let lastCell = inventoryListCells2.element(boundBy: inventoryListCells2.count - 1)
        let lastCellLabel = lastCell.staticTexts["InventoryCell_rightText"]
        XCTAssertTrue(lastCellLabel.exists)
        XCTAssertEqual(lastCellLabel.label, text)
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
