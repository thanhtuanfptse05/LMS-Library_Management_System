import os
import re

files = [
    r"d:\Data\NetBeansIDE17\LMS-Library_Management_System\test\f5\F5TestRunner.java",
    r"d:\Data\NetBeansIDE17\LMS-Library_Management_System\test\f6\F6TestRunner.java",
    r"d:\Data\NetBeansIDE17\LMS-Library_Management_System\test\f14\F14TestRunner.java"
]

for filepath in files:
    if not os.path.exists(filepath):
        continue
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Imports
    if 'import org.junit.runner.notification.RunListener;' not in content:
        content = content.replace('import org.junit.runner.notification.Failure;',
                                  'import org.junit.runner.notification.Failure;\nimport org.junit.runner.notification.RunListener;\nimport org.junit.runner.Description;\nimport java.util.ArrayList;\nimport java.util.List;')
    
    # Remove FileWriter
    content = content.replace('import java.io.FileWriter;', '')

    # 2. Add TestDetail inside class
    class_name = os.path.basename(filepath).replace('.java', '')
    if 'static class TestDetail {' not in content:
        injection = f"""public class {class_name} {{

    static class TestDetail {{
        String name;
        boolean passed;
        String errorMsg;
    }}

    static List<TestDetail> testDetails = new ArrayList<>();"""
        content = re.sub(rf'public class {class_name} \{{', injection, content)

    # 3. Add listener logic
    if 'junit.addListener(new RunListener()' not in content:
        listener_code = """JUnitCore junit = new JUnitCore();
        junit.addListener(new RunListener() {
            private TestDetail currentTest;

            @Override
            public void testStarted(Description description) {
                currentTest = new TestDetail();
                currentTest.name = description.getMethodName();
                if (currentTest.name == null) {
                    currentTest.name = description.getDisplayName();
                }
                currentTest.passed = true;
            }

            @Override
            public void testFailure(Failure failure) {
                if (currentTest != null) {
                    currentTest.passed = false;
                    currentTest.errorMsg = failure.getMessage();
                }
            }

            @Override
            public void testFinished(Description description) {
                if (currentTest != null) {
                    testDetails.add(currentTest);
                }
            }
        });"""
        content = content.replace('JUnitCore junit = new JUnitCore();', listener_code)

    # 4. FileWriter to OutputStreamWriter
    content = content.replace('try (FileWriter writer = new FileWriter(mdFile))',
                              'try (java.io.OutputStreamWriter writer = new java.io.OutputStreamWriter(new java.io.FileOutputStream(mdFile), java.nio.charset.StandardCharsets.UTF_8))')

    # 5. Modify the report detail block (remove the if (failures > 0) logic)
    # We will use regex to replace from "if (failures > 0) {" to "} else {" and the following block until "Đã kết xuất báo cáo Markdown thành công tại:"
    
    pattern = r"if \(failures > 0\) \{.*?Đã kết xuất báo cáo Markdown thành công tại:"
    
    new_report_code = """writer.write("\\n## 2. Nhật ký chi tiết từng Test Case\\n\\n");
            writer.write("| STT | Tên Test Case | Trạng thái | Ghi chú / Lỗi |\\n");
            writer.write("| --- | --- | --- | --- |\\n");
            int stt = 1;
            for (TestDetail td : testDetails) {
                String status = td.passed ? "✅ PASS" : "❌ FAIL";
                String note = td.errorMsg != null ? td.errorMsg.replace("\\n", " ").replace("|", "\\\\|") : "OK";
                writer.write(String.format("| %d | `%s` | %s | %s |\\n", stt++, td.name, status, note));
            }

            System.out.println("Đã kết xuất báo cáo Markdown thành công tại:"""
            
    content = re.sub(pattern, new_report_code, content, flags=re.DOTALL)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

print("Updated all TestRunners.")
