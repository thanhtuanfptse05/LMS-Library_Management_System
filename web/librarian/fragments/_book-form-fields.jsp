<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Fragment: _book-form-fields.jsp - Các trường thông tin của đầu sách --%>
<%-- Được dùng chung cho cả màn hình tạo mới và chỉnh sửa đầu sách --%>

<%-- Xác định đối tượng đầu sách cần binding dữ liệu khi ở chế độ chỉnh sửa --%>
<c:set var="formBook" value="${param.editing == 'true' ? editBook : null}" />

<div class="row g-3">
    <%-- 1. Phần upload ảnh bìa và xem trước ảnh --%>
    <div class="col-12">
        <label class="form-label">Ảnh bìa</label>
        <div class="bm-cover-upload">
            <div class="bm-cover-upload__preview">
                <c:choose>
                    <%-- Nếu sách đã có ảnh bìa, kiểm tra đường dẫn là tuyệt đối (http/https) hay tương đối để hiển thị --%>
                    <c:when test="${not empty formBook.imagePath}">
                        <c:choose>
                            <c:when test="${fn:startsWith(formBook.imagePath, 'http://') or fn:startsWith(formBook.imagePath, 'https://')}">
                                <img data-cover-preview src="${formBook.imagePath}" alt="Ảnh bìa hiện tại">
                            </c:when>
                            <c:otherwise>
                                <img data-cover-preview src="${pageContext.request.contextPath}/book-images/${formBook.imagePath}" alt="Ảnh bìa hiện tại">
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <%-- Ngược lại, hiển thị icon placeholder mặc định --%>
                    <c:otherwise>
                        <span data-cover-placeholder class="material-symbols-outlined">menu_book</span>
                        <img data-cover-preview alt="Xem trước ảnh bìa" hidden>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="flex-grow-1">
                <input class="form-control" name="imageFile" type="file" accept="image/jpeg,image/png" data-cover-input>
                <p class="bm-section-note mt-2 mb-0">
                    Chấp nhận JPG hoặc PNG, tối đa 5 MB.
                    <c:if test="${param.editing == 'true'}"> Không chọn ảnh mới để giữ ảnh hiện tại.</c:if>
                </p>
            </div>
        </div>
    </div>
    
    <%-- 2. Tên đầu sách --%>
    <div class="col-12">
        <label class="form-label">Tên sách <span class="bm-required">*</span></label>
        <input class="form-control" name="title" required maxlength="500" value="<c:out value="${formBook.title}" />">
    </div>
    
    <%-- 3. Mã ISBN: Khóa duy nhất, chỉ cho phép chỉnh sửa khi tạo mới, cấm đổi khi update --%>
    <div class="col-md-6">
        <label class="form-label">ISBN <span class="bm-required">*</span></label>
        <input class="form-control" name="isbn" required maxlength="20"
               placeholder="Ví dụ: 9780134685991 hoặc 0134685997"
               value="<c:out value="${formBook.isbn}" />" ${param.editing == 'true' ? 'readonly' : ''}>
    </div>
    
    <%-- 4. Tác giả --%>
    <div class="col-md-6">
        <label class="form-label">Tác giả</label>
        <input class="form-control" name="author" maxlength="500" value="<c:out value="${formBook.author}" />">
    </div>
    
    <%-- 5. Nhà xuất bản --%>
    <div class="col-md-6">
        <label class="form-label">Nhà xuất bản</label>
        <input class="form-control" name="publisher" maxlength="255" value="<c:out value="${formBook.publisher}" />">
    </div>
    
    <%-- 6. Năm xuất bản --%>
    <div class="col-md-3">
        <label class="form-label">Năm xuất bản</label>
        <input class="form-control" name="publicationYear" type="number" min="1000" max="2100" value="${formBook.publicationYear}">
    </div>
    
    <%-- 7. Giá trị sách (dùng làm cơ sở tính tiền phạt nếu làm hỏng/mất) --%>
    <%-- Dùng type="text" thay vì type="number": input số của HTML không cho phép hiển thị --%>
    <%-- dấu phân cách hàng nghìn. JavaScript định dạng "1.300.000" khi gõ và gỡ dấu chấm --%>
    <%-- trước khi gửi lên máy chủ. --%>
    <div class="col-md-3">
        <label class="form-label">Giá sách <span class="bm-unit-hint">(VNĐ)</span></label>
        <input class="form-control" name="price" type="text" inputmode="numeric" autocomplete="off"
               maxlength="21" placeholder="Ví dụ: 1.300.000" data-price-input
               value="${formBook.price}">
    </div>
    
    <%-- 8. Trạng thái và Số lượng kho: Chỉ hiển thị khi đang sửa (không cho chỉnh sửa trực tiếp số lượng kho) --%>
    <c:if test="${param.editing == 'true'}">
        <div class="col-md-6">
            <label class="form-label">Trạng thái</label>
            <select class="form-select" name="bookStatus">
                <option value="available" ${formBook.status == 'available' ? 'selected' : ''}>Đang sử dụng</option>
                <option value="unavailable" ${formBook.status == 'unavailable' ? 'selected' : ''}>Ngừng sử dụng</option>
            </select>
        </div>
        <div class="col-md-6">
            <label class="form-label">Số lượng kho</label>
            <input class="form-control" readonly value="Tổng ${formBook.totalQuantity} · Sẵn sàng ${formBook.availableQuantity}">
        </div>
    </c:if>
    
    <%-- Khi tạo mới, mặc định trạng thái hoạt động là 'available' --%>
    <c:if test="${param.editing != 'true'}">
        <input type="hidden" name="bookStatus" value="available">
    </c:if>
    
    <%-- 9. Danh mục/Thể loại sách: Hiển thị các danh mục đang dùng, giữ lại danh mục đã ẩn nếu sách đang thuộc danh mục đó --%>
    <div class="col-md-6">
        <div class="bm-choice-picker" data-choice-picker>
            <div class="bm-choice-picker__top">
                <label class="form-label mb-0" for="bookCategorySearch-${param.editing == 'true' ? 'edit' : 'create'}">Thể loại</label>
            </div>
            <div class="bm-choice-picker__search bm-search">
                <span class="material-symbols-outlined">search</span>
                <input id="bookCategorySearch-${param.editing == 'true' ? 'edit' : 'create'}" class="form-control"
                       type="search" autocomplete="off" placeholder="Tìm thể loại" data-choice-search>
            </div>
            <div class="bm-choice-grid" data-choice-list>
            <c:forEach var="category" items="${categories}">
                <c:set var="categorySelected" value="${param.editing == 'true' and formBook.hasCategory(category.categoryId)}" />
                <c:if test="${category.status == 'active' or categorySelected}">
                    <label class="bm-choice ${category.status == 'hidden' ? 'bm-choice--hidden' : ''}" data-choice-item>
                        <input type="checkbox" name="categoryIds" value="${category.categoryId}" ${categorySelected ? 'checked' : ''} ${category.status == 'hidden' ? 'disabled' : ''}>
                        <span>
                            <c:out value="${category.name}" />
                            <c:if test="${category.status == 'hidden'}"> (Đã ẩn)</c:if>
                        </span>
                    </label>
                    <c:if test="${categorySelected and category.status == 'hidden'}">
                        <input type="hidden" name="categoryIds" value="${category.categoryId}">
                    </c:if>
                </c:if>
            </c:forEach>
            <c:if test="${empty categories}">
                <span class="bm-empty-note">Chưa có thể loại.</span>
            </c:if>
            </div>
            <p class="bm-choice-picker__empty mb-0" data-choice-empty hidden>Không có thể loại phù hợp.</p>
        </div>
    </div>
    
    <%-- 10. Nhãn sách: Quản lý nhãn đa chọn tương tự thể loại --%>
    <div class="col-md-6">
        <div class="bm-choice-picker" data-choice-picker>
            <div class="bm-choice-picker__top">
                <label class="form-label mb-0" for="bookTagSearch-${param.editing == 'true' ? 'edit' : 'create'}">Nhãn sách</label>
            </div>
            <div class="bm-choice-picker__search bm-search">
                <span class="material-symbols-outlined">search</span>
                <input id="bookTagSearch-${param.editing == 'true' ? 'edit' : 'create'}" class="form-control"
                       type="search" autocomplete="off" placeholder="Tìm nhãn sách" data-choice-search>
            </div>
            <div class="bm-choice-grid" data-choice-list>
            <c:forEach var="tag" items="${tags}">
                <c:set var="tagSelected" value="${param.editing == 'true' and formBook.hasTag(tag.tagId)}" />
                <c:if test="${tag.status == 'active' or tagSelected}">
                    <label class="bm-choice ${tag.status == 'hidden' ? 'bm-choice--hidden' : ''}" data-choice-item>
                        <input type="checkbox" name="tagIds" value="${tag.tagId}" ${tagSelected ? 'checked' : ''} ${tag.status == 'hidden' ? 'disabled' : ''}>
                        <span>
                            <c:out value="${tag.name}" />
                            <c:if test="${tag.status == 'hidden'}"> (Đã ẩn)</c:if>
                        </span>
                    </label>
                    <c:if test="${tagSelected and tag.status == 'hidden'}">
                        <input type="hidden" name="tagIds" value="${tag.tagId}">
                    </c:if>
                </c:if>
            </c:forEach>
            <c:if test="${empty tags}">
                <span class="bm-empty-note">Chưa có nhãn sách.</span>
            </c:if>
            </div>
            <p class="bm-choice-picker__empty mb-0" data-choice-empty hidden>Không có nhãn sách phù hợp.</p>
        </div>
    </div>
</div>
