import os
import uuid

KATALON_BASE = r"c:\Users\lethe\Katalon Studio\LMS System Test"
SYSTEM_TEST_DATA = "D:/Data/NetBeansIDE17/LMS-Library_Management_System/System Test/Data System Test"

# 1. Create .dat files in Data Files
data_files = [
    ("DataReserveBookOnline", "DataReserveBookOnline.xlsx"),
    ("DataRenewBookOnline", "DataRenewBookOnline.xlsx"),
    ("DataCancelReservation", "DataCancelReservation.xlsx")
]

for dat_name, excel_name in data_files:
    guid = str(uuid.uuid4())
    dat_content = f"""<?xml version="1.0" encoding="UTF-8"?>
<DataFileEntity>
   <description></description>
   <name>{dat_name}</name>
   <tag></tag>
   <connectionProperties/>
   <containsHeaders>true</containsHeaders>
   <csvSeperator></csvSeperator>
   <dataFileGUID>{guid}</dataFileGUID>
   <dataSourceUrl>{SYSTEM_TEST_DATA}/{excel_name}</dataSourceUrl>
   <driver>ExcelFile</driver>
   <isInternalPath>true</isInternalPath>
   <query></query>
   <secureUserAccount>false</secureUserAccount>
   <sheetName>Sheet1</sheetName>
   <usingGlobalDBSetting>false</usingGlobalDBSetting>
</DataFileEntity>
"""
    dat_path = os.path.join(KATALON_BASE, "Data Files", f"{dat_name}.dat")
    with open(dat_path, "w", encoding="utf-8") as f:
        f.write(dat_content)
    print(f"Created {dat_path}")

# 2. Create Test Cases (.tc) in Test Cases/SelfService
tc_definitions = [
    ("TCReserveBookOnline", "DataReserveBookOnline", [("bookId", "d601"), ("expected", "d602")]),
    ("TCRenewBookOnline", "DataRenewBookOnline", [("borrowRecordId", "d603"), ("expected", "d604")]),
    ("TCCancelReservation", "DataCancelReservation", [("reservationId", "d605"), ("expected", "d606")])
]

tc_dir = os.path.join(KATALON_BASE, "Test Cases", "SelfService")
os.makedirs(tc_dir, exist_ok=True)

tc_guids = {}
tc_var_ids = {}
data_link_ids = {}

for tc_name, dat_name, vars_list in tc_definitions:
    tc_guid = str(uuid.uuid4())
    link_id = str(uuid.uuid4())
    tc_guids[tc_name] = tc_guid
    data_link_ids[tc_name] = link_id
    tc_var_ids[tc_name] = {}

    var_links_xml = ""
    vars_xml = ""

    for var_name, prefix in vars_list:
        var_id = f"{prefix}0000-0000-0000-0000-000000000000"
        tc_var_ids[tc_name][var_name] = var_id

        var_links_xml += f"""   <variableLinks>
      <testDataLinkId>{link_id}</testDataLinkId>
      <type>DATA_COLUMN</type>
      <value>{var_name}</value>
      <variableId>{var_id}</variableId>
   </variableLinks>\n"""

        vars_xml += f"""   <variable>
      <defaultValue>''</defaultValue>
      <description></description>
      <id>{var_id}</id>
      <masked>false</masked>
      <name>{var_name}</name>
   </variable>\n"""

    tc_content = f"""<?xml version="1.0" encoding="UTF-8"?>
<TestCaseEntity>
   <description>{tc_name}</description>
   <name>{tc_name}</name>
   <tag>SelfService,TS6</tag>
   <comment></comment>
   <recordOption>OTHER</recordOption>
   <testCaseGuid>{tc_guid}</testCaseGuid>
   <testDataLinks>
      <combinationType>ONE</combinationType>
      <id>{link_id}</id>
      <iterationEntity>
         <iterationType>ALL</iterationType>
         <value></value>
      </iterationEntity>
      <testDataId>Data Files/{dat_name}</testDataId>
   </testDataLinks>
{var_links_xml.rstrip()}
{vars_xml.rstrip()}
</TestCaseEntity>
"""
    tc_path = os.path.join(tc_dir, f"{tc_name}.tc")
    with open(tc_path, "w", encoding="utf-8") as f:
        f.write(tc_content)
    print(f"Created {tc_path}")

