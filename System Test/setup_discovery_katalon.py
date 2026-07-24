import os
import uuid

KATALON_BASE = r"c:\Users\lethe\Katalon Studio\LMS System Test"
SYSTEM_TEST_DATA = "D:/Data/NetBeansIDE17/LMS-Library_Management_System/System Test/Data System Test"

# 1. Create .dat files in Data Files
data_files = [
    ("DataSearchBook", "DataSearchBook.xlsx"),
    ("DataFilterByCategory", "DataFilterByCategory.xlsx"),
    ("DataFilterByTag", "DataFilterByTag.xlsx"),
    ("DataFilterByAvailability", "DataFilterByAvailability.xlsx"),
    ("DataViewBookDetail", "DataViewBookDetail.xlsx")
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

# 2. Create Test Cases (.tc) in Test Cases/Discovery
tc_definitions = [
    ("TCSearchBook", "DataSearchBook", [("keyword", "d501"), ("expected", "d502")]),
    ("TCFilterByCategory", "DataFilterByCategory", [("categoryId", "d503"), ("expected", "d504")]),
    ("TCFilterByTag", "DataFilterByTag", [("tagId", "d505"), ("expected", "d506")]),
    ("TCFilterByAvailability", "DataFilterByAvailability", [("availableOnly", "d507"), ("expected", "d508")]),
    ("TCViewBookDetail", "DataViewBookDetail", [("bookId", "d509"), ("expected", "d510")])
]

tc_dir = os.path.join(KATALON_BASE, "Test Cases", "Discovery")
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
   <tag>Discovery,TS5</tag>
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

# 3. Create Groovy Scripts in Scripts/Discovery/
groovy_scripts = {
    "TCSearchBook": """import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import org.openqa.selenium.Keys as Keys

String kw  = binding.hasVariable('keyword') ? (keyword != null ? keyword.toString().trim() : '') : ''
String exp = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

WebUI.openBrowser(null)
WebUI.maximizeWindow()
WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-search')
WebUI.waitForPageLoad(5)

WebUI.setText(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/input_Tn sch, tc gi'), kw)
WebUI.sendKeys(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/input_Tn sch, tc gi'), Keys.chord(Keys.ENTER))
WebUI.waitForPageLoad(5)

if (exp == 'PASS') {
    WebUI.delay(1)
    WebUI.verifyElementNotPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.delay(1)
    WebUI.verifyElementPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
""",

    "TCFilterByCategory": """import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

String catId = binding.hasVariable('categoryId') ? (categoryId != null ? categoryId.toString().trim() : '') : ''
String exp   = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

WebUI.openBrowser(null)
WebUI.maximizeWindow()

if (exp == 'PASS') {
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-search')
    WebUI.waitForPageLoad(5)
    WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/label_Arts  Design'))
    WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/button_p dng b lc'))
    WebUI.waitForPageLoad(5)
    WebUI.verifyElementNotPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-search?categoryId=' + catId)
    WebUI.waitForPageLoad(5)
    WebUI.verifyElementPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
""",

    "TCFilterByTag": """import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

String tagIdVal = binding.hasVariable('tagId') ? (tagId != null ? tagId.toString().trim() : '') : ''
String exp      = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'

WebUI.openBrowser(null)
WebUI.maximizeWindow()

if (exp == 'PASS') {
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-search')
    WebUI.waitForPageLoad(5)
    WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/label_Advanced'))
    WebUI.click(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/button_p dng b lc'))
    WebUI.waitForPageLoad(5)
    WebUI.verifyElementNotPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
} else {
    WebUI.navigateToUrl('http://localhost:8888/LMS-Library_Management_System/book-search?tagId=' + tagIdVal)
    WebUI.waitForPageLoad(5)
    WebUI.verifyElementPresent(findTestObject('Page_UniLib LMS - Cng thng tin Th vin i hc/h4_Khng tm thy'), 3, FailureHandling.CONTINUE_ON_FAILURE)
}

WebUI.closeBrowser()
""",

    "TCFilterByAvailability": """import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
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
""",

    "TCViewBookDetail": """import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling

String exp = binding.hasVariable('expected') ? (expected != null ? expected.toString().trim().toUpperCase() : 'PASS') : 'PASS'
String bId = binding.hasVariable('bookId') ? (bookId != null ? bookId.toString().trim() : '991') : '991'

WebUI.openBrowser(null)
WebUI.maximizeWindow()

// 1. Đăng nhập tài khoản Giảng viên (Email: lecturer1@lms.com, Password: lecturer1@lms.com)
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
"""
}

ts_script_dir = os.path.join(KATALON_BASE, "Scripts", "Discovery")
os.makedirs(ts_script_dir, exist_ok=True)

for tc_name, script_code in groovy_scripts.items():
    script_sub_dir = os.path.join(ts_script_dir, tc_name)
    os.makedirs(script_sub_dir, exist_ok=True)
    script_path = os.path.join(script_sub_dir, f"Script1784800000000.groovy")
    with open(script_path, "w", encoding="utf-8") as f:
        f.write(script_code)
    print(f"Created {script_path}")

# 4. Create TSBookDiscovery.ts and TSBookDiscovery.groovy in Test Suites/
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
      <testCaseId>Test Cases/Discovery/{tc_name}</testCaseId>
      <usingDataBindingAtTestSuiteLevel>false</usingDataBindingAtTestSuiteLevel>
{var_links_str.rstrip()}
   </testCaseLink>\n"""

ts_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<TestSuiteEntity>
   <description>Tra cứu &amp; Khám phá Kho Sách (Search, Category, Tag, Availability, View Detail)</description>
   <name>TSBookDiscovery</name>
   <tag>Discovery,TS5</tag>
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

ts_file_path = os.path.join(KATALON_BASE, "Test Suites", "TSBookDiscovery.ts")
with open(ts_file_path, "w", encoding="utf-8") as f:
    f.write(ts_xml)
print(f"Created {ts_file_path}")

ts_groovy_path = os.path.join(KATALON_BASE, "Test Suites", "TSBookDiscovery.groovy")
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

print("Successfully set up TSBookDiscovery in Katalon Studio!")
