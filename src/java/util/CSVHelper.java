package util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import model.UserDTO;

/**
 * CSVHelper — Lớp tiện ích hỗ trợ đọc và phân tích file CSV người dùng.
 */
public class CSVHelper {

    /**
     * Phân tích luồng đầu vào của file CSV thành danh sách UserDTO.
     * Tự động phát hiện dấu phân tách (dấu phẩy ',' hoặc dấu chấm phẩy ';').
     *
     * @param is Luồng đầu vào của tệp CSV
     * @return Danh sách các UserDTO được phân tích từ tệp
     * @throws Exception nếu xảy ra lỗi đọc file
     */
    public static List<UserDTO> parseCSV(InputStream is) throws Exception {
        List<UserDTO> list = new ArrayList<>();
        
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String headerLine = reader.readLine();
            if (headerLine == null) {
                return list; // File rỗng
            }
            
            // Xử lý BOM (Byte Order Mark) nếu có ở file UTF-8
            if (headerLine.startsWith("\uFEFF")) {
                headerLine = headerLine.substring(1);
            }
            
            // Tự động phát hiện delimiter dựa vào số lượng xuất hiện trong dòng tiêu đề
            String delimiter = ",";
            int commaCount = countOccurrences(headerLine, ",");
            int semicolonCount = countOccurrences(headerLine, ";");
            if (semicolonCount > commaCount) {
                delimiter = ";";
            }
            
            String line;
            int lineNumber = 1; // Dòng tiêu đề là dòng 1, dữ liệu bắt đầu từ dòng 2
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                if (line.trim().isEmpty()) {
                    continue; // Bỏ qua dòng trống
                }
                
                // Cắt chuỗi theo delimiter, hỗ trợ cả các trường trống ở cuối
                String[] tokens = line.split(delimiter, -1);
                
                // Yêu cầu tối thiểu phải có 6 cột: Email, Họ tên, SĐT, Giới tính, Ngày sinh, Mã số
                if (tokens.length < 6) {
                    throw new Exception("Lỗi định dạng dòng " + lineNumber + ": Không đủ cột dữ liệu tối thiểu (yêu cầu ít nhất 6 cột).");
                }
                
                UserDTO dto = new UserDTO();
                dto.setEmail(cleanToken(tokens[0]));
                dto.setFullName(cleanToken(tokens[1]));
                dto.setPhoneNumber(cleanToken(tokens[2]));
                dto.setGender(cleanToken(tokens[3]));
                
                // Parse DateOfBirth
                String dobStr = cleanToken(tokens[4]);
                if (dobStr != null && !dobStr.isEmpty()) {
                    try {
                        java.util.Date parsed = sdf.parse(dobStr);
                        dto.setDateOfBirth(new Date(parsed.getTime()));
                    } catch (Exception e) {
                        // Gán tạm null để Service validate ném lỗi chi tiết
                        dto.setDateOfBirth(null);
                    }
                }
                
                dto.setCode(cleanToken(tokens[5]));
                
                // Các trường tùy chọn
                if (tokens.length > 6) {
                    String info1 = cleanToken(tokens[6]);
                    dto.setMajor(info1);      // Dành cho Student
                    dto.setDepartment(info1); // Dành cho Lecturer
                }
                
                if (tokens.length > 7) {
                    String info2 = cleanToken(tokens[7]);
                    if (info2 != null && !info2.isEmpty()) {
                        try {
                            dto.setEnrollmentYear(Integer.parseInt(info2));
                        } catch (NumberFormatException e) {
                            dto.setEnrollmentYear(null);
                        }
                    }
                }
                
                list.add(dto);
            }
        }
        
        return list;
    }

    private static int countOccurrences(String str, String target) {
        int count = 0;
        int idx = 0;
        while ((idx = str.indexOf(target, idx)) != -1) {
            count++;
            idx += target.length();
        }
        return count;
    }

    private static String cleanToken(String token) {
        if (token == null) return "";
        // Loại bỏ khoảng trắng và dấu ngoặc kép bọc ngoài (nếu có)
        String cleaned = token.trim();
        if (cleaned.startsWith("\"") && cleaned.endsWith("\"") && cleaned.length() >= 2) {
            cleaned = cleaned.substring(1, cleaned.length() - 1).trim();
        }
        return cleaned;
    }
}
