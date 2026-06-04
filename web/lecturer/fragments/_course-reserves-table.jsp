<%--
  Fragment: _course-reserves-table.jsp
  Bảng danh sách Course Reserves của Lecturer — tách ra để dễ bảo trì
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Course Reserves Table Section --%>
<section class="mb-5">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="h5 fw-bold text-dark mb-0" style="font-size: 20px;">Course Reserves</h2>
        <a href="${pageContext.request.contextPath}/lecturer/course-reserves/add"
           class="btn text-white px-3 py-2 border-0 rounded-3 d-flex align-items-center gap-2 small fw-bold text-decoration-none"
           style="background-color: #00a2f4;">
            <span class="material-symbols-outlined" style="font-size: 18px;">add_circle</span> Add New Reserve
        </a>
    </div>

    <div class="card-bento p-0 overflow-hidden">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>Book Title</th>
                        <th>Course Code</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody class="table-group-divider" style="border-top-color: #eceef0;">
                    <c:choose>
                        <c:when test="${not empty courseReserveList}">
                            <c:forEach var="reserve" items="${courseReserveList}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="bg-light rounded shadow-sm overflow-hidden" style="width: 2rem; height: 2.5rem;">
                                                <img class="w-100 h-100 object-fit-cover"
                                                     alt="<c:out value='${reserve.bookTitle}' />"
                                                     src="<c:out value='${reserve.bookCoverUrl}' />" />
                                            </div>
                                            <span class="fw-bold text-dark small"><c:out value="${reserve.bookTitle}" /></span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge px-3 py-2 rounded-pill fw-bold"
                                              style="background-color: #dae2fd; color: #5c647a; font-size: 11px;">
                                            <c:out value="${reserve.courseCode}" />
                                        </span>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="rounded-circle"
                                                 style="width: 8px; height: 8px;
                                                        background-color: ${reserve.status == 'ACTIVE' ? '#9d4300' : '#584237'};"></div>
                                            <span class="small fw-bold ${reserve.status == 'ACTIVE' ? 'text-primary-custom' : ''}"
                                                  style="${reserve.status != 'ACTIVE' ? 'color: #584237;' : ''}">
                                                <c:out value="${reserve.status == 'ACTIVE' ? 'Active' : 'Pending'}" />
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/lecturer/course-reserves/edit?id=${reserve.reserveId}"
                                           class="btn btn-link p-2 rounded-circle" title="Edit" style="color: #584237;">
                                            <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <%-- Sample rows --%>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="bg-light rounded shadow-sm overflow-hidden" style="width: 2rem; height: 2.5rem;">
                                            <img class="w-100 h-100 object-fit-cover" alt="Introduction to Ethics"
                                                 src="https://lh3.googleusercontent.com/aida-public/AB6AXuC9RVIOn2x_kbHJhRBR0I-pDJjWH6GJVDDVii4NpA8SyF5GL_XD6s1y8CESMQpoZGgB0JYVncDYF5jjamJOBvG4x-83DdT9KU91D59hTRSJN1T0HwN2HhGIiGTwOro2TisdH0owK41PHWkiNW9DkGg_rruaQZSJcMJ_NJEGjIhy4Z7RdAVCaOm9Lbat4jB_CpubxaR6CaGPlyPnlR376aq24Pe97k5Js47QBBrnCe9LIZTmnQXqBhRf8KY6zYgB3jsvOEZ210Pe9K8" />
                                        </div>
                                        <span class="fw-bold text-dark small">Introduction to Ethics</span>
                                    </div>
                                </td>
                                <td><span class="badge px-3 py-2 rounded-pill fw-bold" style="background-color: #dae2fd; color: #5c647a; font-size: 11px;">PHIL-101</span></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="rounded-circle" style="width: 8px; height: 8px; background-color: #9d4300;"></div>
                                        <span class="small fw-bold text-primary-custom">Active</span>
                                    </div>
                                </td>
                                <td><button class="btn btn-link p-2 rounded-circle" title="Edit" style="color: #584237;"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="bg-light rounded shadow-sm overflow-hidden" style="width: 2rem; height: 2.5rem;">
                                            <img class="w-100 h-100 object-fit-cover" alt="Advanced Molecular Biology"
                                                 src="https://lh3.googleusercontent.com/aida-public/AB6AXuABSnZ9M7s9lFeQ5qdhZMrhZrkzxikmU2MNmyUExLK0wSxDIalAkSOZRN7V4eO8HBAN-CwExbJoThXPa6ETeSAB2fctPIBnvY_m7VwXlORtg6X8uhGmeu2RhMKYcoYZOMzZ_e7QVqgBEREHUJe7AvD8FQoMfkbFmPS-1gO-O_p3rw4BexfFB2fTBzFOSSup6lKs9MhjU5rztYBcVW4m83vLoe0cVKccQlA-CJe_MDnkaTruXwhuF1Ts20_Jbzrgw7gd5gFWLiUk0b0" />
                                        </div>
                                        <span class="fw-bold text-dark small">Advanced Molecular Biology</span>
                                    </div>
                                </td>
                                <td><span class="badge px-3 py-2 rounded-pill fw-bold" style="background-color: #dae2fd; color: #5c647a; font-size: 11px;">BIO-402</span></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="rounded-circle" style="width: 8px; height: 8px; background-color: #584237;"></div>
                                        <span class="small fw-bold" style="color: #584237;">Pending</span>
                                    </div>
                                </td>
                                <td><button class="btn btn-link p-2 rounded-circle" title="Edit" style="color: #584237;"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="bg-light rounded shadow-sm overflow-hidden" style="width: 2rem; height: 2.5rem;">
                                            <img class="w-100 h-100 object-fit-cover" alt="Data Structures & Algos"
                                                 src="https://lh3.googleusercontent.com/aida-public/AB6AXuCG48-nd6bcErS4LBMG36mYXfYB0QS2VEirLugZ5adZdFeTPeROaePSUG__e9Boq3rSCpVjnP71SgtwA8hLdpP0mhc_pVil3uuci6yMDuuUWfXXyldlCVCPokJNwzwlYqtQ5Y4rRqv_eFIiraa9CwEfUk4xQvScgIJB4P_RJppmjX1D3esBfUIARp3l2bfwKFJKVTSZWPCnlkRiujYAbyGQp95iCQMQEK5MNKvbFoMfs3M9B27b1elnLRv_VMaYAol30UT4bvfCOVQ" />
                                        </div>
                                        <span class="fw-bold text-dark small">Data Structures &amp; Algos</span>
                                    </div>
                                </td>
                                <td><span class="badge px-3 py-2 rounded-pill fw-bold" style="background-color: #dae2fd; color: #5c647a; font-size: 11px;">CS-202</span></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="rounded-circle" style="width: 8px; height: 8px; background-color: #9d4300;"></div>
                                        <span class="small fw-bold text-primary-custom">Active</span>
                                    </div>
                                </td>
                                <td><button class="btn btn-link p-2 rounded-circle" title="Edit" style="color: #584237;"><span class="material-symbols-outlined" style="font-size: 18px;">edit</span></button></td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</section>
