<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Fragment: _book-import-issues.jsp — bảng liệt kê lỗi hoặc cảnh báo của tệp import --%>
<%-- Dùng chung cho cả hai bảng ở màn Nhập dữ liệu sách. --%>
<%-- Nhận qua requestScope: --%>
<%--   issueRows    : danh sách BookImportError --%>
<%--   issueTone    : danger (lỗi) hoặc warning (cảnh báo) --%>
<%--   issueHeading : tiêu đề cột thứ hai --%>
<%-- Tên trang tính và tên cột trong tệp là tiếng Anh kỹ thuật (Books, BookCopies, --%>
<%-- publicationYear...) nên được dịch sang tiếng Việt để thủ thư đọc là hiểu ngay. --%>

<table class="table table-lms">
    <thead>
        <tr>
            <th>Ở đâu</th>
            <th><c:out value="${issueHeading}" /></th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="issue" items="${issueRows}">
            <c:choose>
                <c:when test="${issue.sheetName == 'Books'}"><c:set var="sheetLabel" value="Đầu sách" /></c:when>
                <c:when test="${issue.sheetName == 'BookCopies'}"><c:set var="sheetLabel" value="Bản sao" /></c:when>
                <c:otherwise><c:set var="sheetLabel" value="${issue.sheetName}" /></c:otherwise>
            </c:choose>
            <c:choose>
                <c:when test="${issue.columnName == 'isbn'}"><c:set var="columnLabel" value="ISBN" /></c:when>
                <c:when test="${issue.columnName == 'title'}"><c:set var="columnLabel" value="Tên sách" /></c:when>
                <c:when test="${issue.columnName == 'author'}"><c:set var="columnLabel" value="Tác giả" /></c:when>
                <c:when test="${issue.columnName == 'publisher'}"><c:set var="columnLabel" value="Nhà xuất bản" /></c:when>
                <c:when test="${issue.columnName == 'publicationYear'}"><c:set var="columnLabel" value="Năm xuất bản" /></c:when>
                <c:when test="${issue.columnName == 'price'}"><c:set var="columnLabel" value="Giá sách" /></c:when>
                <c:when test="${issue.columnName == 'categories'}"><c:set var="columnLabel" value="Thể loại" /></c:when>
                <c:when test="${issue.columnName == 'tags'}"><c:set var="columnLabel" value="Nhãn sách" /></c:when>
                <c:when test="${issue.columnName == 'barcode'}"><c:set var="columnLabel" value="Mã vạch" /></c:when>
                <c:when test="${issue.columnName == 'location'}"><c:set var="columnLabel" value="Vị trí" /></c:when>
                <c:otherwise><c:set var="columnLabel" value="" /></c:otherwise>
            </c:choose>
            <tr>
                <td>
                    <strong>Trang <c:out value="${sheetLabel}" /></strong>, dòng ${issue.rowNumber}<c:if test="${not empty columnLabel}">, cột <c:out value="${columnLabel}" /></c:if>
                </td>
                <td class="bm-text-${issueTone}"><c:out value="${issue.errorMessage}" /></td>
            </tr>
        </c:forEach>
    </tbody>
</table>
