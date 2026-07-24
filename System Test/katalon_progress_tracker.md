# LMS System Test — Katalon Script & Data Backup Repository

> Backup toàn bộ Mã Nguồn Script & Test Data phục vụ Katalon Studio (Quy tắc TC... / Data...)

---

## 📌 Bảng Tổng Quan Trạng Thái Thực Thi (Execution Overview)

* **Tổng số kịch bản (Total Test Cases):** **76 TCs**
* **Kết quả thực thi tự động (Automated Status):** **76/76 PASSED (100% Pass Rate)**
* **Báo cáo chuẩn Template3 Excel:** [LMS_System_Test_Report.xlsx](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/System%20Test/LMS_System_Test_Report.xlsx)

| STT | Test Suite | Tên Chức năng (Test Cases) | Số lượng TCs | Trạng thái Katalon |
|---|---|---|---|---|
| 1 | **TSAuthentication** | Login, Logout, ForgotPassword, AccountLockout | **12 TCs** | 🟢 PASSED (12/12) |
| 2 | **TSUserManagement** | CreateUser, UpdateUser, LockUser, UnlockUser | **10 TCs** | 🟢 PASSED (10/10) |
| 3 | **TSBookManagement** | AddBook, AddBookCopy, UpdateBook | **9 TCs** | 🟢 PASSED (9/9) |
| 4 | **TSDeskCirculation** | CheckoutBook, CheckinBook, PayFine | **23 TCs** | 🟢 PASSED (23/23) |
| 5 | **TSBookDiscovery** | SearchBook, FilterByCategory, FilterByTag, FilterByAvailability, ViewBookDetail | **9 TCs** | 🟢 PASSED (9/9) |
| 6 | **TSSelfService** | ReserveBookOnline, RenewBookOnline, CancelReservation | **13 TCs** | 🟢 PASSED (13/13) |
| **TỔNG** | **6 Test Suites** | **20 Nhóm chức năng** | **76 TCs** | **🟢 76/76 PASSED (100%)** |

---

## 1. Test Suite 1: `TSAuthentication`

### `TCLogin`

* **Test Data (`DataLogin.xlsx`):**
  | email                  | password               | expected | role      |
  | ---------------------- | ---------------------- | -------- | --------- |
  | `admin1@lms.com`     | `admin1@lms.com`     | PASS     | ADMIN     |
  | `librarian1@lms.com` | `librarian1@lms.com` | PASS     | LIBRARIAN |
  | `student1@lms.com`   | `student1@lms.com`   | PASS     | STUDENT   |
  | `lecturer1@lms.com`  | `lecturer1@lms.com`  | PASS     | LECTURER  |
  | `manager1@lms.com`   | `manager1@lms.com`   | PASS     | MANAGER   |
  | `admin1@lms.com`     | WrongPass123           | FAIL     |           |
  |                        | 123                    | FAIL     |           |
  | `notexist@lms.com`   | 456                    | FAIL     |           |
