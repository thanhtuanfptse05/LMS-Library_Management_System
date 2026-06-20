# ==========================================
# STAGE 1: Xây dựng ứng dụng (Build WAR)
# ==========================================
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app
COPY . .

# 1. Tạo các thư mục cần thiết theo chuẩn Java Web (WAR)
RUN mkdir -p build/web/WEB-INF/classes
RUN mkdir -p build/web/WEB-INF/lib

# 2. Copy toàn bộ giao diện (JSP, CSS, JS) vào thư mục web
RUN cp -r web/* build/web/

# 3. Copy toàn bộ thư viện (JAR) vào thư mục lib
RUN cp allowedlib/* build/web/WEB-INF/lib/

# 4. Biên dịch mã nguồn Java
# Tìm tất cả các file .java và lưu vào sources.txt
RUN find src/java -name "*.java" > sources.txt
# Compile với classpath bao gồm tất cả thư viện vừa copy
RUN javac -encoding UTF-8 -cp "build/web/WEB-INF/lib/*:src/java" -d build/web/WEB-INF/classes @sources.txt

# 5. Nén toàn bộ thư mục web thành file ROOT.war (Chạy ở thư mục gốc /)
RUN jar -cvf ROOT.war -C build/web .


# ==========================================
# STAGE 2: Triển khai lên Tomcat (Run)
# ==========================================
FROM tomcat:10.1-jdk17

# Render mặc định cung cấp biến môi trường PORT (thường là 10000). 
# Nếu không chạy trên Render, mặc định dùng 8080.
ENV PORT=8080

# Xóa các app mặc định của Tomcat để dọn dẹp
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file ROOT.war từ Stage 1 sang thư mục webapps của Tomcat
COPY --from=build /app/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Ghi đè cấu hình cổng của Tomcat để lắng nghe đúng $PORT mà Render yêu cầu
CMD sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml && catalina.sh run