# 3. Create Groovy Scripts in Scripts/SelfService/
groovy_scripts = {
    "TCReserveBookOnline": """import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

String bId = binding.hasVariable('bookId') ? (bookId != null ? bookId.toString().trim() : '993') : '993'
String exp = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

WebUI.openBrowser(null)
WebUI.maximizeWindow()

// 1. Đăng nhập Giảng viên lecturer1@lms.com
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'lecturer1@lms.com')
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'lecturer1@lms.com')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.delay(2)

// 2. Mở trực tiếp URL chi tiết sách theo bId
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-detail?id=' + bId)
WebUI.delay(1)

if (exp == 'PASS') {
    if (bId == '991') {
        // Sách 991: Giảng viên đang mượn
        WebUI.verifyTextPresent('cuốn sách này', false, FailureHandling.CONTINUE_ON_FAILURE)
    } else if (bId == '992') {
        // Sách 992: Giảng viên đã đặt trước
        WebUI.verifyTextPresent('cuốn sách này', false, FailureHandling.CONTINUE_ON_FAILURE)
    } else {
        // Sách 993: Sách mới chưa mượn/đặt -> Bấm "Đặt trước (Lấy ngay)"
        WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/button_t trc (Ly ngay)'))
        WebUI.delay(2)
        WebUI.verifyTextPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
    }
} else {
    // Sách 9999, -1: Redirect an toàn về book-search
    String currentUrl = WebUI.getUrl()
    boolean isRedirected = currentUrl.contains('book-search')
    WebUI.verifyEqual(isRedirected, true, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
""",

    "TCRenewBookOnline": """import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

String recId = binding.hasVariable('borrowRecordId') ? (borrowRecordId != null ? borrowRecordId.toString().trim() : '9910') : '9910'
String exp   = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

WebUI.openBrowser(null)
WebUI.maximizeWindow()

// 1. Đăng nhập Giảng viên lecturer1@lms.com
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'lecturer1@lms.com')
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'lecturer1@lms.com')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.delay(2)

if (exp == 'PASS') {
    // 2. Mở trang Chi tiết sách 991 -> Bấm "Xem hạn trả & Gia hạn"
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-detail?id=991')
    WebUI.delay(1)
    WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_Xem hn tr  Gia hn'))
    WebUI.delay(1)

    // 3. Sang trang Quản lý mượn trả -> Bấm Tab Sách đang mượn -> Bấm nút Gia hạn
    WebUI.click(findTestObject('Page_Bng iu khin Sinh vin - Th vin i hc LMS/button_borrowed-tab'))
    WebUI.delay(1)
    WebUI.click(findTestObject('Page_Bng iu khin Ging vin - Th vin i hc LMS/button_Gia hn'))
    WebUI.delay(2)
    WebUI.verifyTextPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
} else if (recId == '9911') {
    // Kịch bản FAIL do chưa dùng đủ 50% thời hạn (mượn 1/30 ngày)
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/lecturer/my-borrowings')
    WebUI.delay(1)
    WebUI.click(findTestObject('Page_Bng iu khin Sinh vin - Th vin i hc LMS/button_borrowed-tab'))
    WebUI.delay(1)
    WebUI.click(findTestObject('Page_Bng iu khin Ging vin - Th vin i hc LMS/button_Gia hn'))
    WebUI.delay(2)
    WebUI.verifyTextPresent('50%', false, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    // Kịch bản FAIL: Thử gọi gia hạn ID không tồn tại
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/lecturer/renew-book?id=' + recId)
    WebUI.delay(1)
    WebUI.verifyTextNotPresent('Gia hạn thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
""",

    "TCCancelReservation": """import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

String resId = binding.hasVariable('reservationId') ? (reservationId != null ? reservationId.toString().trim() : '9910') : '9910'
String exp   = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

WebUI.openBrowser(null)
WebUI.maximizeWindow()

// 1. Đăng nhập Giảng viên lecturer1@lms.com
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/')
WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/a_ng nhp'))
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_librarianlumina.edu'), 'lecturer1@lms.com')
WebUI.setText(findTestObject('Page_Th vin Lumina - ng nhp/input_'), 'lecturer1@lms.com')
WebUI.click(findTestObject('Page_Th vin Lumina - ng nhp/button_ng nhp'))
WebUI.delay(2)

if (exp == 'PASS') {
    // Vào trang Quản lý hàng đợi của Giảng viên (/lecturer/my-borrowings)
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/lecturer/my-borrowings')
    WebUI.delay(1)
    WebUI.click(findTestObject('Page_Bng iu khin Sinh vin - Th vin i hc LMS/button_reserved-tab'))
    WebUI.delay(1)
    WebUI.click(findTestObject('Page_Bng iu khin Sinh vin - Th vin i hc LMS/button_Hy t'))
    WebUI.delay(1)
    WebUI.acceptAlert(FailureHandling.OPTIONAL)
    WebUI.delay(2)
    WebUI.verifyTextPresent('thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    // Kịch bản FAIL: Thử hủy đơn không tồn tại
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/lecturer/cancel-reservation?id=' + resId)
    WebUI.delay(1)
    WebUI.verifyTextNotPresent('Hủy thành công', false, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
"""
}