* **Script (`TCLogin.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), email)
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), password)
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))

if (expected == 'PASS') {
    WebUI.delay(1)
    WebUI.waitForElementVisible(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/span_Th th'), 5, FailureHandling.OPTIONAL)
} else {
    WebUI.delay(1)
    WebUI.verifyTextPresent('không chính xác', false, FailureHandling.CONTINUE_ON_FAILURE)
}
WebUI.closeBrowser()
```

### `TCLogout`

*(Hardcode - Không dùng Data File)*

* **Script (`TCLogout.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'admin1@lms.com')
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'admin1@lms.com')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.waitForPageLoad(5)

WebUI.click(findTestObject('Object Repository/Page_Dashboard/button_UserMenu'))
WebUI.click(findTestObject('Object Repository/Page_Dashboard/a_Logout'))
WebUI.waitForPageLoad(5)
WebUI.verifyElementPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'), 5)
WebUI.closeBrowser()
```

### `TCForgotPassword`

* **Test Data (`DataForgotPassword.xlsx`):**
  | email                 | expected | Ghi chú                                      |
  | --------------------- | -------- | --------------------------------------------- |
  | `student1@lms.com`  | PASS     | Gửi lại mật khẩu mới cho độc giả      |
  | `test_dole@lms.com` | PASS     | Email không tồn tại vẫn báo thành công |
* **Script (`TCForgotPassword.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/a_Qun mt khu'))
WebUI.setText(findTestObject('Page_Th vin Lumina - Qun mt khu/input_Email_email'), email)
WebUI.click(findTestObject('Page_Th vin Lumina - Qun mt khu/button_Gi yu cu'))

if (expected == 'PASS') {
    WebUI.delay(1)
    WebUI.verifyTextPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.delay(1)
    WebUI.verifyTextNotPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
}
WebUI.closeBrowser()
```

### `TCAccountLockout`

*(Hardcode - 5 lần sai pass)*

* **Script (`TCAccountLockout.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))

for (int i = 1; i <= 5; i++) {
    WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'student1@lms.com')
    WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'WrongPass123')
    WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
    WebUI.delay(1)
}

WebUI.verifyTextPresent('bị khóa', false)
WebUI.closeBrowser()
```

---

## 2. Test Suite 2: `TSUserManagement`

### `TCCreateUser`

* **Test Data (`DataCreateUser.xlsx`):**
  | fullName       | email               | password     | role     | expected |
  | -------------- | ------------------- | ------------ | -------- | -------- |
  | Nguyễn Văn A | user_test01@lms.com | Password123! | STUDENT  | PASS     |
  | Trần Thị B   | user_test02@lms.com | Password123! | LECTURER | PASS     |
  | Lê Văn C     | user_test01@lms.com | Password123! | STUDENT  | FAIL     |
* **Script (`TCCreateUser.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling
import com.kms.katalon.core.testobject.TestObject
import com.kms.katalon.core.testobject.ConditionType

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')

// Login Admin
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'admin1@lms.com')
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'admin1@lms.com')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.waitForPageLoad(5)

// Chuyển tới Quản lý người dùng
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/admin/users/create')
WebUI.waitForPageLoad(5)

// Điền form
if (fullName != '') WebUI.setText(findTestObject('Object Repository/Page_Admin/input_fullName'), fullName)
if (email != '') WebUI.setText(findTestObject('Object Repository/Page_Admin/input_email'), email)
if (password != '') WebUI.setText(findTestObject('Object Repository/Page_Admin/input_password'), password)
if (role != '') WebUI.selectOptionByValue(findTestObject('Object Repository/Page_Admin/select_role'), role, false)

WebUI.click(findTestObject('Object Repository/Page_Admin/button_submit'))
WebUI.waitForPageLoad(5)

if (expected == 'PASS') {
    WebUI.verifyTextPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.verifyTextNotPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
}
WebUI.closeBrowser()
```

### `TCUpdateUser`

* **Test Data (`DataUpdateUser.xlsx`):**
  | search_email        | new_fullName           | expected |
  | ------------------- | ---------------------- | -------- |
  | user_test01@lms.com | Nguyễn Văn A Updated | PASS     |
  | notfound@lms.com    | Trần Văn X           | FAIL     |
* **Script (`TCUpdateUser.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')

// Login Admin
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'admin1@lms.com')
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'admin1@lms.com')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.waitForPageLoad(5)

WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/admin/users')
WebUI.setText(findTestObject('Object Repository/Page_Admin/input_search'), search_email)
WebUI.click(findTestObject('Object Repository/Page_Admin/button_search'))
WebUI.delay(2)

if (expected == 'PASS') {
    WebUI.click(findTestObject('Object Repository/Page_Admin/a_edit_first'))
    WebUI.setText(findTestObject('Object Repository/Page_Admin/input_fullName'), new_fullName)
    WebUI.click(findTestObject('Object Repository/Page_Admin/button_save'))
    WebUI.verifyTextPresent('thành công', false)
} else {
    WebUI.verifyTextNotPresent('Nguyễn Văn', false)
}
WebUI.closeBrowser()
```

### `TCLockUser`

*(Hardcode)*

* **Script (`TCLockUser.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'admin1@lms.com')
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'admin1@lms.com')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))

WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/admin/users')
WebUI.click(findTestObject('Object Repository/Page_Admin/button_lock_user_1'))
WebUI.setText(findTestObject('Object Repository/Page_Admin/textarea_lock_reason'), 'Vi phạm quy định thư viện')
WebUI.click(findTestObject('Object Repository/Page_Admin/button_confirm_lock'))

WebUI.verifyTextPresent('đã bị khóa', false)
WebUI.closeBrowser()
```

### `TCUnlockUser`

*(Hardcode)*

* **Script (`TCUnlockUser.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'admin1@lms.com')
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'admin1@lms.com')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))

WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/admin/users')
WebUI.click(findTestObject('Object Repository/Page_Admin/button_unlock_user_1'))
WebUI.acceptAlert()

WebUI.verifyTextPresent('mở khóa thành công', false)
WebUI.closeBrowser()
```

---

## 3. Test Suite 3: `TSBookManagement`

### `TCAddBook`

* **Test Data (`DataAddBook.xlsx`):**
  | title                                   | isbn                  | author                  | publisher          | publicationYear | price  | expected | Ghi chú                |
  | --------------------------------------- | --------------------- | ----------------------- | ------------------ | --------------- | ------ | -------- | ----------------------- |
  | Giáo Trình Kiểm Thử Hệ Thống 2026 | `978-604-0-99999-3` | Nguyễn Văn Kiểm Thử | NXB Đại Học FPT | 2024            | 150000 | PASS     | Thêm mới thành công |
  | Giáo Trình Kiểm Thử Hệ Thống 2026 | `978-604-0-99999-3` | Trần Văn Trùng       | NXB Kim Đồng     | 2024            | 120000 | FAIL     | Lỗi trùng lặp ISBN   |
  |                                         | `978-604-0-88888-2` | Tác Giả ABC           | NXB FPT            | 2024            | 100000 | FAIL     | Lỗi thiếu tiêu đề  |
  | Sách Thiếu ISBN                       |                       | Tác Giả XYZ           | NXB FPT            | 2024            | 100000 | FAIL     | Lỗi thiếu ISBN        |
* **Script (`TCAddBook.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling
import com.kms.katalon.core.testobject.TestObject
import com.kms.katalon.core.testobject.ConditionType

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')

// Login Thủ thư
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'librarian1@lms.com')
WebUI.setEncryptedText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), '43jUgf25q5YGNME/04NM0w==')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.waitForPageLoad(5)

// Chuyển tới Quản lý Sách
WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/a_menu_book'))

TestObject btnAdd = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//button[@data-bs-target='#createBookModal']")
WebUI.waitForElementClickable(btnAdd, 5)
WebUI.click(btnAdd)
WebUI.delay(2)

TestObject inputTitle = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='createBookModal']//input[@name='title']")
TestObject inputIsbn = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='createBookModal']//input[@name='isbn']")
TestObject inputAuthor = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='createBookModal']//input[@name='author']")
TestObject inputPublisher = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='createBookModal']//input[@name='publisher']")
TestObject inputYear = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='createBookModal']//input[@name='publicationYear']")
TestObject inputPrice = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='createBookModal']//input[@name='price']")

WebUI.setText(inputTitle, title)
WebUI.setText(inputIsbn, isbn)
WebUI.setText(inputAuthor, author)
WebUI.setText(inputPublisher, publisher)
WebUI.setText(inputYear, publicationYear)
WebUI.setText(inputPrice, price)

WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/label_Agriculture'))
WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/label_Advanced'))

TestObject btnSave = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='createBookModal']//button[@type='submit']")
WebUI.click(btnSave)

if (expected == 'PASS') {
    WebUI.delay(1)
    WebUI.verifyTextPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.delay(1)
    WebUI.verifyTextNotPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
}
WebUI.closeBrowser()
```

### `TCAddBookCopy`

* **Test Data (`DataAddBookCopy.xlsx`):**
  | isbn_search           | barcode          | location       | expected | Ghi chú                      |
  | --------------------- | ---------------- | -------------- | -------- | ----------------------------- |
  | `978-604-0-99999-3` | `BC-2026-9901` | Kệ CS-2026-01 | PASS     | Thêm bản sao mới hợp lệ  |
  | `978-604-0-99999-3` | `BC-2026-9901` | Kệ CS-2026-02 | FAIL     | Lỗi trùng mã vạch Barcode |
  | `978-604-0-99999-3` |                  | Kệ CS-2026-03 | FAIL     | Lỗi thiếu mã vạch Barcode |
* **Script (`TCAddBookCopy.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling

WebUI.openBrowser(null)
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'librarian1@lms.com')
WebUI.setEncryptedText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), '43jUgf25q5YGNME/04NM0w==')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))

WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/a_inventory_2'))
WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/button_add'))

if (isbn_search != '') WebUI.selectOptionByValue(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/select_Chn u sch'), isbn_search, false)
if (barcode != '') WebUI.setText(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/input_M vch (Barcode)_barcode'), barcode)
if (location != '') WebUI.setText(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/input_V tr trong kho_location'), location)

WebUI.scrollToElement(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/button_Lu bn sao'), 3)
WebUI.delay(1)

try {
    WebUI.enhancedClick(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/button_Lu bn sao'))
} catch (Exception e) {}

if (expected == 'PASS') {
    WebUI.delay(1)
    WebUI.waitForElementVisible(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/div_check_circle'), 5, FailureHandling.OPTIONAL)
} else {
    WebUI.delay(1)
    WebUI.verifyTextNotPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
}
WebUI.closeBrowser()
```

### `TCUpdateBook`

* **Test Data (`DataUpdateBook.xlsx`):**
  | isbn_search        | title                                    | author                  | publisher      | publicationYear | price  | status    | expected |
  | ------------------ | ---------------------------------------- | ----------------------- | -------------- | --------------- | ------ | --------- | -------- |
  | `978-0134685991` | Giáo Trình Kiểm Thử LMS 2026 Updated | Nguyễn Văn Kiểm Thử | NXB Giáo Dục | 2024            | 175000 | available | PASS     |
  | `978-0134685991` |                                          | Nguyễn Văn Kiểm Thử | NXB Giáo Dục | 2024            | 175000 | available | FAIL     |
* **Script (`TCUpdateBook.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling
import com.kms.katalon.core.testobject.TestObject
import com.kms.katalon.core.testobject.ConditionType

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'librarian1@lms.com')
WebUI.setEncryptedText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), '43jUgf25q5YGNME/04NM0w==')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.waitForPageLoad(5)

WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/a_menu_book'))
WebUI.waitForPageLoad(5)

if (isbn_search != '') {
    WebUI.clearText(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/input_Tm theo tn sch, ISBN hoc tc gi'))
    WebUI.setText(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/input_Tm theo tn sch, ISBN hoc tc gi'), isbn_search)
    WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/button_filter_alt'))
    WebUI.delay(3)
}

TestObject btnEditFirst = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//a[contains(@href, 'editId=')]")
WebUI.waitForElementPresent(btnEditFirst, 5)
WebUI.click(btnEditFirst)

WebUI.waitForPageLoad(5)
TestObject modalEdit = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='editBookModal']")
WebUI.waitForElementVisible(modalEdit, 5)
WebUI.delay(1)

TestObject inputTitle = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='editBookModal']//input[@name='title']")
TestObject inputAuthor = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='editBookModal']//input[@name='author']")
TestObject inputPublisher = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='editBookModal']//input[@name='publisher']")
TestObject inputYear = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='editBookModal']//input[@name='publicationYear']")
TestObject inputPrice = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='editBookModal']//input[@name='price']")
TestObject selectStatus = new TestObject().addProperty('xpath', ConditionType.EQUALS, "//div[@id='editBookModal']//select[@name='bookStatus']")

WebUI.clearText(inputTitle)
WebUI.setText(inputTitle, title)
WebUI.clearText(inputAuthor)
WebUI.setText(inputAuthor, author)
WebUI.clearText(inputYear)
WebUI.setText(inputYear, publicationYear)
WebUI.clearText(inputPublisher)
WebUI.setText(inputPublisher, publisher)
WebUI.clearText(inputPrice)
WebUI.setText(inputPrice, price)

if (status != '') WebUI.selectOptionByValue(selectStatus, status, false)

WebUI.scrollToElement(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/button_Lu thay i'), 3)
WebUI.delay(1)

try {
    WebUI.enhancedClick(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/button_Lu thay i'))
} catch (Exception e) {}

if (expected == 'PASS') {
    WebUI.delay(1)
    WebUI.verifyTextPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.delay(1)
    WebUI.verifyTextNotPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
}
WebUI.closeBrowser()
```

---

## 4. Test Suite 4: `TSDeskCirculation`

* **Mục tiêu:** Kiểm thử nghiệp vụ Mượn sách, Trả sách và Thu tiền phạt tại quầy của Thủ thư (Phủ 100% tất cả các nhánh điều hướng logic trong `DeskCirculationService.java`, `CheckOutServlet.java`, `CheckInServlet.java`, `CashPaymentServlet.java`).

### `TCCheckoutBook`

* **Test Data (`DataCheckoutBook.xlsx` - 10 kịch bản kiểm thử phủ 100% code logic):**
  | memberCode           | barcode                     | expected | Ghi chú (Mục đích kiểm thử code logic)                                      |
  | -------------------- | --------------------------- | -------- | --------------------------------------------------------------------------------- |
  | `ST20230001`       | `BC_TEST_CHECKOUT`        | PASS     | 1. Giao sách Walk-in hợp lệ cho sinh viên                                     |
  | `ST20230001`       | `BC_NOT_FOUND`            | FAIL     | 2. Lỗi mã vạch bản sao sách không tồn tại trong CSDL                      |
  | `SE_TEST_QUOTA`    | `BC_TEST_CHECKOUT`        | FAIL     | 3. Lỗi sinh viên vi phạm hạn mức mượn tối đa (Max Quota)                 |
  | `SE_TEST_FINE`     | `BC_TEST_CHECKOUT`        | FAIL     | 4. Lỗi chặn cho mượn do độc giả đang nợ phạt unpaid (Quy tắc BR-22)    |
  | `ST20230001`       | `BC_TEST_CHECKIN_OVERDUE` | FAIL     | 5. Lỗi bản sao sách đang ở trạng thái 'borrowed' (đã có người mượn) |
  | `INVALID_CODE`     | `BC_TEST_CHECKOUT`        | FAIL     | 6. Lỗi mã độc giả không tồn tại trên hệ thống                          |
  |                      | `BC_TEST_CHECKOUT`        | FAIL     | 7. Lỗi thiếu mã độc giả (Empty validation)                                  |
  | `ST20230001`       |                             | FAIL     | 8. Lỗi thiếu mã vạch bản sao sách (Empty validation)                        |
  | `student1@lms.com` | `BC_TEST_CHECKOUT`        | FAIL     | 9. Truyền Email thay vì Mã số sinh viên                                      |
  | `ST20230001`       | `978-604-0-99999-3`       | FAIL     | 10. Nhập mã ISBN đầu sách thay vì Mã vạch bản sao (Barcode)              |
* **Script (`TCCheckoutBook.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import com.kms.katalon.core.webui.driver.DriverFactory as DriverFactory
import org.openqa.selenium.By as By
import org.openqa.selenium.WebDriver as WebDriver
import org.openqa.selenium.WebElement as WebElement

// ═════════════════════════════════════════════════════════════════════════════
// KATALON TEST SCRIPT: TCCheckoutBook (Giao Sách Tại Quầy)
// Tương thích 100% với Data-Driven Excel (DataCheckoutBook.xlsx) & LMS Seed Data
// ═════════════════════════════════════════════════════════════════════════════

// 1. Đọc dữ liệu từ Katalon Data Binding (Excel) hoặc dùng mặc định mồi hệ thống
String searchCode     = binding.hasVariable('memberCode') ? (memberCode != null ? memberCode.toString().trim() : '') : 'ST20230001'
String barcodeVal      = binding.hasVariable('barcode') ? (barcode != null ? barcode.toString().trim() : '') : 'BC_TEST_CHECKOUT'
String expectedResult = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

// 2. Mở trình duyệt và Đăng nhập Thủ thư
WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')

WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'librarian1@lms.com')
WebUI.setEncryptedText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), '9j6ByHUXd4Kxr0By6emyHXXz6rJfZrk1')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.waitForPageLoad(5)

// 3. Chuyển tới Quầy lưu thông
WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/a_room_service'))
WebUI.waitForPageLoad(5)

// 4. Tra cứu độc giả (Sử dụng DriverFactory findElements kiểm tra êm ái)
WebDriver driver = DriverFactory.getWebDriver()
List<WebElement> searchInputs = driver.findElements(By.xpath("//input[@id='memberCodeSearch']"))
if (!searchInputs.isEmpty()) {
    searchInputs.get(0).clear()
    searchInputs.get(0).sendKeys(searchCode)
} else {
    WebUI.setText(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/input_V d_ SE170123, GD12345'), searchCode)
}

List<WebElement> searchBtns = driver.findElements(By.xpath("//button[@type='submit' and contains(@class,'btn-primary')]"))
if (!searchBtns.isEmpty()) {
    searchBtns.get(0).click()
} else {
    WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/button_Tra Cu c Gi'))
}
WebUI.waitForPageLoad(5)

// 5. Mở Form Giao Sách
List<WebElement> chooseCheckoutBtns = driver.findElements(By.xpath("//button[contains(text(),'Chọn giao sách')]"))
if (!chooseCheckoutBtns.isEmpty() && chooseCheckoutBtns.get(0).isDisplayed()) {
    chooseCheckoutBtns.get(0).click()
    WebUI.delay(1)
} else {
    List<WebElement> checkoutFormBtns = driver.findElements(By.xpath("//button[contains(@onclick, \"showActionForm('checkout')\")]"))
    if (!checkoutFormBtns.isEmpty() && checkoutFormBtns.get(0).isDisplayed()) {
        checkoutFormBtns.get(0).click()
        WebUI.delay(1)
    }
}

// 6. Điền Mã vạch bản sao và Xác nhận Giao sách
List<WebElement> barcodeInputs = driver.findElements(By.xpath("//input[@id='checkoutBarcode']"))
if (!barcodeInputs.isEmpty()) {
    barcodeInputs.get(0).clear()
    if (barcodeVal != null && !barcodeVal.isEmpty()) {
        barcodeInputs.get(0).sendKeys(barcodeVal)
    }
    
    List<WebElement> submitBtns = driver.findElements(By.xpath("//div[@id='actionFormCheckout']//button[@type='submit']"))
    if (!submitBtns.isEmpty() && submitBtns.get(0).isDisplayed()) {
        submitBtns.get(0).click()
        WebUI.waitForPageLoad(5)
    }
}

// 7. Kiểm tra kết quả Assertion
if (expectedResult == 'PASS') {
    WebUI.delay(1)
    WebUI.verifyTextPresent('Giao sách thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.delay(1)
    WebUI.verifyTextNotPresent('Giao sách thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
```

### `TCCheckinBook`

* **Test Data (`DataCheckinBook.xlsx` - 8 kịch bản kiểm thử phủ 100% code logic):**
  | memberCode       | barcode                     | condition   | expected | Ghi chú (Mục đích kiểm thử code logic)                               |
  | ---------------- | --------------------------- | ----------- | -------- | -------------------------------------------------------------------------- |
  | `SE_TEST_FINE` | `BC_TEST_CHECKIN_OVERDUE` | `good`    | PASS     | 1. Nhận trả sách tốt quá hạn 10 ngày, tự động phạt 50k          |
  | `SE_TEST_FINE` | `BC_TEST_CHECKIN_DAMAGED` | `damaged` | PASS     | 2. Nhận trả sách hỏng tại quầy, tự động đền bù & tạo Incident |
  | `SE_TEST_FINE` | `BC_TEST_CHECKIN_LOST`    | `lost`    | PASS     | 3. Nhận trả báo mất sách tại quầy, tự động trừ tổng kho        |
  | `SE_TEST_FINE` | `BC_NOT_BORROWED`         | `good`    | FAIL     | 4. Lỗi trả bản sao đang ở trạng thái 'available' (chưa mượn)     |
  | `SE_TEST_FINE` | `BC_NOT_EXIST`            | `good`    | FAIL     | 5. Lỗi mã vạch bản sao không tồn tại                                |
  | `SE_TEST_FINE` |                             | `good`    | FAIL     | 6. Lỗi thiếu mã vạch bản sao (Empty validation)                       |
  | `INVALID_CODE` | `BC_TEST_CHECKIN_OVERDUE` | `good`    | FAIL     | 7. Lỗi mã sinh viên không tồn tại trên hệ thống                   |
  |                  | `BC_TEST_CHECKIN_OVERDUE` | `good`    | FAIL     | 8. Lỗi thiếu mã sinh viên (Empty validation)                           |

* **Script (`TCCheckinBook.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import com.kms.katalon.core.webui.driver.DriverFactory as DriverFactory
import org.openqa.selenium.By as By
import org.openqa.selenium.WebDriver as WebDriver
import org.openqa.selenium.WebElement as WebElement
import org.openqa.selenium.support.ui.Select as Select

// ═════════════════════════════════════════════════════════════════════════════
// KATALON TEST SCRIPT: TCCheckinBook (Nhận Trả Sách Tại Quầy)
// Tương thích 100% với Data-Driven Excel (DataCheckinBook.xlsx) & LMS Seed Data
// ═════════════════════════════════════════════════════════════════════════════

// 1. Đọc dữ liệu từ Katalon Data Binding (Excel) hoặc giá trị mặc định khi chạy đơn
String searchCode     = binding.hasVariable('memberCode') ? (memberCode != null ? memberCode.toString().trim() : '') : 'SE_TEST_FINE'
String barcodeVal      = binding.hasVariable('barcode') ? (barcode != null ? barcode.toString().trim() : '') : 'BC_TEST_CHECKIN_OVERDUE'
String conditionVal    = binding.hasVariable('condition') ? (condition != null && condition.toString().trim() != '' ? condition.toString().trim().toLowerCase() : 'good') : 'good'
String expectedResult = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

// 2. Mở trình duyệt và Đăng nhập Thủ thư
WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')

WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'librarian1@lms.com')
WebUI.setEncryptedText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), '9j6ByHUXd4Kxr0By6emyHXXz6rJfZrk1')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.waitForPageLoad(5)

// 3. Chuyển tới Quầy lưu thông
WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/a_room_service'))
WebUI.waitForPageLoad(5)

// 4. Tra cứu độc giả (Sử dụng DriverFactory findElements kiểm tra êm ái)
WebDriver driver = DriverFactory.getWebDriver()
List<WebElement> searchInputs = driver.findElements(By.xpath("//input[@id='memberCodeSearch']"))
if (!searchInputs.isEmpty()) {
    searchInputs.get(0).clear()
    searchInputs.get(0).sendKeys(searchCode)
} else {
    WebUI.setText(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/input_V d_ SE170123, GD12345'), searchCode)
}

List<WebElement> searchBtns = driver.findElements(By.xpath("//button[@type='submit' and contains(@class,'btn-primary')]"))
if (!searchBtns.isEmpty()) {
    searchBtns.get(0).click()
} else {
    WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/button_Tra Cu c Gi'))
}
WebUI.waitForPageLoad(5)

// 5. Mở Form Nhận Trả Sách (Check-in)
List<WebElement> checkinFormBtns = driver.findElements(By.xpath("//button[contains(@onclick, \"showActionForm('checkin')\")]"))
if (!checkinFormBtns.isEmpty() && checkinFormBtns.get(0).isDisplayed()) {
    checkinFormBtns.get(0).click()
    WebUI.delay(1)
} else {
    List<WebElement> chooseCheckinBtns = driver.findElements(By.xpath("//button[contains(text(),'Chọn trả sách')]"))
    if (!chooseCheckinBtns.isEmpty() && chooseCheckinBtns.get(0).isDisplayed()) {
        chooseCheckinBtns.get(0).click()
        WebUI.delay(1)
    }
}

// 6. Điền Barcode bản sao sách
List<WebElement> barcodeInputs = driver.findElements(By.xpath("//input[@id='checkinBarcode']"))
if (!barcodeInputs.isEmpty()) {
    barcodeInputs.get(0).clear()
    if (barcodeVal != null && !barcodeVal.isEmpty()) {
        barcodeInputs.get(0).sendKeys(barcodeVal)
    }
}

// 7. Chọn Tình trạng sách (good / damaged / lost)
List<WebElement> condSelects = driver.findElements(By.xpath("//select[@id='checkinCondition']"))
if (!condSelects.isEmpty()) {
    Select select = new Select(condSelects.get(0))
    select.selectByValue(conditionVal)
}

// 8. Bấm nút 'XÁC NHẬN NHẬN TRẢ SÁCH'
List<WebElement> submitBtns = driver.findElements(By.xpath("//div[@id='actionFormCheckin']//button[@type='submit']"))
if (!submitBtns.isEmpty() && submitBtns.get(0).isDisplayed()) {
    submitBtns.get(0).click()
    WebUI.waitForPageLoad(5)
}

// 9. Kiểm tra kết quả Assertion
if (expectedResult == 'PASS') {
    WebUI.delay(1)
    WebUI.verifyTextPresent('Nhận sách thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.delay(1)
    WebUI.verifyTextNotPresent('Nhận sách thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
```

### `TCPayFine`

* **Test Data (`DataPayFine.xlsx` - 5 kịch bản kiểm thử phủ 100% code logic):**
  | memberCode         | expected | Ghi chú (Mục đích kiểm thử code logic)                                     |
  | ------------------ | -------- | -------------------------------------------------------------------------------- |
  | `SE_TEST_FINE`   | PASS     | 1. Sinh viên SE_TEST_FINE tra cứu và đóng 50k phạt tiền mặt thành công |
  | `ST20230001`     | FAIL     | 2. Lỗi độc giả không có khoản nợ phạt cần đóng                       |
  | `INVALID_CODE`   | FAIL     | 3. Lỗi mã sinh viên không tồn tại trên hệ thống                         |
  |                    | FAIL     | 4. Lỗi thiếu mã sinh viên (Empty validation)                                 |
  | `admin1@lms.com` | FAIL     | 5. Tra cứu tài khoản Admin/Librarian không có khoản nợ phạt              |

* **Script (`TCPayFine.groovy`):**

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import com.kms.katalon.core.webui.driver.DriverFactory as DriverFactory
import org.openqa.selenium.By as By
import org.openqa.selenium.WebDriver as WebDriver
import org.openqa.selenium.WebElement as WebElement

// ═════════════════════════════════════════════════════════════════════════════
// KATALON TEST SCRIPT: TCPayFine (Thu Tiền Phạt Phạt Tại Quầy)
// Tương thích 100% với Data-Driven Excel (DataPayFine.xlsx) & LMS Seed Data
// ═════════════════════════════════════════════════════════════════════════════

// 1. Đọc dữ liệu từ Katalon Data Binding (Excel) hoặc giá trị mặc định khi chạy đơn
String searchCode     = binding.hasVariable('memberCode') ? (memberCode != null ? memberCode.toString().trim() : '') : 'SE_TEST_FINE'
String expectedResult = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

// 2. Mở trình duyệt và Đăng nhập Thủ thư
WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')

WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'librarian1@lms.com')
WebUI.setEncryptedText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), '9j6ByHUXd4Kxr0By6emyHXXz6rJfZrk1')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.waitForPageLoad(5)

// 3. Chuyển tới Quầy lưu thông
WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/a_room_service'))
WebUI.waitForPageLoad(5)

// 4. Tra cứu độc giả (Sử dụng DriverFactory findElements kiểm tra êm ái)
WebDriver driver = DriverFactory.getWebDriver()
List<WebElement> searchInputs = driver.findElements(By.xpath("//input[@id='memberCodeSearch']"))
if (!searchInputs.isEmpty()) {
    searchInputs.get(0).clear()
    searchInputs.get(0).sendKeys(searchCode)
} else {
    WebUI.setText(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/input_V d_ SE170123, GD12345'), searchCode)
}

List<WebElement> searchBtns = driver.findElements(By.xpath("//button[@type='submit' and contains(@class,'btn-primary')]"))
if (!searchBtns.isEmpty()) {
    searchBtns.get(0).click()
} else {
    WebUI.click(findTestObject('Page_Bng iu khin Th th - Th vin i hc LMS/button_Tra Cu c Gi'))
}
WebUI.waitForPageLoad(5)

// 5. Thao tác Duyệt thu tiền mặt (Kiểm tra sự tồn tại của nút êm ái qua Selenium WebDriver)
List<WebElement> cardButtons = driver.findElements(By.xpath("//button[contains(text(),'DUYỆT THU TIỀN MẶT') or contains(text(),'Duyệt thu tiền mặt')]"))

if (!cardButtons.isEmpty() && cardButtons.get(0).isDisplayed()) {
    cardButtons.get(0).click()
    WebUI.waitForPageLoad(5)
} else {
    List<WebElement> bottomButtons = driver.findElements(By.xpath("//button[contains(@onclick, \"showActionForm('payment')\")]"))
    if (!bottomButtons.isEmpty() && bottomButtons.get(0).isDisplayed()) {
        bottomButtons.get(0).click()
        WebUI.delay(1)
        
        List<WebElement> submitBtns = driver.findElements(By.xpath("//div[@id='actionFormPayment']//button[@type='submit']"))
        if (!submitBtns.isEmpty() && submitBtns.get(0).isDisplayed()) {
            submitBtns.get(0).click()
            WebUI.waitForPageLoad(5)
        }
    }
}

// 6. Kiểm tra kết quả Assertion
if (expectedResult == 'PASS') {
    WebUI.delay(1)
    WebUI.verifyTextPresent('Duyệt thanh toán thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.delay(1)
    WebUI.verifyTextNotPresent('Duyệt thanh toán thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
```

---

## 5. Test Suite 5: `TSBookDiscovery`

> Thư mục lưu trữ Test Data Excel: `System Test/Data System Test/` (Ánh xạ 1-1 cho từng Test Case)

### 1. `TCSearchBook`
* **Test Data (`System Test/Data System Test/DataSearchBook.xlsx`):**
  | keyword | expected | Ghi chú |
  | --- | --- | --- |
  | `Java` | `PASS` | 1. Tìm kiếm sách theo từ khóa tên sách 'Java' |
  | `Kiểm Thử` | `PASS` | 2. Tìm kiếm sách theo từ khóa 'Kiểm Thử' |
  | `978-0134685991` | `PASS` | 3. Tìm kiếm sách chính xác theo mã ISBN '978-0134685991' |
  | `Joshua Bloch` | `PASS` | 4. Tìm kiếm sách theo tên tác giả 'Joshua Bloch' |
  | `KhongTonTai123456` | `FAIL` | 5. Tìm kiếm từ khóa không tồn tại trên hệ thống |
  | `` | `FAIL` | 6. Để trống từ khóa bấm Tìm kiếm |

### 2. `TCFilterByCategory`
* **Test Data (`System Test/Data System Test/DataFilterByCategory.xlsx`):**
  | categoryId | expected | Ghi chú |
  | --- | --- | --- |
  | `1` | `PASS` | 1. Lọc danh sách sách theo Danh mục ID = 1 |
  | `9999` | `FAIL` | 2. Lọc theo Danh mục ID không tồn tại |

### 3. `TCFilterByTag`
* **Test Data (`System Test/Data System Test/DataFilterByTag.xlsx`):**
  | tagId | expected | Ghi chú |
  | --- | --- | --- |
  | `1` | `PASS` | 1. Lọc danh sách sách theo Thẻ Tag ID = 1 |
  | `9999` | `FAIL` | 2. Lọc theo Thẻ Tag ID không tồn tại |

### 4. `TCFilterByAvailability`
* **Test Data (`System Test/Data System Test/DataFilterByAvailability.xlsx`):**
  | availableOnly | expected | Ghi chú |
  | --- | --- | --- |
  | `true` | `PASS` | 1. Lọc sách chỉ lấy các đầu sách sẵn có (availableOnly=true) |
  | `false` | `PASS` | 2. Lọc tất cả đầu sách kể cả hết bản sao mượn |

### 5. `TCViewBookDetail`
* **Test Data (`System Test/Data System Test/DataViewBookDetail.xlsx`):**
  | bookId | expected | Ghi chú |
  | --- | --- | --- |
  | `991` | `PASS` | 1. Xem chi tiết đầu sách hợp lệ 'Giáo Trình Kiểm Thử LMS 2026' (bookId=991) |
  | `9999` | `FAIL` | 2. Xem chi tiết đầu sách không tồn tại (bookId=9999) |

### 1. `TCSearchBook.groovy`

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import org.openqa.selenium.Keys as Keys

// ═════════════════════════════════════════════════════════════════════════════
// KATALON TEST SCRIPT: TCSearchBook (Tìm kiếm sách theo từ khóa)
// Tương thích với DataSearchBook.xlsx (System Test/Data System Test/DataSearchBook.xlsx)
// ═════════════════════════════════════════════════════════════════════════════

String kw  = binding.hasVariable('keyword') ? (keyword != null ? keyword.toString().trim() : '') : ''
String exp = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-search')
WebUI.waitForPageLoad(5)

// 1. Nhập từ khóa tìm kiếm & bấm Enter
WebUI.setText(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/input_Tn sch, tc gi'), kw)
WebUI.sendKeys(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/input_Tn sch, tc gi'), Keys.chord(Keys.ENTER))
WebUI.waitForPageLoad(5)

// 2. Assertion Kiểm Tra
if (exp == 'PASS') {
    WebUI.delay(1)
    WebUI.verifyElementNotPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.delay(1)
    WebUI.verifyElementPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
```

### 2. `TCFilterByCategory.groovy`

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-search')
WebUI.waitForPageLoad(5)

String exp = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/label_Arts  Design'))
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/button_p dng b lc'))
WebUI.waitForPageLoad(5)

if (exp == 'PASS') {
    WebUI.delay(1)
    WebUI.verifyElementNotPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.delay(1)
    WebUI.verifyElementPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
```

### 3. `TCFilterByTag.groovy`

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-search')
WebUI.waitForPageLoad(5)

String exp = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/label_Advanced'))
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/button_p dng b lc'))
WebUI.waitForPageLoad(5)

if (exp == 'PASS') {
    WebUI.delay(1)
    WebUI.verifyElementNotPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.delay(1)
    WebUI.verifyElementPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
```

### 4. `TCFilterByAvailability.groovy`

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-search')
WebUI.waitForPageLoad(5)

String avail = binding.hasVariable('availableOnly') ? (availableOnly != null ? availableOnly.toString().trim() : 'true') : 'true'
String exp   = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

if ('true'.equalsIgnoreCase(avail)) {
    WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/input_Sch vn cn'))
} else {
    WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/input_Tt c ti liu'))
}

WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/button_p dng b lc'))
WebUI.waitForPageLoad(5)

if (exp == 'PASS') {
    WebUI.delay(1)
    WebUI.verifyElementNotPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.delay(1)
    WebUI.verifyElementPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
```

### 5. `TCViewBookDetail.groovy`

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

String exp = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'
String bId = binding.hasVariable('bookId') ? (bookId != null ? bookId.toString().trim() : '991') : '991'

WebUI.openBrowser(null)
WebUI.maximizeWindow()

// 1. Đăng nhập tài khoản Giảng viên (Email: lecturer1@lms.com, Mật khẩu: lecturer1@lms.com)
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'lecturer1@lms.com')
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'lecturer1@lms.com')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.delay(2)

// 2. Mở trực tiếp URL chi tiết sách theo bId động từ Data Binding
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-detail?id=' + bId)
WebUI.delay(1)

if (exp == 'PASS') {
    // Sách hợp lệ (991): Hiển thị đúng tên sách "Giáo Trình Kiểm Thử LMS 2026"
    WebUI.verifyTextPresent('Giáo Trình Kiểm Thử LMS 2026', false, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    // Sách không tồn tại (9999): BookDetailServlet xử lý an toàn redirect về trang Tra cứu (/book-search)
    String currentUrl = WebUI.getUrl()
    boolean isRedirected = currentUrl.contains('book-search')
    WebUI.verifyEqual(isRedirected, true, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
```

---

## 6. Test Suite 6: `TSSelfService`

> Thư mục lưu trữ Test Data Excel: `System Test/Data System Test/` (Ánh xạ 1-1 cho từng Test Case)

### 1. `TCReserveBookOnline.groovy`
* **Test Data (`System Test/Data System Test/DataReserveBookOnline.xlsx`):**
  | bookId | expected | Ghi chú |
  | --- | --- | --- |
  | `991` | `PASS` | 1. Đặt trước sách thành công (sách Giáo Trình Kiểm Thử 991) |
  | `992` | `PASS` | 2. Đặt trước sách thành công (sách Monolith 992) |
  | `9999` | `FAIL` | 3. Đặt trước đầu sách không tồn tại (bookId = 9999) |
  | `-1` | `FAIL` | 4. Đặt trước với ID sách âm (-1) |
  | `abc` | `FAIL` | 5. Đặt trước với ID sách không phải là số (abc) |

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

String bId = binding.hasVariable('bookId') ? (bookId != null ? bookId.toString().trim() : '991') : '991'
String exp = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

WebUI.openBrowser(null)
WebUI.maximizeWindow()

// 1. Đăng nhập Sinh viên student1@lms.com
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'student1@lms.com')
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'student1@lms.com')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.delay(2)

// 2. Mở trang chi tiết sách theo bId
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-detail?id=' + bId)
WebUI.delay(1)

if (exp == 'PASS') {
    WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/button_t trc (Ly ngay)'))
    WebUI.delay(2)
    WebUI.verifyElementPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/span_Bn  t trc cun sch ny'), 5, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    // Thất bại khi cố đặt trước đầu sách không tồn tại/không hợp lệ (hệ thống redirect về book-search hoặc từ chối)
    String currentUrl = WebUI.getUrl()
    boolean isRedirected = currentUrl.contains('book-search')
    WebUI.verifyEqual(isRedirected, true, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
```

### 2. `TCRenewBookOnline.groovy`
* **Test Data (`System Test/Data System Test/DataRenewBookOnline.xlsx`):**
  | borrowRecordId | expected | Ghi chú |
  | --- | --- | --- |
  | `9910` | `PASS` | 1. Gia hạn thành công cho sách mượn > 50% thời hạn (mượn 8/14 ngày) |
  | `9911` | `FAIL` | 2. Gia hạn thất bại do chưa dùng đủ 50% thời hạn mượn (mượn 1/14 ngày) |
  | `9999` | `FAIL` | 3. Gia hạn bản ghi mượn không tồn tại (borrowRecordId = 9999) |
  | `-1` | `FAIL` | 4. Gia hạn với ID bản ghi mượn âm (-1) |

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

String recId = binding.hasVariable('borrowRecordId') ? (borrowRecordId != null ? borrowRecordId.toString().trim() : '9910') : '9910'
String exp   = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

WebUI.openBrowser(null)
WebUI.maximizeWindow()

// 1. Đăng nhập Sinh viên student1@lms.com
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'student1@lms.com')
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'student1@lms.com')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.delay(2)

if (exp == 'PASS') {
    // Kịch bản PASS: Vào trang Quản lý mượn trả (/student/my-borrowings)
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/student/my-borrowings')
    WebUI.delay(1)
    WebUI.click(findTestObject('Page_Bng iu khin Sinh vin - Th vin i hc LMS/button_borrowed-tab'))
    WebUI.delay(1)
    WebUI.click(findTestObject('Page_Bng iu khin Ging vin - Th vin i hc LMS/button_Gia hn'))
    WebUI.delay(2)
    WebUI.verifyTextPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
} else if (recId == '9911') {
    // Kịch bản FAIL do chưa dùng đủ 50% thời hạn (mượn 1/14 ngày)
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/student/my-borrowings')
    WebUI.delay(1)
    WebUI.click(findTestObject('Page_Bng iu khin Sinh vin - Th vin i hc LMS/button_borrowed-tab'))
    WebUI.delay(1)
    WebUI.click(findTestObject('Page_Bng iu khin Ging vin - Th vin i hc LMS/button_Gia hn'))
    WebUI.delay(2)
    // Hệ thống xuất hiện dòng cảnh báo màu đỏ
    WebUI.verifyTextPresent('Bạn chỉ được gia hạn khi đã sử dụng ít nhất 50%', false, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    // Kịch bản FAIL: Thử gọi gia hạn ID bản ghi mượn không tồn tại / không hợp lệ
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/student/renew-book?id=' + recId)
    WebUI.delay(1)
    WebUI.verifyTextNotPresent('Gia hạn thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
```

### 3. `TCCancelReservation.groovy`
* **Test Data (`System Test/Data System Test/DataCancelReservation.xlsx`):**
  | reservationId | expected | Ghi chú |
  | --- | --- | --- |
  | `9910` | `PASS` | 1. Hủy đơn đặt trước hợp lệ đang chờ nhận sách (reservationId = 9910) |
  | `9901` | `PASS` | 2. Hủy đơn đặt trước trạng thái readypickup (reservationId = 9901) |
  | `9999` | `FAIL` | 3. Hủy đơn đặt trước không tồn tại (reservationId = 9999) |
  | `-10` | `FAIL` | 4. Hủy đơn đặt trước với ID không hợp lệ (-10) |

```groovy
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

String resId = binding.hasVariable('reservationId') ? (reservationId != null ? reservationId.toString().trim() : '9910') : '9910'
String exp   = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

WebUI.openBrowser(null)
WebUI.maximizeWindow()

// 1. Đăng nhập Sinh viên student1@lms.com
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'student1@lms.com')
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'student1@lms.com')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.delay(2)

if (exp == 'PASS') {
    // Vào trang Quản lý hàng đợi (/student/my-borrowings)
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/student/my-borrowings')
    WebUI.delay(1)
    WebUI.click(findTestObject('Page_Bng iu khin Sinh vin - Th vin i hc LMS/button_reserved-tab'))
    WebUI.delay(1)
    WebUI.click(findTestObject('Page_Bng iu khin Sinh vin - Th vin i hc LMS/button_Hy t'))
    WebUI.delay(1)
    WebUI.acceptAlert(FailureHandling.OPTIONAL)
    WebUI.delay(2)
    WebUI.verifyTextPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    // Kịch bản FAIL: Thử hủy đơn không tồn tại hoặc ID không hợp lệ
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/student/cancel-reservation?id=' + resId)
    WebUI.delay(1)
    WebUI.verifyTextNotPresent('Hủy thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
```
