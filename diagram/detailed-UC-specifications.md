# Detailed Use Case Specifications (LMS)

**Project:** Library Management System (LMS)  
**Version:** 4.0.0  
**Date:** 2026-07-22  

---

## UC-01: Login

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-01: Login</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Guest, User</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">The user wants to log in to access system features.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">The user provides credentials (Email and Password) to authenticate identity and access role-specific dashboards.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• The user is on the Login page and has an active account.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• The user is authenticated and redirected to their dashboard.<br>• System logs the transaction in AuditLogs.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User navigates to the Login page.<br>2. System displays login form with Email and Password input fields.<br>3. User enters registered Email and Password. (E1)<br>4. User clicks [Đăng nhập] button. (A1)<br>5. System validates that input fields are not empty. (E1)<br>6. System queries "User" table and verifies Email and BCrypt password hash. (E2, E3)<br>7. System creates a secure session (HttpSession), logs transaction in AuditLogs, and redirects user to their role-specific dashboard.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel login / Return to Homepage<br>At Step 4, User clicks [Hủy] or logo.<br>1. System discards entered credentials.<br>2. User is redirected to Public Homepage (UC-47).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Empty mandatory inputs<br>At Step 5: User leaves Email or Password field blank.<br>• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."<br>• Login form remains open.<br><br>E2: Incorrect credentials<br>At Step 6: Entered Email or Password does not match database.<br>• System displays: "Tài khoản hoặc mật khẩu không chính xác."<br><br>E3: Account locked due to security policy<br>At Step 6: Account status is "Locked" or failed login attempts threshold reached.<br>• System displays: "Tài khoản tạm thời bị khóa do nhập sai nhiều lần."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-01, BR-02, BR-03, BR-05, BR-06</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-02: Logout

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-02: Logout</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>User</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">The user wants to terminate their active system session.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">The user logs out of the system, invalidating the active HTTP session to protect personal data.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• The user is logged in.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• The user session is invalidated and redirected to the login page.<br>• System logs the transaction in AuditLogs.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Authenticated User clicks [Đăng xuất] button on top header bar.<br>2. System displays confirmation modal dialog with [Hủy] and [Đăng xuất] buttons.<br>3. User clicks [Đăng xuất]. (A1)<br>4. System invalidates current HttpSession, clears security context, and logs action to AuditLogs.<br>5. System closes dialog and redirects user to Login page with success message: "Đăng xuất thành công."</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel logout<br>At Step 3, User clicks [Hủy] or [×] on dialog.<br>1. Confirmation dialog closes.<br>2. User remains logged in on current page.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Session already expired<br>At Step 1: Session timed out prior to user action.<br>• System automatically redirects user to Login page.</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-39</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-03: Reset Password

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-03: Reset Password</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Guest</td>
    <td><b>Secondary Actors:</b></td>
    <td>System</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Guest forgets password and wants to request a temporary one.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">The guest enters registered email to receive an OTP code to reset their password.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• The guest is on the Forgot Password page.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Password reset confirmation is displayed, and password updated upon OTP verification.<br>• System logs the transaction in AuditLogs.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User clicks "Forgot Password" link on Login page.<br>2. System displays "Reset Password" modal dialog with Email input field.<br>3. User enters registered Email and clicks [Gửi OTP]. (A1, E1)<br>4. System validates Email existence in "User" table. (E1)<br>5. System generates 6-digit OTP code with 5-minute expiration and dispatches email via async EmailService.<br>6. System updates dialog prompt to enter OTP code and New Password.<br>7. User enters OTP code, New Password, and clicks [Xác nhận]. (E2, E3)<br>8. System validates OTP code and updates passwordHash using BCrypt in "User" table.<br>9. System logs transaction to AuditLogs and displays: "Đặt lại mật khẩu thành công."</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel password reset<br>At Step 3, User clicks [Hủy] or [×] on dialog.<br>1. Dialog closes with no data saved.<br>2. User returns to Login page.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Email not registered<br>At Step 4: Entered Email does not exist in "User" table.<br>• System displays: "Email không tồn tại trong hệ thống."<br><br>E2: Invalid or expired OTP<br>At Step 8: OTP code is wrong or expired (> 5 minutes).<br>• System displays: "Mã OTP không hợp lệ hoặc đã hết hạn."<br><br>E3: Weak password<br>At Step 8: New password does not satisfy length rule.<br>• System displays: "Mật khẩu mới phải có tối thiểu 8 ký tự."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-04, BR-07, BR-47</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-04: View Profile

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-04: View Profile</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>User</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">User wants to view their profile details.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">The user accesses the profile section to view personal identification, contact details, and role metadata.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• The user is logged in.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• System displays user profile details successfully.<br>• System logs transaction in AuditLogs.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Authenticated User clicks "My Profile" from header user menu.<br>2. System queries "User", MemberProfile, and role-specific tables (Student / Lecturer / Librarian / LibraryManager / Admin). (E1)<br>3. System displays Profile page with personal details: Full Name, Email, Phone, Gender, Date of Birth, Role Code, and Membership status.<br>4. User views profile details or proceeds to update. (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Navigate to edit mode<br>At Step 4, User clicks [Chỉnh sửa hồ sơ].<br>1. System redirects user to Update Profile page (UC-05).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Profile record not found<br>At Step 2: MemberProfile record missing in database.<br>• System logs database error and displays: "Không tìm thấy dữ liệu hồ sơ cá nhân."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-08</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-05: Update Profile

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-05: Update Profile</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>User</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">User wants to edit their contact details.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">The user modifies editable fields of their profile (e.g., Phone Number, Date of Birth, Gender).</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• The user is logged in and viewing profile.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• The updated profile details are saved to database.<br>• System logs transaction in AuditLogs.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User is on Profile page (UC-04) and clicks [Chỉnh sửa hồ sơ].<br>2. System displays Profile Edit form pre-filled with current details:<br>   a. Full Name *<br>   b. Phone Number *<br>   c. Gender<br>   d. Date of Birth<br>   e. [Hủy] and [Lưu thay đổi] buttons<br>3. User updates personal details and clicks [Lưu thay đổi]. (A1, E1)<br>4. System validates required fields and phone format. (E1)<br>5. System updates MemberProfile table in PostgreSQL and logs to AuditLogs.<br>6. System displays: "Cập nhật hồ sơ thành công" and refreshes profile view.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel profile editing<br>At Step 3, User clicks [Hủy] or [×].<br>1. Form changes are discarded.<br>2. User returns to read-only Profile view.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Invalid input data<br>At Step 4: Name is empty or Phone number format is invalid.<br>• System displays: "Vui lòng điền đầy đủ các trường bắt buộc và số điện thoại hợp lệ."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-08, BR-15</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-06: Change Password

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-06: Change Password</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>User</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">User wants to update password for security reasons.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">The user inputs current password and provides a new secure password to replace the old one.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• The user is logged in.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Password is changed, audit log is recorded, and user session updated.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Authenticated User navigates to "Change Password" screen.<br>2. System displays Change Password form with fields:<br>   a. Current Password *<br>   b. New Password *<br>   c. Confirm New Password *<br>   d. [Hủy] and [Cập nhật mật khẩu] buttons<br>3. User enters required passwords and clicks [Cập nhật mật khẩu]. (A1, E1)<br>4. System validates input fields and checks if New Password matches Confirm New Password. (E1)<br>5. System verifies Current Password against BCrypt hash in "User" table. (E2)<br>6. System enforces new password policy rules. (E3)<br>7. System updates passwordHash in "User" table, logs to AuditLogs, and displays: "Đổi mật khẩu thành công."</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel password change<br>At Step 3, User clicks [Hủy].<br>1. Form input cleared.<br>2. User returns to Profile page.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Mismatched new passwords<br>At Step 4: New Password and Confirm New Password do not match.<br>• System displays: "Mật khẩu mới và xác nhận mật khẩu không trùng khớp."<br><br>E2: Incorrect current password<br>At Step 5: Current Password verification fails.<br>• System displays: "Mật khẩu hiện tại không chính xác."<br><br>E3: Weak password policy violation<br>At Step 6: Password length < 8 characters.<br>• System displays: "Mật khẩu mới phải có tối thiểu 8 ký tự."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-09, BR-14</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-07: View User List

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-07: View User List</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Quyet</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Admin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Admin wants to view all registered user accounts.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin accesses User Management module to view a paginated list of all users, filtered by role or status.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Admin is logged in and authorized.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• A list of user accounts is displayed with pagination.<br>• System logs transaction in AuditLogs.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Admin navigates to "User Management → Account List" from left sidebar.<br>2. System displays User List page with:<br>   a. Filter bar (Role dropdown, Status dropdown, Keyword search box)<br>   b. Paginated user table (User ID, Code, Full Name, Email, Role, Status, Created At, Action buttons)<br>   c. [+ Thêm tài khoản] and [Nhập Excel] buttons<br>3. Admin applies filter criteria or keyword search. (A1, E1)<br>4. System queries "User", MemberProfile, Student, Lecturer tables matching criteria.<br>5. System renders paginated table results.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Export user list<br>At Step 3, Admin clicks [Xuất Excel].<br>1. System triggers Export User List workflow (UC-30).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: No users found matching filter<br>At Step 4: Query returns 0 records.<br>• System displays: "Không tìm thấy người dùng nào phù hợp."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-08: View User Detail

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-08: View User Detail</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Quyet</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Admin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Admin wants to see detailed profile of a specific user.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin selects a user from the list to display full profile, contact details, and account status history.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Admin is logged in and viewing User List.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Detailed profile of selected user is displayed.<br>• System logs transaction in AuditLogs.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Admin is on User List page (UC-07).<br>2. Admin clicks view icon or user row.<br>3. System opens "Account Detail" modal dialog pre-filled with profile details (Full Name, Email, Phone, Role, Account Status, Lock Reason history).<br>4. Admin views account detail or clicks [Sửa tài khoản] or [Khóa/Mở khóa tài khoản]. (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Edit account details<br>At Step 4, Admin clicks [Sửa tài khoản].<br>1. System opens Update User Account modal (UC-11).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: User account not found<br>At Step 2: Selected userId does not exist.<br>• System displays error message: "Không tìm thấy bản ghi tài khoản người dùng."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-09: Create Single Account

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-09: Create Single Account</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Quyet</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Admin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Admin wants to create a new user account manually.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin fills in registration form to create a single user account (Student, Lecturer, Librarian, Manager).</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Admin is logged in.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• A new user account is saved to database and audit log created.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Admin is on User List page (UC-07).<br>2. Admin clicks [+ Thêm tài khoản] button.<br>3. System opens "Add New Account" modal dialog with fields:<br>   a. Role * (Student / Lecturer / Librarian / LibraryManager)<br>   b. Code * (Student Code / Lecturer Code / Staff Code)<br>   c. Email *<br>   d. Password *<br>   e. Full Name *<br>   f. Phone Number<br>   g. Department / Major / Enrollment Year<br>   h. [Hủy] and [Create Account] buttons<br>4. Admin selects role, enters profile data, and clicks [Create Account]. (A1, E1, E2)<br>5. System validates required fields and email/code unique constraints. (E1, E2)<br>6. System hashes password using BCrypt.<br>7. System inserts record into "User" table, MemberProfile table, and specific role table inside a DB transaction.<br>8. System logs creation in AuditLogs, closes modal, displays: "Tạo tài khoản mới thành công", and refreshes user table.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel account creation<br>At Step 4, Admin clicks [Hủy] or [×] on modal.<br>1. Modal closes with no data saved.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Missing mandatory fields<br>At Step 5: Required fields missing.<br>• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."<br><br>E2: Duplicate Email or User Code<br>At Step 5: Email or Code already exists in database.<br>• System displays: "Email hoặc Mã số đã tồn tại trong hệ thống."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-10, BR-12, BR-14</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-10: Import Bulk Accounts

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-10: Import Bulk Accounts</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Quyet</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Admin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Admin wants to import a large list of accounts.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin uploads an Excel file (.xlsx) containing bulk account data to provision users rapidly.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Admin is logged in.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Multiple user accounts created inside a DB transaction, or none if validation fails.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Admin is on User List page (UC-07).<br>2. Admin clicks [Nhập Excel] button.<br>3. System opens "Import Accounts from Excel" modal dialog with:<br>   a. File upload area (.xlsx)<br>   b. Download sample template link<br>   c. [Hủy] and [Tải lên & Xem trước] buttons<br>4. Admin selects file and clicks [Tải lên & Xem trước]. (A1, E1)<br>5. System parses Excel rows using Apache POI, validates format and unique constraints per row. (E1, E2)<br>6. System displays Import Preview Modal showing valid rows count and error rows count with line numbers.<br>7. Admin reviews preview and clicks [Xác nhận nhập].<br>8. System inserts valid records into "User", MemberProfile, and role tables in batch transaction.<br>9. System logs operation to AuditLogs, closes modal, displays: "Nhập dữ liệu tài khoản từ Excel thành công", and refreshes User List.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel import<br>At Step 4, Admin clicks [Hủy] or [×] on modal.<br>1. Modal closes without importing data.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Invalid file format<br>At Step 5: File extension is not .xlsx or corrupt.<br>• System displays: "Định dạng tệp không hợp lệ. Vui lòng sử dụng tệp mẫu .xlsx."<br><br>E2: Bulk validation errors<br>At Step 5: Multiple rows have invalid data.<br>• System displays error summary table highlighting invalid rows.</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-10, BR-11, BR-13, BR-14</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-11: Update User Account

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-11: Update User Account</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Quyet</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Admin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Admin wants to update user account details or status.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin modifies account profile, role, status (Active/Locked), or resets lock reason.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Admin is logged in.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Account updates saved to database and audit log created.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Admin is on User List page (UC-07) or User Detail modal (UC-08).<br>2. Admin clicks [Sửa tài khoản] or status toggle switch.<br>3. System opens "Update Account" modal dialog pre-filled with user data.<br>4. Admin modifies profile fields, status, or role, and clicks [Lưu thay đổi]. (A1, E1)<br>5. System validates required input values. (E1)<br>6. System updates "User" and MemberProfile tables.<br>7. System logs change in AuditLogs, closes modal, displays: "Cập nhật thông tin tài khoản thành công", and refreshes User List.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel update<br>At Step 4, Admin clicks [Hủy].<br>1. Modal closes without saving changes.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Validation failure<br>At Step 5: Required fields left blank.<br>• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-14</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-12: View Book Catalog & Inventory

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-12: View Book Catalog & Inventory</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Chuong</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian or Manager wants to view book catalog and copy inventories.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User views paginated list of all book titles, search by keywords, and check status, location, and barcode details.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Book catalog and inventory details displayed.<br>• System logs transaction in AuditLogs.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User navigates to "Book Management → Catalog & Inventory" from sidebar.<br>2. System queries Book, BookCopy, Category, Tag tables.<br>3. System displays Book Catalog page with search bar, category filter, tag filter, and book grid/table.<br>4. User enters keyword or selects category filter. (A1, E1)<br>5. System renders matching book titles with totalQuantity and availableQuantity counters.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: View copy inventory<br>At Step 5, User clicks a book row.<br>1. System opens Copy Inventory modal showing barcodes, locations, conditions, and copy statuses.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Book catalog empty<br>At Step 4: Search keyword returns 0 records.<br>• System displays: "Không tìm thấy đầu sách nào phù hợp."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-13: Manage Book Catalog

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-13: Manage Book Catalog</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Chuong</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian or Manager wants to add or update book catalog entries.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User creates new book title or modifies metadata (ISBN, Title, Author, Publisher, Year, Price, Image).</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in with appropriate permissions.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Book title record saved to database and audit log created.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User is on Book Catalog page (UC-12).<br>2. User clicks [+ Thêm sách] button or edit icon on book row.<br>3. System opens "Book Information" modal dialog with fields: ISBN *, Title *, Author *, Publisher, Publication Year, Price *, Cover Image Upload, Category multiselect, Tag multiselect.<br>4. User enters metadata, selects image, and clicks [Lưu thông tin sách]. (A1, E1, E2)<br>5. System validates ISBN uniqueness and required fields. (E1, E2)<br>6. System saves cover image to storage directory via BookImageStorage utility.<br>7. System inserts/updates Book record, BookCategory, and BookTag junction tables.<br>8. System logs C/U/D action to AuditLogs, closes modal, displays: "Lưu thông tin đầu sách thành công", and refreshes catalog.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel book management<br>At Step 4, User clicks [Hủy].<br>1. Modal closes without saving changes.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Missing mandatory fields<br>At Step 5: ISBN, Title, Author, or Price is missing.<br>• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."<br><br>E2: Duplicate ISBN<br>At Step 5: Entered ISBN already exists in Book table.<br>• System displays: "Mã ISBN này đã tồn tại trong hệ thống."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-16, BR-18</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-14: Manage Physical Copies

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-14: Manage Physical Copies</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Chuong</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian wants to declare physical book copies and barcodes.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian adds physical copy instances for a book title with barcode, location shelf, and initial condition.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Librarian is logged in.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• New BookCopy records created, increasing availableQuantity counter.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Librarian is on Book Catalog page (UC-12) or Copy Inventory modal.<br>2. Librarian clicks [+ Thêm bản sao] button.<br>3. System opens "Add Copy" modal with fields: Barcode * (or auto-generate), Location Shelf *, Initial Condition (New / Good / Fair), Status (Available).<br>4. Librarian enters barcode and location, then clicks [Lưu bản sao]. (A1, E1, E2)<br>5. System validates barcode uniqueness in BookCopy table. (E1, E2)<br>6. System inserts record into BookCopy table.<br>7. System increments totalQuantity and availableQuantity in Book table.<br>8. System records action in AuditLogs, displays: "Thêm bản sao sách mới thành công", and refreshes copy list table.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel copy creation<br>At Step 4, Librarian clicks [Hủy].<br>1. Modal closes without creating copy.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Empty mandatory copy fields<br>At Step 5: Barcode or Location is blank.<br>• System displays: "Vui lòng nhập mã vạch và vị trí kệ sách."<br><br>E2: Duplicate barcode<br>At Step 5: Barcode already assigned to another physical copy.<br>• System displays: "Mã vạch bản sao này đã tồn tại trong hệ thống."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-16, BR-17, BR-18</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-15: Manage Tags & Categories

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-15: Manage Tags & Categories</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Chuong</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian or Manager wants to manage category and tag taxonomies.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User creates, updates, or soft-deletes book categories and tags.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in with catalog permissions.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Category / Tag records updated in database.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User navigates to "Category & Tag Management" from sidebar.<br>2. System displays Category list and Tag list tables with C/U/D action buttons.<br>3. User clicks [+ Thêm danh mục] or [+ Thêm thẻ tag] button.<br>4. System opens modal dialog with Name * and Description fields.<br>5. User enters taxonomy details and clicks [Lưu]. (A1, E1)<br>6. System validates unique name constraint in Category or Tag table. (E1)<br>7. System inserts or updates record in Category / Tag table.<br>8. System closes modal, displays: "Cập nhật danh mục / thẻ tag thành công", and refreshes list.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel category management<br>At Step 5, User clicks [Hủy].<br>1. Modal closes without saving taxonomy.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Duplicate category/tag name<br>At Step 6: Name already exists.<br>• System displays: "Tên danh mục hoặc thẻ tag đã tồn tại."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-16: Reserve Book Online

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-16: Reserve Book Online</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Bao</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Student, Lecturer</td>
    <td><b>Secondary Actors:</b></td>
    <td>System</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Student or Lecturer wants to place an online hold reservation for an out-of-stock book.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User reserves a book when availableQuantity = 0 to join queue.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Reservation record created with status 'Pending' and queuePosition assigned.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User views Book Detail page (UC-22) where availableQuantity = 0.<br>2. User clicks [Đặt giữ chỗ sách] button.<br>3. System checks user active loan count, overdue fines, and existing reservations for this book. (E1, E2, E3)<br>4. System calculates next queuePosition = MAX(queuePosition) + 1 for this bookId.<br>5. System inserts record into Reservation table (status = 'Pending', startDate = NOW()).<br>6. System logs action to AuditLogs and displays success modal: "Đặt giữ chỗ sách trực tuyến thành công."</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel reservation<br>At Step 2, User clicks [Hủy] on confirmation modal.<br>1. Reservation request cancelled.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Unpaid fine or overdue loan<br>At Step 3: User has overdue books or pending fines.<br>• System displays: "Bạn đang có sách quá hạn hoặc nợ tiền phạt. Không thể đặt giữ chỗ."<br><br>E2: Already reserved this book<br>At Step 3: Active Reservation record already exists for this bookId and userId.<br>• System displays: "Bạn đã đăng ký đặt giữ chỗ cho đầu sách này rồi."<br><br>E3: Exceeded reservation limit<br>At Step 3: Active reservations >= max limit (BR-21).<br>• System displays: "Bạn đã đạt giới hạn số lượng sách đặt giữ chỗ tối đa."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-19, BR-20, BR-22</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-17: Renew Book Online

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-17: Renew Book Online</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Bao</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Student, Lecturer</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Student or Lecturer wants to extend due date of an active loan online.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User extends loan period by renewal limit if no other reader has reserved the book.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in and has an active loan.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• BorrowRecord endDate extended and extensionCount incremented.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User navigates to "My Borrowings" page (UC-31).<br>2. User selects an active loan and clicks [Gia hạn mượn] button.<br>3. System checks extensionCount < maxRenewals (BR-22) AND no pending Reservations exist for this book. (E1, E2, E3)<br>4. System calculates new endDate = current endDate + renewalDays from SystemConfigurations.<br>5. System updates BorrowRecord (endDate = new endDate, extensionCount = extensionCount + 1).<br>6. System records action in AuditLogs and displays: "Gia hạn mượn sách thành công."</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel renewal<br>At Step 2, User cancels renewal prompt.<br>1. Due date remains unchanged.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Renewal limit reached<br>At Step 3: extensionCount >= maxRenewals.<br>• System displays: "Sách này đã đạt số lần gia hạn tối đa cho phép."<br><br>E2: Pending reservations exist<br>At Step 3: Another user is waiting in Reservation queue.<br>• System displays: "Không thể gia hạn do đầu sách này đang có độc giả khác chờ mượn."<br><br>E3: Loan is overdue<br>At Step 3: NOW() > endDate.<br>• System displays: "Sách đã quá hạn trả. Vui lòng mang sách đến quầy thư viện để xử lý."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-19, BR-21, BR-22</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-18: Desk Check-out

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-18: Desk Check-out</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Thai</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian issues books to readers at circulation desk.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian scans reader barcode and copy barcode to check out books.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Librarian is logged in.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• BorrowRecord created, copy status set to 'Borrowed', availableQuantity decremented.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Librarian is on Desk Circulation screen ("Issue Book").<br>2. Librarian scans/enters Reader Code (Student Code / Staff Code). (E1)<br>3. System validates account status and active fines. (E1, E2)<br>4. Librarian scans Copy Barcode. (E3, E4)<br>5. System verifies BookCopy status = 'Available' (or reserved for this user). (E4)<br>6. Librarian selects loan duration (14 days student / 30 days lecturer) and clicks [Xác nhận mượn].<br>7. System inserts BorrowRecord, updates BookCopy status = 'Borrowed', decrements availableQuantity in Book table.<br>8. System records transaction in AuditLogs and prints loan receipt.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Issue from pre-reservation<br>At Step 4, Librarian selects reader's active reservation.<br>1. System links Reservation to BorrowRecord and sets Reservation status = 'Fulfilled'.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Reader code not found or locked<br>At Step 3: Account invalid or locked.<br>• System displays: "Mã độc giả không tồn tại hoặc tài khoản đã bị khóa."<br><br>E2: Reader has pending fines<br>At Step 3: Fine balance > 0.<br>• System displays: "Độc giả đang có tiền phạt chưa nộp. Vui lòng thanh toán trước."<br><br>E3: Invalid barcode<br>At Step 4: Barcode not found in BookCopy table.<br>• System displays: "Mã vạch bản sao sách không tồn tại."<br><br>E4: Copy not available<br>At Step 5: Copy status is 'Borrowed' or 'Maintenance'.<br>• System displays: "Bản sao sách này hiện không ở trạng thái sẵn sàng để mượn."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-22, BR-23, BR-29</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-19: Desk Check-in

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-19: Desk Check-in</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Thai</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>System</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian processes returned books at circulation desk.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian scans copy barcode, verifies condition, calculates fine if overdue, and updates inventory.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Librarian is logged in.<br>• System is operational and database is accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• BorrowRecord returnedAt updated, copy status set to 'Available', fine created if overdue.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Librarian is on Desk Circulation screen ("Receive Return").<br>2. Librarian scans Copy Barcode. (E1, E2)<br>3. System retrieves active BorrowRecord for this copy.<br>4. Librarian selects return condition (Good / Damaged / Lost).<br>5. System checks if return date > endDate.<br>6. If overdue, system calculates fineAmount = overdueDays * dailyFineRate and inserts Fine record.<br>7. Librarian clicks [Xác nhận trả].<br>8. System updates BorrowRecord (returnedAt = NOW(), status = 'Returned').<br>9. System updates BookCopy status = 'Available' (or 'Maintenance' if damaged) and increments availableQuantity in Book table.<br>10. System records transaction in AuditLogs, displays: "Nhận trả sách thành công", and renders Fine payment prompt if fine incurred.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Process fine payment immediately<br>At Step 10, Librarian clicks [Thu tiền phạt mặt].<br>1. System opens Cash Payment dialog (UC-20).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Barcode not found<br>At Step 2: Barcode does not exist.<br>• System displays: "Mã vạch bản sao sách không tồn tại."<br><br>E2: Copy not currently borrowed<br>At Step 3: No active BorrowRecord found for barcode.<br>• System displays: "Bản sao sách này không nằm trong danh sách đang mượn."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-24, BR-35, BR-47</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-20: Process Cash Payment

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-20: Process Cash Payment</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Thai</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian collects cash fine payments at desk.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian receives cash payment for overdue/damaged fines and issues receipt.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Librarian is logged in and receiving returned book with fine.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Fine status updated to 'Paid', Payment record inserted.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Librarian is on Desk Fine Payment modal.<br>2. System displays Fine details: Reader Name, Fine Amount, Reason.<br>3. Librarian enters paidAmount and selects Payment Method = Cash.<br>4. Librarian clicks [Xác nhận thu tiền]. (A1, E1)<br>5. System inserts record into Payment table (processedBy = staffId, paymentMethod = 'Cash').<br>6. System updates Fine status = 'Paid'.<br>7. System records transaction in AuditLogs, displays: "Thanh toán tiền phạt thành công", and prints receipt.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel cash payment<br>At Step 4, Librarian clicks [Hủy].<br>1. Fine remains unpaid.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Insufficient cash amount<br>At Step 4: paidAmount < fineAmount.<br>• System displays: "Số tiền nộp nhỏ hơn tổng tiền phạt."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-22, BR-25</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-21: Login with Google

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-21: Login with Google</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Guest</td>
    <td><b>Secondary Actors:</b></td>
    <td>Google Identity Service</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">User wants to authenticate quickly using Google SSO.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User logs into LMS using Google OAuth2 account credentials.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User has an active Google account.<br>• System is operational and OAuth2 client configured.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• User authenticated and session established.<br>• System logs action in AuditLogs.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User clicks [Đăng nhập với Google] button on Login page. (A1)<br>2. System redirects user to Google OAuth2 authorization URL.<br>3. User authenticates with Google and grants permissions.<br>4. Google redirects back to LMS callback URL with authorization code.<br>5. System exchanges code for access token and retrieves Google user profile.<br>6. System queries "User" table by Google email. (E1)<br>7. System creates session and redirects user to role dashboard.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel Google SSO<br>At Step 3, User cancels Google prompt.<br>1. User returned to Login page.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Unauthorized email domain<br>At Step 6: Email domain not allowed.<br>• System displays: "Email domain is not authorized for library access."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-26</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-22: Search & View Books

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-22: Search & View Books</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Bao</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>User</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Guest or User wants to search and browse books.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User searches book titles by keyword, author, category, or tag.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• System is operational and database accessible.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Matching book search results rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User accesses Search page.<br>2. System displays search bar, category dropdown, tag filter, and sort options.<br>3. User enters keyword and clicks [Tìm kiếm]. (A1, E1)<br>4. System queries Book table matching criteria. (E1)<br>5. System renders paginated list of books with title, author, cover, availability.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Filter by category<br>At Step 3, User selects Category filter.<br>1. Search results filtered by selected category.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: No books found<br>At Step 4: 0 records match criteria.<br>• System displays: "Không tìm thấy đầu sách nào phù hợp."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-23: Get AI Recommendation

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-23: Get AI Recommendation</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Bao</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>User</td>
    <td><b>Secondary Actors:</b></td>
    <td>Gemini API</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">User wants AI recommendations for books.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User requests AI-powered personalized book suggestions.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in.<br>• OpenAI/Gemini service configured.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Recommended book list displayed.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User clicks "AI Book Recommendations" page.<br>2. System queries user reading history from BorrowRecord table.<br>3. System sends reading prompt to AI Recommendation API. (E1)<br>4. System parses AI response into list of recommended ISBNs.<br>5. System queries Book details and displays recommendations with explanation badges. (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Refresh recommendations<br>At Step 5, User clicks [Làm mới gợi ý].<br>1. System fetches new recommendations.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: AI service timeout<br>At Step 3: API call times out.<br>• System displays: "AI Recommendation service is temporarily unavailable."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-37</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-24: Manage Notifications

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-24: Manage Notifications</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Library Manager</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Manager wants to publish or manage system notifications.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager creates, updates, or pins system-wide announcements.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Manager is logged in.<br>• System is operational.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Notification record updated in database.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Manager navigates to "Notification Management" page.<br>2. System displays notification list.<br>3. Manager clicks [+ Tạo thông báo] button.<br>4. System opens modal dialog with Title *, Content *, Type, and Pinned checkbox.<br>5. Manager enters announcement details and clicks [Đăng thông báo]. (A1, E1)<br>6. System inserts Notification record.<br>7. System closes modal and refreshes notification list.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel notification creation<br>At Step 5, Manager clicks [Hủy].<br>1. Modal closes with no changes.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Missing notification title/content<br>At Step 5: Required fields missing.<br>• System displays: "Please fill in notification title and content."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-31, BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-25: View Notifications

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-25: View Notifications</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>User</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">User views inbox notifications.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User reads notifications sent to their account.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Notifications marked as read.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User clicks notification bell icon in header.<br>2. System queries Notification and UserNotificationStatus tables. (E1)<br>3. System displays notification dropdown list. (A1)<br>4. User clicks a notification item.<br>5. System updates readAt timestamp in UserNotificationStatus table.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Mark all as read<br>At Step 3, User clicks [Đánh dấu tất cả đã đọc].<br>1. All notifications set to read.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Notifications empty<br>At Step 2: 0 notifications.<br>• System displays: "You have no unread notifications."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-26: Manage Document Templates

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-26: Manage Document Templates</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Library Manager</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Manager creates or updates email/document templates.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager modifies template subjects and body content for automated emails.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Manager is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• DocumentTemp record updated in database.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Manager navigates to "Document Template Manager" page.<br>2. System displays list of document templates.<br>3. Manager selects a template row and clicks [Sửa mẫu văn bản].<br>4. System opens editor with Subject * and Body Content (HTML/Markdown).<br>5. Manager edits template content and clicks [Lưu mẫu văn bản]. (A1, E1)<br>6. System updates DocumentTemp record in database.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel template edit<br>At Step 5, Manager clicks [Hủy].<br>1. Template changes discarded.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Missing template body<br>At Step 5: Content is blank.<br>• System displays: "Template subject and body content cannot be empty."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-47, BR-51</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-27: Import Bulk Books

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-27: Import Bulk Books</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Chuong</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian imports bulk book records from Excel.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian uploads .xlsx file containing book titles and metadata.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Multiple Book records inserted into database.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Librarian navigates to Book Catalog page.<br>2. Librarian clicks [Nhập danh sách sách Excel] button.<br>3. System opens import modal dialog.<br>4. Librarian uploads Excel file and clicks [Xem trước danh sách]. (A1, E1)<br>5. System validates rows using BookImportValidator. (E1)<br>6. System displays preview summary.<br>7. Librarian clicks [Xác nhận nhập sách].<br>8. System inserts books in batch transaction and records in BookImportBatch.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel bulk book import<br>At Step 4, Librarian clicks [Hủy].<br>1. Import cancelled.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Corrupt Excel file<br>At Step 5: File invalid.<br>• System displays: "Invalid file format. Please use sample Excel template."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-16, BR-17, BR-27</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-28: Report Book Incident

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-28: Report Book Incident</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Chuong</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>System</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian or reader reports damaged or lost physical book copy.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian creates incident report for copy and sets status to Damaged/Lost.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• BookCopyIncident record inserted and copy status updated.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Librarian navigates to "Book Copy Incident Reporting" screen.<br>2. Librarian scans copy barcode. (E1)<br>3. System retrieves copy details.<br>4. Librarian selects Incident Type (Damaged / Lost / Misplaced) and enters description.<br>5. Librarian clicks [Gửi báo cáo sự cố]. (A1)<br>6. System inserts BookCopyIncident record and updates BookCopy status.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel incident report<br>At Step 5, Librarian clicks [Hủy].<br>1. Report cancelled.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Barcode not found<br>At Step 2: Barcode invalid.<br>• System displays: "Mã vạch bản sao sách không tồn tại."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-24, BR-28</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-29: Inventory Reconciliation

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-29: Inventory Reconciliation</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Chuong</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian conducts physical inventory reconciliation.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian scans shelf copy barcodes during inventory audit session.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• InventorySession and InventoryItem records updated.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Librarian starts new Inventory Session for location shelf. (E1)<br>2. System creates InventorySession record (status = 'In Progress').<br>3. Librarian scans copy barcodes on physical shelf.<br>4. System matches scanned location against expectedLocation in BookCopy table.<br>5. Librarian clicks [Hoàn tất kiểm kê]. (A1)<br>6. System generates reconciliation discrepancy report.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Pause session<br>At Step 5, Librarian clicks [Tạm dừng phiên].<br>1. Session saved for later resume.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Location missing<br>At Step 1: Shelf location empty.<br>• System displays: "Please enter a valid shelf location."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-44</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-30: Export User List

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-30: Export User List</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Quyet</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Admin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Admin exports user account list to Excel file.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin downloads user list matching filter criteria as .xlsx file.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Admin is logged in and viewing User List.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Excel file generated and downloaded.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Admin is on User List page (UC-07).<br>2. Admin applies search/filter criteria and clicks [Xuất Excel] button. (A1)<br>3. System queries "User", MemberProfile, Student, Lecturer tables matching filter. (E1)<br>4. System generates Excel workbook using Apache POI.<br>5. System sends HTTP download response headers, triggering file download.<br>6. System logs export transaction to AuditLogs and displays: "Xuất danh sách người dùng thành công."</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel export<br>At Step 2, Admin cancels export prompt.<br>1. User list remains displayed without file generation.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: No data available<br>At Step 3: Filter criteria returns 0 records.<br>• System displays: "No user data available for export."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-31: View My Borrowings & Reservations

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-31: View My Borrowings & Reservations</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Student, Lecturer</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Student or Lecturer views active borrowings and reservations.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User checks current loans, due dates, renewal counts, and reservation queue positions.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Borrowing and reservation summary table rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User navigates to "My Borrowings & Reservations" page from top menu.<br>2. System queries BorrowRecord and Reservation tables for active userId. (E1)<br>3. System renders active loans table (Title, Barcode, Borrow Date, Due Date, Renewal Count, Action buttons). (A1)<br>4. System renders active reservations table (Title, Queue Position, Reservation Date, Expiration Date, Action buttons).</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Renew loan<br>At Step 3, User clicks [Gia hạn mượn].<br>1. System executes Online Loan Renewal workflow (UC-17).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: No active borrowings<br>At Step 2: 0 records found.<br>• System displays: "You currently have no active borrowings or reservations."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-19, BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-32: View System Configuration

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-32: View System Configuration</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Quyet</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Quản lý thư viện, Quản trị viên (Admin)</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Manager or Admin inspects system configuration parameters.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User views global parameters such as fine rates, max loans, max renewals, and loan durations.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Authorized user is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Configuration parameters rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User navigates to "System Configurations" page from sidebar.<br>2. System queries SystemConfigurations table. (E1)<br>3. System displays configuration parameters grouped by configGroup. (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Edit configuration<br>At Step 3, User clicks [Edit Value].<br>1. System opens Update Configuration modal (UC-33).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Configurations empty<br>At Step 2: Query fails.<br>• System displays: "System configuration data unavailable."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-31</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-33: Update System Configuration

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-33: Update System Configuration</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Quyet</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Quản lý thư viện, Quản trị viên (Admin)</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Manager or Admin updates system parameters.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User modifies configuration values (e.g. daily fine rate, renewal limit).</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Authorized user is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• SystemConfigurations record updated in database.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User is on System Configuration page (UC-32).<br>2. User selects parameter row and clicks [Edit Value].<br>3. System opens Update Configuration modal.<br>4. User enters new value and description, then clicks [Lưu thay đổi]. (A1, E1)<br>5. System updates SystemConfigurations table and logs to AuditLogs.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel configuration update<br>At Step 4, User clicks [Hủy].<br>1. Modal closes without updating.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Invalid parameter value<br>At Step 4: Value is negative or invalid format.<br>• System displays: "Please enter a valid configuration parameter value."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-30, BR-31, BR-40</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-34: View System Reports

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-34: View System Reports</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Quyet</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Quản lý thư viện, Quản trị viên (Admin)</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Manager views executive analytics and library operation reports.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager views charts and summaries of borrowings, returns, overdue fines, and active readers.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Manager is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Report dashboard rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Manager navigates to "System Reports & Analytics" page.<br>2. System queries aggregated metrics from BorrowRecord, Fine, Payment, and Book tables. (E1)<br>3. System renders summary metrics cards and charts. (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Export report<br>At Step 3, Manager clicks [Export Report Excel].<br>1. System triggers Export Reports workflow (UC-35).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Report data load failure<br>At Step 2: Query timeout.<br>• System displays: "Report data currently unavailable."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-43, BR-44, BR-45</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-35: Export Reports

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-35: Export Reports</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Quyet</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Quản lý thư viện, Quản trị viên (Admin)</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Manager exports analytics report data to Excel.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager downloads operational metrics and financial summaries as Excel file.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Manager is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Excel report generated and downloaded.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Manager is on System Reports page (UC-34).<br>2. Manager selects report date range and clicks [Xuất Excel]. (A1, E1)<br>3. System queries aggregated metrics from BorrowRecord, Fine, Payment, and Book tables and generates Excel file via Apache POI.<br>4. System sends file download stream to browser.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel export<br>At Step 2, Manager cancels export.<br>1. Returns to report screen.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Date range invalid<br>At Step 2: Start Date > End Date.<br>• System displays: "Start Date cannot be greater than End Date."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-31, BR-43</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-36: Ask Chatbot

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-36: Ask Chatbot</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Thai</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Guest, User</td>
    <td><b>Secondary Actors:</b></td>
    <td>Gemini API</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">User asks AI Chatbot questions about library rules or book availability.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User interacts with integrated AI Chatbot assistant.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is on any page.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Chatbot response generated and rendered in chat window.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User clicks AI Chatbot floating widget icon.<br>2. System opens chat widget window.<br>3. User types question in prompt box and clicks [Gửi]. (A1)<br>4. System sends prompt to AI Chatbot Service. (E1)<br>5. System renders AI response message in chat bubble.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Clear chat history<br>At Step 3, User clicks [Clear History].<br>1. Chat window cleared.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: AI service unreachable<br>At Step 4: API connection failed.<br>• System displays: "AI Chatbot service is temporarily unreachable."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-37</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-37: View Chat History

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-37: View Chat History</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Thai</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>User</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">User views past AI Chatbot conversation history.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User inspects prior chat logs and questions.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Chat history logs displayed.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User opens AI Chatbot widget.<br>2. User clicks "History" tab.<br>3. System displays list of past question/answer sessions. (A1, E1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Resume past session<br>At Step 3, User clicks a past session.<br>1. Chat widget loads selected conversation.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: History empty<br>At Step 3: 0 past sessions.<br>• System displays: "No previous chat history found."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-37</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-38: View Fine History

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-38: View Fine History</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>User</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">User views fine transaction history.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User checks accrued fines, reasons, and payment statuses (Paid / Unpaid).</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Fine history list rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User navigates to "Fine History & Payments" page.<br>2. System queries Fine and Payment tables for active user. (E1)<br>3. System displays fine table (Fine ID, Borrow Record, Amount, Reason, Status, Created At, Action button). (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Pay online<br>At Step 3, User selects unpaid fine and clicks [Thanh toán Online].<br>1. System redirects to Pay Fine Online workflow (UC-39).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Fine history empty<br>At Step 2: 0 fine records.<br>• System displays: "You have no fine history records."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-22, BR-35</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-39: Pay Fine Online

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-39: Pay Fine Online</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>User</td>
    <td><b>Secondary Actors:</b></td>
    <td>SePay API</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">User pays unpaid fines online via payment gateway (VNPAY / SePay).</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User initiates online payment for library fines.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User has unpaid fines and is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Payment processed, Fine status set to 'Paid'.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User is on Fine History page (UC-38) and selects unpaid Fine record(s).<br>2. User clicks [Thanh toán Online (SePay / VNPAY)]. (A1)<br>3. System creates pending Payment record and generates payment URL.<br>4. System redirects user to Payment Gateway page.<br>5. User completes payment on gateway.<br>6. Payment gateway sends webhook callback to LMS. (E1)<br>7. System updates Payment status = 'Completed' and Fine status = 'Paid'.<br>8. System displays: "Thanh toán tiền phạt thành công."</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel online payment<br>At Step 4, User cancels payment on gateway.<br>1. System marks payment as cancelled and fine remains unpaid.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Gateway verification error<br>At Step 6: Webhook signature invalid.<br>• System rejects transaction and logs error.</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-22, BR-25, BR-53</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-40: View Audit Log

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-40: View Audit Log</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>SysQuản trị viên (Admin)</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Admin views system audit logs.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin inspects C/U/D security audit logs to track user actions.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Admin is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• AuditLog table rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Admin navigates to "System Audit Logs" page from sidebar.<br>2. System queries AuditLogs table. (E1)<br>3. System displays audit log table (Log ID, User, Action Type, Entity Name, Entity ID, Timestamp, Details). (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Export audit log<br>At Step 3, Admin clicks [Xuất Audit Log Excel].<br>1. System triggers Export Audit Log workflow (UC-41).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Audit logs empty<br>At Step 2: 0 records found.<br>• System displays: "No audit logs found matching filter criteria."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-32, BR-33, BR-34</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-41: Export Audit Log

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-41: Export Audit Log</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>SysQuản trị viên (Admin)</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Admin exports audit log records to Excel.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin downloads security and action audit log history as Excel file.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Admin is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Excel file generated and downloaded.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Admin is on Audit Logs page (UC-40).<br>2. Admin applies date/user filter and clicks [Xuất Audit Log Excel]. (A1)<br>3. System queries AuditLogs table and generates Excel file. (E1)<br>4. System sends file download stream to browser.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel export<br>At Step 2, Admin cancels export.<br>1. Returns to audit log screen.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Audit logs empty<br>At Step 3: 0 records match filter.<br>• System displays: "No audit logs available for export."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-32, BR-34</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-42: Run Overdue Processor

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-42: Run Overdue Processor</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>System, SysQuản trị viên (Admin)</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Cron job or SysAdmin triggers overdue loan processing.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">System background job identifies overdue loans, calculates daily fine amounts, and notifies users.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Cron scheduler active or SysAdmin manual trigger.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Overdue loans updated to 'Overdue' status, Fine records created, email notifications queued.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. System Cron Scheduler (or SysAdmin via manual trigger button) triggers Overdue Processor job. (A1)<br>2. Processor queries BorrowRecord table for active loans where NOW() > endDate AND status = 'Borrowed'. (E1)<br>3. For each overdue record found, Processor:<br>   a. Calculates overdue days = NOW() - endDate<br>   b. Calculates fine amount = overdue days * fineRatePerDay from SystemConfigurations<br>   c. Inserts / Updates Fine record in Fine table linked to BorrowRecord and userId<br>   d. Updates BorrowRecord status to 'Overdue'<br>   e. Creates Notification for user ("Sách của bạn đã quá hạn mượn")<br>   f. Triggers EmailService async notification to user email<br>4. Processor records execution summary in AuditLogs and system log file.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Manual trigger by SysAdmin<br>At Step 1, SysAdmin clicks [Chạy xử lý quá hạn ngay] on Admin Dashboard.<br>1. System executes processor synchronously and displays execution summary modal.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Database connection failure during cron execution<br>At Step 2: ConnectionPool unavailable.<br>• System logs error to application error log and reschedules job execution.</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-22, BR-35</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-43: Auto-cancel Expired Reservations

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-43: Auto-cancel Expired Reservations</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Bao</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>System, SysQuản trị viên (Admin)</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">System automatically cancels expired reservation holds.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Background job cancels pending reservations when expiration date passes without reader pick-up.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• System cron active.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Expired Reservation status updated to 'Expired', next queue position notified.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. System Cron Scheduler (or SysAdmin manual trigger) executes Reservation Auto-cancel job. (A1)<br>2. Job queries Reservation table for records where status = 'Pending' AND NOW() > expirationDate. (E1)<br>3. For each expired reservation found, Job:<br>   a. Updates Reservation status to 'Expired'<br>   b. Re-assigns queuePosition for remaining reservations of that book<br>   c. Checks next user in queue for BookCopy; if found, sends Notification to next user ("Sách đã sẵn sàng cho bạn")<br>4. Job records execution summary in AuditLogs.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Manual execution by SysAdmin<br>At Step 1, SysAdmin clicks [Quét hủy đặt giữ chỗ quá hạn].<br>1. Job executes and displays summary modal.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Database transaction error<br>At Step 2/3: Transaction error.<br>• System rolls back partial changes, logs error, and retries next batch.</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-20, BR-36</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-44: View Thủ thư Dashboard

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-44: View Thủ thư Dashboard</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Thai</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian views operational dashboard.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian inspects daily check-out/check-in metrics and operational shortcuts.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Operational dashboard rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Librarian logs in and navigates to Librarian Dashboard.<br>2. System queries BorrowRecord, BookCopy, Fine, BookCopyIncident tables. (E1)<br>3. System renders Dashboard view showing operational metrics and action shortcuts:<br>   a. Operational Metrics Cards: Today's Check-outs, Today's Check-ins, Pending Damaged Reports, Overdue Loans Count<br>   b. Quick Action Shortcuts: [Lập phiếu mượn], [Nhận trả sách], [Báo hỏng sách]<br>   c. Recent Activity Feed: Latest desk transactions<br>4. Librarian views dashboard or navigates to shortcut. (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Click quick shortcut<br>At Step 3b/4, Librarian clicks [Lập phiếu mượn].<br>1. System redirects directly to Desk Check-out screen (UC-18).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Failed loading metrics<br>At Step 2: Database query timeout.<br>• System displays alert message and renders cached summary.</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-45: View Manager Dashboard

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-45: View Manager Dashboard</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Quyet</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Library Manager</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Library Manager views executive overview dashboard.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager inspects catalog metrics, monthly revenue, fine stats, and announcements.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Manager is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Executive dashboard rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Library Manager logs in and navigates to Manager Dashboard.<br>2. System queries Book, BorrowRecord, Fine, Payment, Notification, SystemConfigurations tables. (E1)<br>3. System renders Executive Overview metrics cards and shortcuts:<br>   a. Catalog Metrics: Total Book Titles, Total Physical Copies, Active Loans Ratio<br>   b. Financial Metrics: Monthly Fines Collected, Pending Revenue<br>   c. System Announcements Overview & Management Shortcuts<br>4. Manager reviews operational performance. (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Navigate to Report Details<br>At Step 3/4, Manager clicks [Xem báo cáo chi tiết].<br>1. System redirects to System Reports page (UC-34).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Data load failure<br>At Step 2: Query execution failure.<br>• System displays error notification.</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-46: View Quản trị viên (Quản trị viên (Quản trị viên (Admin))) Dashboard

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-46: View Quản trị viên (Quản trị viên (Quản trị viên (Admin))) Dashboard</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Admin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Admin views system security and account overview dashboard.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin monitors total accounts, locked accounts, security alerts, and recent audit logs.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Admin is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Admin dashboard rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Admin logs in and navigates to SysAdmin Dashboard.<br>2. System queries "User", UserLockReason, AuditLogs, SystemConfigurations tables. (E1)<br>3. System renders Admin System Overview cards and Audit Log preview widget:<br>   a. User Statistics Cards: Total Accounts, Active Students, Active Lecturers, Staff Count, Locked Accounts Count<br>   b. Security Alert Box: Recent failed login spikes, Locked account reasons<br>   c. Recent Audit Logs Widget: Latest 10 C/U/D system actions<br>4. Admin reviews system status. (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Click Audit Log details<br>At Step 3/4, Admin clicks [Xem tất cả Audit Logs].<br>1. System redirects to Audit Log Management page (UC-40).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: System metric error<br>At Step 2: Query failure.<br>• System displays error message.</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-47: View Public Homepage

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-47: View Public Homepage</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Guest</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Guest or User views public homepage.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User accesses LMS home page featuring book search hero section and announcements.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• System is operational.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Public homepage rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Guest or User accesses LMS web application base URL.<br>2. System queries featured books and announcements from database. (E1)<br>3. System renders Public Homepage containing hero search bar, featured books carousel, and announcements.<br>4. User browses homepage content or performs quick book search. (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Search book from Hero banner<br>At Step 3/4, User enters keyword in hero search bar.<br>1. System redirects to Search & View Books page (UC-22) with search results.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Homepage asset load error<br>At Step 2: Static assets or DB connection issue.<br>• System renders static fallback layout.</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-37</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-48: View Library Policies

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-48: View Library Policies</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Guest, User</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Guest or User inspects library rules and policies.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User views borrowing limits, fine rates, opening hours, and card guidelines.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• System is operational.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Library policies page rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Guest or User clicks "Nội quy & Chính sách thư viện" from header or footer.<br>2. System queries Notification and SystemConfigurations tables for policy documents. (E1)<br>3. System displays Library Policies Page detailing loan rules, fine rates, opening hours, and card guidelines.<br>4. User views policy documents or downloads PDF. (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Download policy PDF<br>At Step 4, User clicks [Tải nội quy PDF].<br>1. System initiates PDF download.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Policy document missing<br>At Step 2: Content unavailable.<br>• System displays: "Library policy content is currently being updated."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-37</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-49: View Full Borrow/Return History

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-49: View Full Borrow/Return History</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Bao</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Student, Lecturer</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">User views complete historical log of all past loans and returns.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User views full lifetime history of borrowed and returned books.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Complete borrowing history table rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User navigates to "My Borrowings" page and selects "Full History" tab.<br>2. System queries BorrowRecord table for active userId. (E1)<br>3. System renders complete loan history table (Title, Barcode, Borrow Date, Due Date, Returned Date, Status). (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Export history<br>At Step 3, User clicks [Xuất lịch sử mượn trả].<br>1. System generates Excel/PDF file of user loan history.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Loan history empty<br>At Step 2: 0 records found.<br>• System displays: "You have no past borrowing history."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-19</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-50: Cancel Online Reservation

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-50: Cancel Online Reservation</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Bao</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Student, Lecturer</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">User cancels pending online reservation request.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User cancels reservation while status is still 'Pending'.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User has pending reservation and is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Reservation status updated to 'Cancelled'.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. User is on My Reservations page (UC-31).<br>2. User selects pending reservation and clicks [Hủy đặt giữ chỗ]. (E1)<br>3. System prompts confirmation modal: "Are you sure you want to cancel this reservation?"<br>4. User clicks [Xác nhận hủy]. (A1)<br>5. System updates Reservation status = 'Cancelled' and updates queuePosition for remaining users.<br>6. System displays: "Hủy đặt giữ chỗ sách thành công."</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Dismiss cancellation<br>At Step 4, User clicks [Giữ nguyên đặt chỗ].<br>1. Reservation remains pending.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Reservation already fulfilled or expired<br>At Step 2: Status is no longer 'Pending'.<br>• System displays: "Reservation cannot be cancelled because it is already fulfilled or expired."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-20</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-51: Register Desk Reservation

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-51: Register Desk Reservation</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Thai</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian registers desk reservation hold for reader.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian places reservation hold for reader at desk.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Reservation record created.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Librarian is on Desk Circulation screen.<br>2. Librarian enters Reader Code and scans Book Barcode.<br>3. System checks user eligibility and reservation limits. (E1)<br>4. Librarian clicks [Đăng ký giữ chỗ tại quầy]. (A1)<br>5. System inserts Reservation record and assigns queuePosition.<br>6. System displays: "Đặt giữ chỗ sách trực tuyến thành công."</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel hold<br>At Step 4, Librarian clicks [Hủy].<br>1. Registration cancelled.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Reader has overdue loans<br>At Step 3: Overdue count > 0.<br>• System displays: "Reader has overdue loans. Cannot register hold."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-19, BR-21, BR-22, BR-41</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-52: View Book Import History

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-52: View Book Import History</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Chuong</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian or Manager views book import batch history and error logs.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User inspects history of bulk book imports and error row logs.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Import batch history table displayed.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Librarian or Manager navigates to "Lịch sử Import Sách" from sidebar.<br>2. System queries BookImportBatch and BookImportError tables. (E1)<br>3. System displays Import Batch History table: Batch ID, File Name, Imported By, Total Rows, Success Rows, Failed Rows, Status (Completed/Failed), Created At.<br>4. User clicks a batch row. (A1)<br>5. System opens Import Batch Detail modal showing line-by-line validation error log (Sheet Name, Row Number, Column Name, Error Message).</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Download error log Excel<br>At Step 5, User clicks [Tải file lỗi Excel].<br>1. System generates Excel file containing error rows for correction.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Import history empty<br>At Step 2: Zero batch import records.<br>• System displays: "No book import history records found."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-38</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-53: Configure Payment Gateway Integration

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-53: Configure Payment Gateway Integration</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Library Manager</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Manager configures SePay / VNPAY API keys and webhook settings.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager sets client IDs, secret tokens, and webhook URLs for payment integration.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Manager is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• SystemConfigurations updated securely.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Library Manager accesses "Cấu hình cổng thanh toán" from sidebar.<br>2. System displays Payment Integration configuration form (VNPAY / SePay parameters).<br>3. Manager updates Client ID, Secret Key, Merchant Code, and Webhook URL fields.<br>4. Manager clicks [Lưu cấu hình cổng thanh toán]. (A1, E1)<br>5. System validates parameter inputs. (E1)<br>6. System updates SystemConfigurations table and logs to AuditLogs.<br>7. System displays: "Cập nhật cấu hình / mẫu văn bản thành công."</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Test webhook connection<br>At Step 4, Manager clicks [Kiểm tra kết nối Webhook].<br>1. System dispatches test ping to webhook URL.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Invalid API key format<br>At Step 5: Key field blank or invalid format.<br>• System displays: "Please enter valid payment gateway credentials."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-53, BR-31</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-54: View Staff Performance Report

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-54: View Staff Performance Report</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Quyet</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-06-27</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Library Manager</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Manager evaluates desk clerk productivity and metrics.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager views check-outs, check-ins, and cash fine collections grouped by staff member.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• Manager is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Staff performance metrics rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Library Manager navigates to "Báo cáo hiệu suất nhân viên" from sidebar.<br>2. System queries BorrowRecord, Payment, and "User" tables. (E1)<br>3. System displays Staff Performance Table showing: Staff ID, Full Name, Total Check-outs, Total Check-ins, Total Cash Fines Collected, Incident Reports Count.<br>4. Manager selects date range filter. (A1)</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Filter by Date Range<br>At Step 4, Manager selects Start Date & End Date.<br>1. Table refreshes with staff performance metrics for selected period.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: No staff activity found<br>At Step 2: Query returns 0 staff records.<br>• System displays: "Không có dữ liệu hiệu suất nhân viên cho khoảng thời gian này."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-52</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-55: Submit & Vote Book Suggestion

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-55: Submit & Vote Book Suggestion</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-07-05</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Student, Lecturer</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Student or Lecturer submits new book suggestion or upvotes existing suggestion.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User proposes new book titles or upvotes suggestions to prioritize library acquisitions.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• BookSuggestion record created or upvoteCount incremented.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Student or Lecturer navigates to "Đề xuất mua sách mới" (Book Suggestions).<br>2. System queries BookSuggestion and SuggestionVote tables.<br>3. System displays Book Suggestion Page with:<br>   a. List of user-submitted book suggestions ordered by upvoteCount descending<br>   b. Each item displays: Book Title, Author, Publisher, Reason, Upvote Count badge, Status (Pending / Approved / Purchased), Action buttons<br>   c. [+ Đề xuất sách mới] button<br>4. User clicks [+ Đề xuất sách mới].<br>5. System opens Modal Dialog with fields: Tên sách *, Tác giả *, Nhà xuất bản, Mã ISBN, Lý do đề xuất *.<br>6. User enters suggestion details and clicks [Gửi đề xuất]. (A1, E1)<br>7. System inserts record into BookSuggestion table (status = 'Pending', upvoteCount = 1), inserts record into SuggestionVote for current user.<br>8. Alternatively, for existing suggestion, User clicks [Tôi cũng cần (+1)] button. (A2, E2)<br>9. System creates SuggestionVote record, increments upvoteCount in BookSuggestion table by +1.<br>10. System logs transaction to AuditLogs, closes modal, displays: "Gửi đề xuất sách thành công", and refreshes suggestion list.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel submission<br>At Step 6, User clicks [Hủy] or [×] on modal.<br>1. Modal closes with no suggestion saved.<br><br>A2: Cancel upvote<br>At Step 8, User clicks [Hủy vote].<br>1. System removes SuggestionVote record and decrements upvoteCount.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Missing mandatory suggestion fields<br>At Step 6: Title, Author, or Reason is empty.<br>• System displays: "Vui lòng nhập Tên sách, Tác giả và Lý do đề xuất."<br>• Modal remains open.<br><br>E2: User already voted for this suggestion<br>At Step 8: User already has SuggestionVote record for this suggestion.<br>• System displays: "Bạn đã bình chọn cho đề xuất sách này rồi."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-56, BR-57, BR-58</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

## UC-56: Manage Book Suggestion Status

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-56: Manage Book Suggestion Status</b></td>
  </tr>
  <tr>
    <td><b>Created By:</b></td>
    <td width="30%">Tuan</td>
    <td width="20%"><b>Date Created:</b></td>
    <td width="30%">2026-07-05</td>
  </tr>
  <tr>
    <td><b>Primary Actor:</b></td>
    <td>Librarian, Library Manager</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Librarian or Manager reviews and updates book suggestion statuses.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User reviews proposed book list ordered by upvotes and updates status (Pending, Approved, Rejected, Purchased).</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">• User is logged in with staff role.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">• Suggestion status updated and notification sent to proposer.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">1. Librarian or Library Manager navigates to "Quản lý đề xuất mua sách" from sidebar.<br>2. System queries BookSuggestion, SuggestionVote, "User", MemberProfile tables.<br>3. System displays Suggestion Management Table ordered by upvoteCount descending showing: Suggestion ID, Book Title, Author, Suggested By, Upvote Count, Status Badge, Review Notes, Action dropdown.<br>4. User selects a suggestion row and clicks [Cập nhật trạng thái].<br>5. System opens Status Update Modal Dialog with:<br>   a. Trạng thái mới * — dropdown (Đã phê duyệt / Từ chối / Đã mua về kho / Đang chờ)<br>   b. Ghi chú phản hồi thủ thư — text area<br>   c. [Hủy] and [Lưu cập nhật] buttons<br>6. User selects new status, enters review notes, and clicks [Lưu cập nhật]. (A1, E1)<br>7. System updates status and reviewNotes in BookSuggestion table. (E1)<br>8. System creates Notification for submitting user ("Đề xuất mua sách của bạn đã được phê duyệt/mua về").<br>9. System records UPDATE_SUGGESTION_STATUS in AuditLogs, closes modal, displays: "Cập nhật trạng thái đề xuất thành công", and refreshes table.</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">A1: Cancel status update<br>At Step 6, User clicks [Hủy] or [×] on modal.<br>1. Modal closes without updating suggestion status.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">E1: Database transaction error during update<br>At Step 7: Connection failure or update error.<br>• System rolls back transaction and displays: "Không thể cập nhật trạng thái đề xuất. Vui lòng thử lại."</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">• BR-56, BR-57, BR-58</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">• Response time must be less than 3 seconds.<br>• All data transmitted must be encrypted via TLS 1.2+.<br>• The UI must be responsive and accessible.</td>
  </tr>
</table>

---