ts_script_dir = os.path.join(KATALON_BASE, "Scripts", "SelfService")
os.makedirs(ts_script_dir, exist_ok=True)

for tc_name, script_code in groovy_scripts.items():
    script_sub_dir = os.path.join(ts_script_dir, tc_name)
    os.makedirs(script_sub_dir, exist_ok=True)
    script_path = os.path.join(script_sub_dir, f"Script1784800000000.groovy")
    with open(script_path, "w", encoding="utf-8") as f:
        f.write(script_code)
    print(f"Created {script_path}")

# 4. Create TSSelfService.ts and TSSelfService.groovy in Test Suites/
ts_guid = str(uuid.uuid4())
tc_links_xml = ""

for tc_name, dat_name, vars_list in tc_definitions:
    link_guid = str(uuid.uuid4())
    link_id = data_link_ids[tc_name]
    
    var_links_str = ""
    for var_name, _ in vars_list:
        var_id = tc_var_ids[tc_name][var_name]
        var_links_str += f"""      <variableLink>
         <testDataLinkId>{link_id}</testDataLinkId>
         <type>DEFAULT</type>
         <value></value>
         <variableId>{var_id}</variableId>
      </variableLink>\n"""

    tc_links_xml += f"""   <testCaseLink>
      <guid>{link_guid}</guid>
      <isReuseDriver>false</isReuseDriver>
      <isRun>true</isRun>
      <testCaseId>Test Cases/SelfService/{tc_name}</testCaseId>
      <usingDataBindingAtTestSuiteLevel>false</usingDataBindingAtTestSuiteLevel>
{var_links_str.rstrip()}
   </testCaseLink>\n"""

ts_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<TestSuiteEntity>
   <description>Tự phục vụ Độc giả (Đặt trước, Gia hạn, Hủy đặt trước)</description>
   <name>TSSelfService</name>
   <tag>SelfService,TS6</tag>
   <isRerun>false</isRerun>
   <mailRecipient></mailRecipient>
   <numberOfRerun>0</numberOfRerun>
   <pageLoadTimeout>30</pageLoadTimeout>
   <pageLoadTimeoutDefault>true</pageLoadTimeoutDefault>
   <rerunFailedTestCasesOnly>false</rerunFailedTestCasesOnly>
   <rerunImmediately>false</rerunImmediately>
   <testSuiteGuid>{ts_guid}</testSuiteGuid>
{tc_links_xml.rstrip()}
</TestSuiteEntity>
"""

ts_file_path = os.path.join(KATALON_BASE, "Test Suites", "TSSelfService.ts")
with open(ts_file_path, "w", encoding="utf-8") as f:
    f.write(ts_xml)
print(f"Created {ts_file_path}")

ts_groovy_path = os.path.join(KATALON_BASE, "Test Suites", "TSSelfService.groovy")
ts_groovy_code = """import com.kms.katalon.core.annotation.SetUp
import com.kms.katalon.core.annotation.TearDown

@SetUp(skipped = false)
def setUp() {
}

@TearDown(skipped = false)
def tearDown() {
}
"""
with open(ts_groovy_path, "w", encoding="utf-8") as f:
    f.write(ts_groovy_code)
print(f"Created {ts_groovy_path}")

print("Successfully set up TSSelfService in Katalon Studio!")
