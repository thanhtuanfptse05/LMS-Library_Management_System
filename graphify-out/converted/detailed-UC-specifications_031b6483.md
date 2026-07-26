<!-- converted from detailed-UC-specifications.docx -->

## 1.1 UC-01: Login

## 1.2 UC-02: Logout

## 1.3 UC-03: Reset Password

## 1.4 UC-04: View Profile

## 1.5 UC-05: Update Profile

## 1.6 UC-06: Change Password

## 1.7 UC-07: View User List

## 1.8 UC-08: View User Detail

## 1.9 UC-09: Create Single Account

## 1.10 UC-10: Import Bulk Accounts

## 1.11 UC-11: Update User Account

## 1.12 UC-12: View Book Catalog & Inventory

## 1.13 UC-13: Manage Book Catalog

## 1.14 UC-14: Manage Physical Copies

## 1.15 UC-15: Manage Tags & Categories

## 1.16 UC-16: Reserve Book Online

## 1.17 UC-17: Renew Book Online

## 1.18 UC-18: Desk Check-out

## 1.19 UC-19: Desk Check-in

## 1.20 UC-20: Process Cash Payment

## 1.21 UC-21: Login with Google

## 1.22 UC-22: Search & View Books

## 1.23 UC-23: Get AI Recommendation

## 1.24 UC-24: Manage Notifications

## 1.25 UC-25: View Notifications

## 1.26 UC-26: Manage Document Templates

## 1.27 UC-27: Import Bulk Books

## 1.28 UC-28: Report Book Incident

## 1.29 UC-29: Inventory Reconciliation

## 1.30 UC-30: Export User List

## 1.31 UC-31: View My Borrowings & Reservations

## 1.32 UC-32: View System Configuration

## 1.33 UC-33: Update System Configuration

## 1.34 UC-34: View System Reports

## 1.35 UC-35: Export Reports

## 1.36 UC-36: Ask Chatbot

## 1.37 UC-37: View Chat History

## 1.38 UC-38: View Fine History

## 1.39 UC-39: Pay Fine Online

## 1.40 UC-40: View Audit Log

## 1.41 UC-41: Export Audit Log

## 1.42 UC-42: Run Overdue Processor

## 1.43 UC-43: Auto-cancel Expired Reservations

## 1.44 UC-44: View Librarian Dashboard

## 1.45 UC-45: View Manager Dashboard

## 1.46 UC-46: View Admin Dashboard

## 1.47 UC-47: View Public Homepage

## 1.48 UC-48: View Library Policies

## 1.49 UC-49: View Full Borrow/Return History

## 1.50 UC-50: Cancel Online Reservation

## 1.51 UC-51: Register Desk Reservation

## 1.52 UC-52: View Book Import History

## 1.53 UC-53: Configure Payment Gateway Integration

## 1.54 UC-54: View Staff Performance Report

## 1.55 UC-55: Submit & Vote Book Suggestion
## 1.56 UC-56: Manage Book Suggestion Status

| UC ID and Name: | UC-01: Login | UC-01: Login | UC-01: Login |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | Guest, User | Secondary Actors: | None |
| Trigger: | The user wants to log in to access system features. | The user wants to log in to access system features. | The user wants to log in to access system features. |
| Description: | The user provides credentials (Email and Password) to authenticate identity and access role-specific dashboards. | The user provides credentials (Email and Password) to authenticate identity and access role-specific dashboards. | The user provides credentials (Email and Password) to authenticate identity and access role-specific dashboards. |
| Preconditions: | • The user is on the Login page and has an active account.
• System is operational and database is accessible. | • The user is on the Login page and has an active account.
• System is operational and database is accessible. | • The user is on the Login page and has an active account.
• System is operational and database is accessible. |
| Postconditions: | • The user is authenticated and redirected to their dashboard.
• System logs the transaction in AuditLogs. | • The user is authenticated and redirected to their dashboard.
• System logs the transaction in AuditLogs. | • The user is authenticated and redirected to their dashboard.
• System logs the transaction in AuditLogs. |
| Normal Flow: | 1. User navigates to the Login page.
2. System displays login form with Email and Password input fields.
3. User enters registered Email and Password. (E1)
4. User clicks [Đăng nhập] button. (A1)
5. System validates that input fields are not empty. (E1)
6. System queries "User" table and verifies Email and BCrypt password hash. (E2, E3)
7. System creates a secure session (HttpSession), logs transaction in AuditLogs, and redirects user to their role-specific dashboard. | 1. User navigates to the Login page.
2. System displays login form with Email and Password input fields.
3. User enters registered Email and Password. (E1)
4. User clicks [Đăng nhập] button. (A1)
5. System validates that input fields are not empty. (E1)
6. System queries "User" table and verifies Email and BCrypt password hash. (E2, E3)
7. System creates a secure session (HttpSession), logs transaction in AuditLogs, and redirects user to their role-specific dashboard. | 1. User navigates to the Login page.
2. System displays login form with Email and Password input fields.
3. User enters registered Email and Password. (E1)
4. User clicks [Đăng nhập] button. (A1)
5. System validates that input fields are not empty. (E1)
6. System queries "User" table and verifies Email and BCrypt password hash. (E2, E3)
7. System creates a secure session (HttpSession), logs transaction in AuditLogs, and redirects user to their role-specific dashboard. |
| Alternative Flows: | A1: Cancel login / Return to Homepage
At Step 4, User clicks [Hủy] or logo.
1. System discards entered credentials.
2. User is redirected to Public Homepage (UC-47). | A1: Cancel login / Return to Homepage
At Step 4, User clicks [Hủy] or logo.
1. System discards entered credentials.
2. User is redirected to Public Homepage (UC-47). | A1: Cancel login / Return to Homepage
At Step 4, User clicks [Hủy] or logo.
1. System discards entered credentials.
2. User is redirected to Public Homepage (UC-47). |
| Exceptions: | E1: Empty mandatory inputs
At Step 5: User leaves Email or Password field blank.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."
• Login form remains open.

E2: Incorrect credentials
At Step 6: Entered Email or Password does not match database.
• System displays: "Tài khoản hoặc mật khẩu không chính xác."

E3: Account locked due to security policy
At Step 6: Account status is "Locked" or failed login attempts threshold reached.
• System displays: "Tài khoản tạm thời bị khóa do nhập sai nhiều lần." | E1: Empty mandatory inputs
At Step 5: User leaves Email or Password field blank.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."
• Login form remains open.

E2: Incorrect credentials
At Step 6: Entered Email or Password does not match database.
• System displays: "Tài khoản hoặc mật khẩu không chính xác."

E3: Account locked due to security policy
At Step 6: Account status is "Locked" or failed login attempts threshold reached.
• System displays: "Tài khoản tạm thời bị khóa do nhập sai nhiều lần." | E1: Empty mandatory inputs
At Step 5: User leaves Email or Password field blank.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."
• Login form remains open.

E2: Incorrect credentials
At Step 6: Entered Email or Password does not match database.
• System displays: "Tài khoản hoặc mật khẩu không chính xác."

E3: Account locked due to security policy
At Step 6: Account status is "Locked" or failed login attempts threshold reached.
• System displays: "Tài khoản tạm thời bị khóa do nhập sai nhiều lần." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-01, BR-02, BR-03, BR-05, BR-06 | • BR-01, BR-02, BR-03, BR-05, BR-06 | • BR-01, BR-02, BR-03, BR-05, BR-06 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-02: Logout | UC-02: Logout | UC-02: Logout |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | User | Secondary Actors: | None |
| Trigger: | The user wants to terminate their active system session. | The user wants to terminate their active system session. | The user wants to terminate their active system session. |
| Description: | The user logs out of the system, invalidating the active HTTP session to protect personal data. | The user logs out of the system, invalidating the active HTTP session to protect personal data. | The user logs out of the system, invalidating the active HTTP session to protect personal data. |
| Preconditions: | • The user is logged in.
• System is operational and database is accessible. | • The user is logged in.
• System is operational and database is accessible. | • The user is logged in.
• System is operational and database is accessible. |
| Postconditions: | • The user session is invalidated and redirected to the login page.
• System logs the transaction in AuditLogs. | • The user session is invalidated and redirected to the login page.
• System logs the transaction in AuditLogs. | • The user session is invalidated and redirected to the login page.
• System logs the transaction in AuditLogs. |
| Normal Flow: | 1. Authenticated User clicks [Đăng xuất] button on top header bar.
2. System displays confirmation modal dialog with [Hủy] and [Đăng xuất] buttons.
3. User clicks [Đăng xuất]. (A1)
4. System invalidates current HttpSession, clears security context, and logs action to AuditLogs.
5. System closes dialog and redirects user to Login page with success message: "Đăng xuất thành công." | 1. Authenticated User clicks [Đăng xuất] button on top header bar.
2. System displays confirmation modal dialog with [Hủy] and [Đăng xuất] buttons.
3. User clicks [Đăng xuất]. (A1)
4. System invalidates current HttpSession, clears security context, and logs action to AuditLogs.
5. System closes dialog and redirects user to Login page with success message: "Đăng xuất thành công." | 1. Authenticated User clicks [Đăng xuất] button on top header bar.
2. System displays confirmation modal dialog with [Hủy] and [Đăng xuất] buttons.
3. User clicks [Đăng xuất]. (A1)
4. System invalidates current HttpSession, clears security context, and logs action to AuditLogs.
5. System closes dialog and redirects user to Login page with success message: "Đăng xuất thành công." |
| Alternative Flows: | A1: Cancel logout
At Step 3, User clicks [Hủy] or [×] on dialog.
1. Confirmation dialog closes.
2. User remains logged in on current page. | A1: Cancel logout
At Step 3, User clicks [Hủy] or [×] on dialog.
1. Confirmation dialog closes.
2. User remains logged in on current page. | A1: Cancel logout
At Step 3, User clicks [Hủy] or [×] on dialog.
1. Confirmation dialog closes.
2. User remains logged in on current page. |
| Exceptions: | E1: Session already expired
At Step 1: Session timed out prior to user action.
• System automatically redirects user to Login page. | E1: Session already expired
At Step 1: Session timed out prior to user action.
• System automatically redirects user to Login page. | E1: Session already expired
At Step 1: Session timed out prior to user action.
• System automatically redirects user to Login page. |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-39 | • BR-39 | • BR-39 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-03: Reset Password | UC-03: Reset Password | UC-03: Reset Password |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | Guest | Secondary Actors: | System |
| Trigger: | Guest forgets password and wants to request a temporary one. | Guest forgets password and wants to request a temporary one. | Guest forgets password and wants to request a temporary one. |
| Description: | The guest enters registered email to receive an OTP code to reset their password. | The guest enters registered email to receive an OTP code to reset their password. | The guest enters registered email to receive an OTP code to reset their password. |
| Preconditions: | • The guest is on the Forgot Password page.
• System is operational and database is accessible. | • The guest is on the Forgot Password page.
• System is operational and database is accessible. | • The guest is on the Forgot Password page.
• System is operational and database is accessible. |
| Postconditions: | • Password reset confirmation is displayed, and password updated upon OTP verification.
• System logs the transaction in AuditLogs. | • Password reset confirmation is displayed, and password updated upon OTP verification.
• System logs the transaction in AuditLogs. | • Password reset confirmation is displayed, and password updated upon OTP verification.
• System logs the transaction in AuditLogs. |
| Normal Flow: | 1. User clicks "Forgot Password" link on Login page.
2. System displays "Reset Password" modal dialog with Email input field.
3. User enters registered Email and clicks [Gửi OTP]. (A1, E1)
4. System validates Email existence in "User" table. (E1)
5. System generates 6-digit OTP code with 5-minute expiration and dispatches email via async EmailService.
6. System updates dialog prompt to enter OTP code and New Password.
7. User enters OTP code, New Password, and clicks [Xác nhận]. (E2, E3)
8. System validates OTP code and updates passwordHash using BCrypt in "User" table.
9. System logs transaction to AuditLogs and displays: "Đặt lại mật khẩu thành công." | 1. User clicks "Forgot Password" link on Login page.
2. System displays "Reset Password" modal dialog with Email input field.
3. User enters registered Email and clicks [Gửi OTP]. (A1, E1)
4. System validates Email existence in "User" table. (E1)
5. System generates 6-digit OTP code with 5-minute expiration and dispatches email via async EmailService.
6. System updates dialog prompt to enter OTP code and New Password.
7. User enters OTP code, New Password, and clicks [Xác nhận]. (E2, E3)
8. System validates OTP code and updates passwordHash using BCrypt in "User" table.
9. System logs transaction to AuditLogs and displays: "Đặt lại mật khẩu thành công." | 1. User clicks "Forgot Password" link on Login page.
2. System displays "Reset Password" modal dialog with Email input field.
3. User enters registered Email and clicks [Gửi OTP]. (A1, E1)
4. System validates Email existence in "User" table. (E1)
5. System generates 6-digit OTP code with 5-minute expiration and dispatches email via async EmailService.
6. System updates dialog prompt to enter OTP code and New Password.
7. User enters OTP code, New Password, and clicks [Xác nhận]. (E2, E3)
8. System validates OTP code and updates passwordHash using BCrypt in "User" table.
9. System logs transaction to AuditLogs and displays: "Đặt lại mật khẩu thành công." |
| Alternative Flows: | A1: Cancel password reset
At Step 3, User clicks [Hủy] or [×] on dialog.
1. Dialog closes with no data saved.
2. User returns to Login page. | A1: Cancel password reset
At Step 3, User clicks [Hủy] or [×] on dialog.
1. Dialog closes with no data saved.
2. User returns to Login page. | A1: Cancel password reset
At Step 3, User clicks [Hủy] or [×] on dialog.
1. Dialog closes with no data saved.
2. User returns to Login page. |
| Exceptions: | E1: Email not registered
At Step 4: Entered Email does not exist in "User" table.
• System displays: "Email không tồn tại trong hệ thống."

E2: Invalid or expired OTP
At Step 8: OTP code is wrong or expired (> 5 minutes).
• System displays: "Mã OTP không hợp lệ hoặc đã hết hạn."

E3: Weak password
At Step 8: New password does not satisfy length rule.
• System displays: "Mật khẩu mới phải có tối thiểu 8 ký tự." | E1: Email not registered
At Step 4: Entered Email does not exist in "User" table.
• System displays: "Email không tồn tại trong hệ thống."

E2: Invalid or expired OTP
At Step 8: OTP code is wrong or expired (> 5 minutes).
• System displays: "Mã OTP không hợp lệ hoặc đã hết hạn."

E3: Weak password
At Step 8: New password does not satisfy length rule.
• System displays: "Mật khẩu mới phải có tối thiểu 8 ký tự." | E1: Email not registered
At Step 4: Entered Email does not exist in "User" table.
• System displays: "Email không tồn tại trong hệ thống."

E2: Invalid or expired OTP
At Step 8: OTP code is wrong or expired (> 5 minutes).
• System displays: "Mã OTP không hợp lệ hoặc đã hết hạn."

E3: Weak password
At Step 8: New password does not satisfy length rule.
• System displays: "Mật khẩu mới phải có tối thiểu 8 ký tự." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-04, BR-07, BR-47 | • BR-04, BR-07, BR-47 | • BR-04, BR-07, BR-47 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-04: View Profile | UC-04: View Profile | UC-04: View Profile |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | User | Secondary Actors: | None |
| Trigger: | User wants to view their profile details. | User wants to view their profile details. | User wants to view their profile details. |
| Description: | The user accesses the profile section to view personal identification, contact details, and role metadata. | The user accesses the profile section to view personal identification, contact details, and role metadata. | The user accesses the profile section to view personal identification, contact details, and role metadata. |
| Preconditions: | • The user is logged in.
• System is operational and database is accessible. | • The user is logged in.
• System is operational and database is accessible. | • The user is logged in.
• System is operational and database is accessible. |
| Postconditions: | • System displays user profile details successfully.
• System logs transaction in AuditLogs. | • System displays user profile details successfully.
• System logs transaction in AuditLogs. | • System displays user profile details successfully.
• System logs transaction in AuditLogs. |
| Normal Flow: | 1. Authenticated User clicks "My Profile" from header user menu.
2. System queries "User", MemberProfile, and role-specific tables (Student / Lecturer / Librarian / LibraryManager / Admin). (E1)
3. System displays Profile page with personal details: Full Name, Email, Phone, Gender, Date of Birth, Role Code, and Membership status.
4. User views profile details or proceeds to update. (A1) | 1. Authenticated User clicks "My Profile" from header user menu.
2. System queries "User", MemberProfile, and role-specific tables (Student / Lecturer / Librarian / LibraryManager / Admin). (E1)
3. System displays Profile page with personal details: Full Name, Email, Phone, Gender, Date of Birth, Role Code, and Membership status.
4. User views profile details or proceeds to update. (A1) | 1. Authenticated User clicks "My Profile" from header user menu.
2. System queries "User", MemberProfile, and role-specific tables (Student / Lecturer / Librarian / LibraryManager / Admin). (E1)
3. System displays Profile page with personal details: Full Name, Email, Phone, Gender, Date of Birth, Role Code, and Membership status.
4. User views profile details or proceeds to update. (A1) |
| Alternative Flows: | A1: Navigate to edit mode
At Step 4, User clicks [Chỉnh sửa hồ sơ].
1. System redirects user to Update Profile page (UC-05). | A1: Navigate to edit mode
At Step 4, User clicks [Chỉnh sửa hồ sơ].
1. System redirects user to Update Profile page (UC-05). | A1: Navigate to edit mode
At Step 4, User clicks [Chỉnh sửa hồ sơ].
1. System redirects user to Update Profile page (UC-05). |
| Exceptions: | E1: Profile record not found
At Step 2: MemberProfile record missing in database.
• System logs database error and displays: "Không tìm thấy dữ liệu hồ sơ cá nhân." | E1: Profile record not found
At Step 2: MemberProfile record missing in database.
• System logs database error and displays: "Không tìm thấy dữ liệu hồ sơ cá nhân." | E1: Profile record not found
At Step 2: MemberProfile record missing in database.
• System logs database error and displays: "Không tìm thấy dữ liệu hồ sơ cá nhân." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-08 | • BR-08 | • BR-08 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-05: Update Profile | UC-05: Update Profile | UC-05: Update Profile |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | User | Secondary Actors: | None |
| Trigger: | User wants to edit their contact details. | User wants to edit their contact details. | User wants to edit their contact details. |
| Description: | The user modifies editable fields of their profile (e.g., Phone Number, Date of Birth, Gender). | The user modifies editable fields of their profile (e.g., Phone Number, Date of Birth, Gender). | The user modifies editable fields of their profile (e.g., Phone Number, Date of Birth, Gender). |
| Preconditions: | • The user is logged in and viewing profile.
• System is operational and database is accessible. | • The user is logged in and viewing profile.
• System is operational and database is accessible. | • The user is logged in and viewing profile.
• System is operational and database is accessible. |
| Postconditions: | • The updated profile details are saved to database.
• System logs transaction in AuditLogs. | • The updated profile details are saved to database.
• System logs transaction in AuditLogs. | • The updated profile details are saved to database.
• System logs transaction in AuditLogs. |
| Normal Flow: | 1. User is on Profile page (UC-04) and clicks [Chỉnh sửa hồ sơ].
2. System displays Profile Edit form pre-filled with current details:
   a. Full Name *
   b. Phone Number *
   c. Gender
   d. Date of Birth
   e. [Hủy] and [Lưu thay đổi] buttons
3. User updates personal details and clicks [Lưu thay đổi]. (A1, E1)
4. System validates required fields and phone format. (E1)
5. System updates MemberProfile table in PostgreSQL and logs to AuditLogs.
6. System displays: "Cập nhật hồ sơ thành công" and refreshes profile view. | 1. User is on Profile page (UC-04) and clicks [Chỉnh sửa hồ sơ].
2. System displays Profile Edit form pre-filled with current details:
   a. Full Name *
   b. Phone Number *
   c. Gender
   d. Date of Birth
   e. [Hủy] and [Lưu thay đổi] buttons
3. User updates personal details and clicks [Lưu thay đổi]. (A1, E1)
4. System validates required fields and phone format. (E1)
5. System updates MemberProfile table in PostgreSQL and logs to AuditLogs.
6. System displays: "Cập nhật hồ sơ thành công" and refreshes profile view. | 1. User is on Profile page (UC-04) and clicks [Chỉnh sửa hồ sơ].
2. System displays Profile Edit form pre-filled with current details:
   a. Full Name *
   b. Phone Number *
   c. Gender
   d. Date of Birth
   e. [Hủy] and [Lưu thay đổi] buttons
3. User updates personal details and clicks [Lưu thay đổi]. (A1, E1)
4. System validates required fields and phone format. (E1)
5. System updates MemberProfile table in PostgreSQL and logs to AuditLogs.
6. System displays: "Cập nhật hồ sơ thành công" and refreshes profile view. |
| Alternative Flows: | A1: Cancel profile editing
At Step 3, User clicks [Hủy] or [×].
1. Form changes are discarded.
2. User returns to read-only Profile view. | A1: Cancel profile editing
At Step 3, User clicks [Hủy] or [×].
1. Form changes are discarded.
2. User returns to read-only Profile view. | A1: Cancel profile editing
At Step 3, User clicks [Hủy] or [×].
1. Form changes are discarded.
2. User returns to read-only Profile view. |
| Exceptions: | E1: Invalid input data
At Step 4: Name is empty or Phone number format is invalid.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc và số điện thoại hợp lệ." | E1: Invalid input data
At Step 4: Name is empty or Phone number format is invalid.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc và số điện thoại hợp lệ." | E1: Invalid input data
At Step 4: Name is empty or Phone number format is invalid.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc và số điện thoại hợp lệ." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-08, BR-15 | • BR-08, BR-15 | • BR-08, BR-15 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-06: Change Password | UC-06: Change Password | UC-06: Change Password |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | User | Secondary Actors: | None |
| Trigger: | User wants to update password for security reasons. | User wants to update password for security reasons. | User wants to update password for security reasons. |
| Description: | The user inputs current password and provides a new secure password to replace the old one. | The user inputs current password and provides a new secure password to replace the old one. | The user inputs current password and provides a new secure password to replace the old one. |
| Preconditions: | • The user is logged in.
• System is operational and database is accessible. | • The user is logged in.
• System is operational and database is accessible. | • The user is logged in.
• System is operational and database is accessible. |
| Postconditions: | • Password is changed, audit log is recorded, and user session updated. | • Password is changed, audit log is recorded, and user session updated. | • Password is changed, audit log is recorded, and user session updated. |
| Normal Flow: | 1. Authenticated User navigates to "Change Password" screen.
2. System displays Change Password form with fields:
   a. Current Password *
   b. New Password *
   c. Confirm New Password *
   d. [Hủy] and [Cập nhật mật khẩu] buttons
3. User enters required passwords and clicks [Cập nhật mật khẩu]. (A1, E1)
4. System validates input fields and checks if New Password matches Confirm New Password. (E1)
5. System verifies Current Password against BCrypt hash in "User" table. (E2)
6. System enforces new password policy rules. (E3)
7. System updates passwordHash in "User" table, logs to AuditLogs, and displays: "Đổi mật khẩu thành công." | 1. Authenticated User navigates to "Change Password" screen.
2. System displays Change Password form with fields:
   a. Current Password *
   b. New Password *
   c. Confirm New Password *
   d. [Hủy] and [Cập nhật mật khẩu] buttons
3. User enters required passwords and clicks [Cập nhật mật khẩu]. (A1, E1)
4. System validates input fields and checks if New Password matches Confirm New Password. (E1)
5. System verifies Current Password against BCrypt hash in "User" table. (E2)
6. System enforces new password policy rules. (E3)
7. System updates passwordHash in "User" table, logs to AuditLogs, and displays: "Đổi mật khẩu thành công." | 1. Authenticated User navigates to "Change Password" screen.
2. System displays Change Password form with fields:
   a. Current Password *
   b. New Password *
   c. Confirm New Password *
   d. [Hủy] and [Cập nhật mật khẩu] buttons
3. User enters required passwords and clicks [Cập nhật mật khẩu]. (A1, E1)
4. System validates input fields and checks if New Password matches Confirm New Password. (E1)
5. System verifies Current Password against BCrypt hash in "User" table. (E2)
6. System enforces new password policy rules. (E3)
7. System updates passwordHash in "User" table, logs to AuditLogs, and displays: "Đổi mật khẩu thành công." |
| Alternative Flows: | A1: Cancel password change
At Step 3, User clicks [Hủy].
1. Form input cleared.
2. User returns to Profile page. | A1: Cancel password change
At Step 3, User clicks [Hủy].
1. Form input cleared.
2. User returns to Profile page. | A1: Cancel password change
At Step 3, User clicks [Hủy].
1. Form input cleared.
2. User returns to Profile page. |
| Exceptions: | E1: Mismatched new passwords
At Step 4: New Password and Confirm New Password do not match.
• System displays: "Mật khẩu mới và xác nhận mật khẩu không trùng khớp."

E2: Incorrect current password
At Step 5: Current Password verification fails.
• System displays: "Mật khẩu hiện tại không chính xác."

E3: Weak password policy violation
At Step 6: Password length < 8 characters.
• System displays: "Mật khẩu mới phải có tối thiểu 8 ký tự." | E1: Mismatched new passwords
At Step 4: New Password and Confirm New Password do not match.
• System displays: "Mật khẩu mới và xác nhận mật khẩu không trùng khớp."

E2: Incorrect current password
At Step 5: Current Password verification fails.
• System displays: "Mật khẩu hiện tại không chính xác."

E3: Weak password policy violation
At Step 6: Password length < 8 characters.
• System displays: "Mật khẩu mới phải có tối thiểu 8 ký tự." | E1: Mismatched new passwords
At Step 4: New Password and Confirm New Password do not match.
• System displays: "Mật khẩu mới và xác nhận mật khẩu không trùng khớp."

E2: Incorrect current password
At Step 5: Current Password verification fails.
• System displays: "Mật khẩu hiện tại không chính xác."

E3: Weak password policy violation
At Step 6: Password length < 8 characters.
• System displays: "Mật khẩu mới phải có tối thiểu 8 ký tự." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-09, BR-14 | • BR-09, BR-14 | • BR-09, BR-14 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-07: View User List | UC-07: View User List | UC-07: View User List |
| --- | --- | --- | --- |
| Created By: | Quyet | Date Created: | 2026-06-27 |
| Primary Actor: | Admin | Secondary Actors: | None |
| Trigger: | Admin wants to view all registered user accounts. | Admin wants to view all registered user accounts. | Admin wants to view all registered user accounts. |
| Description: | Admin accesses User Management module to view a paginated list of all users, filtered by role or status. | Admin accesses User Management module to view a paginated list of all users, filtered by role or status. | Admin accesses User Management module to view a paginated list of all users, filtered by role or status. |
| Preconditions: | • Admin is logged in and authorized.
• System is operational and database is accessible. | • Admin is logged in and authorized.
• System is operational and database is accessible. | • Admin is logged in and authorized.
• System is operational and database is accessible. |
| Postconditions: | • A list of user accounts is displayed with pagination.
• System logs transaction in AuditLogs. | • A list of user accounts is displayed with pagination.
• System logs transaction in AuditLogs. | • A list of user accounts is displayed with pagination.
• System logs transaction in AuditLogs. |
| Normal Flow: | 1. Admin navigates to "User Management → Account List" from left sidebar.
2. System displays User List page with:
   a. Filter bar (Role dropdown, Status dropdown, Keyword search box)
   b. Paginated user table (User ID, Code, Full Name, Email, Role, Status, Created At, Action buttons)
   c. [+ Thêm tài khoản] and [Nhập Excel] buttons
3. Admin applies filter criteria or keyword search. (A1, E1)
4. System queries "User", MemberProfile, Student, Lecturer tables matching criteria.
5. System renders paginated table results. | 1. Admin navigates to "User Management → Account List" from left sidebar.
2. System displays User List page with:
   a. Filter bar (Role dropdown, Status dropdown, Keyword search box)
   b. Paginated user table (User ID, Code, Full Name, Email, Role, Status, Created At, Action buttons)
   c. [+ Thêm tài khoản] and [Nhập Excel] buttons
3. Admin applies filter criteria or keyword search. (A1, E1)
4. System queries "User", MemberProfile, Student, Lecturer tables matching criteria.
5. System renders paginated table results. | 1. Admin navigates to "User Management → Account List" from left sidebar.
2. System displays User List page with:
   a. Filter bar (Role dropdown, Status dropdown, Keyword search box)
   b. Paginated user table (User ID, Code, Full Name, Email, Role, Status, Created At, Action buttons)
   c. [+ Thêm tài khoản] and [Nhập Excel] buttons
3. Admin applies filter criteria or keyword search. (A1, E1)
4. System queries "User", MemberProfile, Student, Lecturer tables matching criteria.
5. System renders paginated table results. |
| Alternative Flows: | A1: Export user list
At Step 3, Admin clicks [Xuất Excel].
1. System triggers Export User List workflow (UC-30). | A1: Export user list
At Step 3, Admin clicks [Xuất Excel].
1. System triggers Export User List workflow (UC-30). | A1: Export user list
At Step 3, Admin clicks [Xuất Excel].
1. System triggers Export User List workflow (UC-30). |
| Exceptions: | E1: No users found matching filter
At Step 4: Query returns 0 records.
• System displays: "Không tìm thấy người dùng nào phù hợp." | E1: No users found matching filter
At Step 4: Query returns 0 records.
• System displays: "Không tìm thấy người dùng nào phù hợp." | E1: No users found matching filter
At Step 4: Query returns 0 records.
• System displays: "Không tìm thấy người dùng nào phù hợp." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-38 | • BR-38 | • BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-08: View User Detail | UC-08: View User Detail | UC-08: View User Detail |
| --- | --- | --- | --- |
| Created By: | Quyet | Date Created: | 2026-06-27 |
| Primary Actor: | Admin | Secondary Actors: | None |
| Trigger: | Admin wants to see detailed profile of a specific user. | Admin wants to see detailed profile of a specific user. | Admin wants to see detailed profile of a specific user. |
| Description: | Admin selects a user from the list to display full profile, contact details, and account status history. | Admin selects a user from the list to display full profile, contact details, and account status history. | Admin selects a user from the list to display full profile, contact details, and account status history. |
| Preconditions: | • Admin is logged in and viewing User List.
• System is operational and database is accessible. | • Admin is logged in and viewing User List.
• System is operational and database is accessible. | • Admin is logged in and viewing User List.
• System is operational and database is accessible. |
| Postconditions: | • Detailed profile of selected user is displayed.
• System logs transaction in AuditLogs. | • Detailed profile of selected user is displayed.
• System logs transaction in AuditLogs. | • Detailed profile of selected user is displayed.
• System logs transaction in AuditLogs. |
| Normal Flow: | 1. Admin is on User List page (UC-07).
2. Admin clicks view icon or user row.
3. System opens "Account Detail" modal dialog pre-filled with profile details (Full Name, Email, Phone, Role, Account Status, Lock Reason history).
4. Admin views account detail or clicks [Sửa tài khoản] or [Khóa/Mở khóa tài khoản]. (A1) | 1. Admin is on User List page (UC-07).
2. Admin clicks view icon or user row.
3. System opens "Account Detail" modal dialog pre-filled with profile details (Full Name, Email, Phone, Role, Account Status, Lock Reason history).
4. Admin views account detail or clicks [Sửa tài khoản] or [Khóa/Mở khóa tài khoản]. (A1) | 1. Admin is on User List page (UC-07).
2. Admin clicks view icon or user row.
3. System opens "Account Detail" modal dialog pre-filled with profile details (Full Name, Email, Phone, Role, Account Status, Lock Reason history).
4. Admin views account detail or clicks [Sửa tài khoản] or [Khóa/Mở khóa tài khoản]. (A1) |
| Alternative Flows: | A1: Edit account details
At Step 4, Admin clicks [Sửa tài khoản].
1. System opens Update User Account modal (UC-11). | A1: Edit account details
At Step 4, Admin clicks [Sửa tài khoản].
1. System opens Update User Account modal (UC-11). | A1: Edit account details
At Step 4, Admin clicks [Sửa tài khoản].
1. System opens Update User Account modal (UC-11). |
| Exceptions: | E1: User account not found
At Step 2: Selected userId does not exist.
• System displays error message: "Không tìm thấy bản ghi tài khoản người dùng." | E1: User account not found
At Step 2: Selected userId does not exist.
• System displays error message: "Không tìm thấy bản ghi tài khoản người dùng." | E1: User account not found
At Step 2: Selected userId does not exist.
• System displays error message: "Không tìm thấy bản ghi tài khoản người dùng." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-38 | • BR-38 | • BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-09: Create Single Account | UC-09: Create Single Account | UC-09: Create Single Account |
| --- | --- | --- | --- |
| Created By: | Quyet | Date Created: | 2026-06-27 |
| Primary Actor: | Admin | Secondary Actors: | None |
| Trigger: | Admin wants to create a new user account manually. | Admin wants to create a new user account manually. | Admin wants to create a new user account manually. |
| Description: | Admin fills in registration form to create a single user account (Student, Lecturer, Librarian, Manager). | Admin fills in registration form to create a single user account (Student, Lecturer, Librarian, Manager). | Admin fills in registration form to create a single user account (Student, Lecturer, Librarian, Manager). |
| Preconditions: | • Admin is logged in.
• System is operational and database is accessible. | • Admin is logged in.
• System is operational and database is accessible. | • Admin is logged in.
• System is operational and database is accessible. |
| Postconditions: | • A new user account is saved to database and audit log created. | • A new user account is saved to database and audit log created. | • A new user account is saved to database and audit log created. |
| Normal Flow: | 1. Admin is on User List page (UC-07).
2. Admin clicks [+ Thêm tài khoản] button.
3. System opens "Add New Account" modal dialog with fields:
   a. Role * (Student / Lecturer / Librarian / LibraryManager)
   b. Code * (Student Code / Lecturer Code / Staff Code)
   c. Email *
   d. Password *
   e. Full Name *
   f. Phone Number
   g. Department / Major / Enrollment Year
   h. [Hủy] and [Create Account] buttons
4. Admin selects role, enters profile data, and clicks [Create Account]. (A1, E1, E2)
5. System validates required fields and email/code unique constraints. (E1, E2)
6. System hashes password using BCrypt.
7. System inserts record into "User" table, MemberProfile table, and specific role table inside a DB transaction.
8. System logs creation in AuditLogs, closes modal, displays: "Tạo tài khoản mới thành công", and refreshes user table. | 1. Admin is on User List page (UC-07).
2. Admin clicks [+ Thêm tài khoản] button.
3. System opens "Add New Account" modal dialog with fields:
   a. Role * (Student / Lecturer / Librarian / LibraryManager)
   b. Code * (Student Code / Lecturer Code / Staff Code)
   c. Email *
   d. Password *
   e. Full Name *
   f. Phone Number
   g. Department / Major / Enrollment Year
   h. [Hủy] and [Create Account] buttons
4. Admin selects role, enters profile data, and clicks [Create Account]. (A1, E1, E2)
5. System validates required fields and email/code unique constraints. (E1, E2)
6. System hashes password using BCrypt.
7. System inserts record into "User" table, MemberProfile table, and specific role table inside a DB transaction.
8. System logs creation in AuditLogs, closes modal, displays: "Tạo tài khoản mới thành công", and refreshes user table. | 1. Admin is on User List page (UC-07).
2. Admin clicks [+ Thêm tài khoản] button.
3. System opens "Add New Account" modal dialog with fields:
   a. Role * (Student / Lecturer / Librarian / LibraryManager)
   b. Code * (Student Code / Lecturer Code / Staff Code)
   c. Email *
   d. Password *
   e. Full Name *
   f. Phone Number
   g. Department / Major / Enrollment Year
   h. [Hủy] and [Create Account] buttons
4. Admin selects role, enters profile data, and clicks [Create Account]. (A1, E1, E2)
5. System validates required fields and email/code unique constraints. (E1, E2)
6. System hashes password using BCrypt.
7. System inserts record into "User" table, MemberProfile table, and specific role table inside a DB transaction.
8. System logs creation in AuditLogs, closes modal, displays: "Tạo tài khoản mới thành công", and refreshes user table. |
| Alternative Flows: | A1: Cancel account creation
At Step 4, Admin clicks [Hủy] or [×] on modal.
1. Modal closes with no data saved. | A1: Cancel account creation
At Step 4, Admin clicks [Hủy] or [×] on modal.
1. Modal closes with no data saved. | A1: Cancel account creation
At Step 4, Admin clicks [Hủy] or [×] on modal.
1. Modal closes with no data saved. |
| Exceptions: | E1: Missing mandatory fields
At Step 5: Required fields missing.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."

E2: Duplicate Email or User Code
At Step 5: Email or Code already exists in database.
• System displays: "Email hoặc Mã số đã tồn tại trong hệ thống." | E1: Missing mandatory fields
At Step 5: Required fields missing.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."

E2: Duplicate Email or User Code
At Step 5: Email or Code already exists in database.
• System displays: "Email hoặc Mã số đã tồn tại trong hệ thống." | E1: Missing mandatory fields
At Step 5: Required fields missing.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."

E2: Duplicate Email or User Code
At Step 5: Email or Code already exists in database.
• System displays: "Email hoặc Mã số đã tồn tại trong hệ thống." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-10, BR-12, BR-14 | • BR-10, BR-12, BR-14 | • BR-10, BR-12, BR-14 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-10: Import Bulk Accounts | UC-10: Import Bulk Accounts | UC-10: Import Bulk Accounts |
| --- | --- | --- | --- |
| Created By: | Quyet | Date Created: | 2026-06-27 |
| Primary Actor: | Admin | Secondary Actors: | None |
| Trigger: | Admin wants to import a large list of accounts. | Admin wants to import a large list of accounts. | Admin wants to import a large list of accounts. |
| Description: | Admin uploads an Excel file (.xlsx) containing bulk account data to provision users rapidly. | Admin uploads an Excel file (.xlsx) containing bulk account data to provision users rapidly. | Admin uploads an Excel file (.xlsx) containing bulk account data to provision users rapidly. |
| Preconditions: | • Admin is logged in.
• System is operational and database is accessible. | • Admin is logged in.
• System is operational and database is accessible. | • Admin is logged in.
• System is operational and database is accessible. |
| Postconditions: | • Multiple user accounts created inside a DB transaction, or none if validation fails. | • Multiple user accounts created inside a DB transaction, or none if validation fails. | • Multiple user accounts created inside a DB transaction, or none if validation fails. |
| Normal Flow: | 1. Admin is on User List page (UC-07).
2. Admin clicks [Nhập Excel] button.
3. System opens "Import Accounts from Excel" modal dialog with:
   a. File upload area (.xlsx)
   b. Download sample template link
   c. [Hủy] and [Tải lên & Xem trước] buttons
4. Admin selects file and clicks [Tải lên & Xem trước]. (A1, E1)
5. System parses Excel rows using Apache POI, validates format and unique constraints per row. (E1, E2)
6. System displays Import Preview Modal showing valid rows count and error rows count with line numbers.
7. Admin reviews preview and clicks [Xác nhận nhập].
8. System inserts valid records into "User", MemberProfile, and role tables in batch transaction.
9. System logs operation to AuditLogs, closes modal, displays: "Nhập dữ liệu tài khoản từ Excel thành công", and refreshes User List. | 1. Admin is on User List page (UC-07).
2. Admin clicks [Nhập Excel] button.
3. System opens "Import Accounts from Excel" modal dialog with:
   a. File upload area (.xlsx)
   b. Download sample template link
   c. [Hủy] and [Tải lên & Xem trước] buttons
4. Admin selects file and clicks [Tải lên & Xem trước]. (A1, E1)
5. System parses Excel rows using Apache POI, validates format and unique constraints per row. (E1, E2)
6. System displays Import Preview Modal showing valid rows count and error rows count with line numbers.
7. Admin reviews preview and clicks [Xác nhận nhập].
8. System inserts valid records into "User", MemberProfile, and role tables in batch transaction.
9. System logs operation to AuditLogs, closes modal, displays: "Nhập dữ liệu tài khoản từ Excel thành công", and refreshes User List. | 1. Admin is on User List page (UC-07).
2. Admin clicks [Nhập Excel] button.
3. System opens "Import Accounts from Excel" modal dialog with:
   a. File upload area (.xlsx)
   b. Download sample template link
   c. [Hủy] and [Tải lên & Xem trước] buttons
4. Admin selects file and clicks [Tải lên & Xem trước]. (A1, E1)
5. System parses Excel rows using Apache POI, validates format and unique constraints per row. (E1, E2)
6. System displays Import Preview Modal showing valid rows count and error rows count with line numbers.
7. Admin reviews preview and clicks [Xác nhận nhập].
8. System inserts valid records into "User", MemberProfile, and role tables in batch transaction.
9. System logs operation to AuditLogs, closes modal, displays: "Nhập dữ liệu tài khoản từ Excel thành công", and refreshes User List. |
| Alternative Flows: | A1: Cancel import
At Step 4, Admin clicks [Hủy] or [×] on modal.
1. Modal closes without importing data. | A1: Cancel import
At Step 4, Admin clicks [Hủy] or [×] on modal.
1. Modal closes without importing data. | A1: Cancel import
At Step 4, Admin clicks [Hủy] or [×] on modal.
1. Modal closes without importing data. |
| Exceptions: | E1: Invalid file format
At Step 5: File extension is not .xlsx or corrupt.
• System displays: "Định dạng tệp không hợp lệ. Vui lòng sử dụng tệp mẫu .xlsx."

E2: Bulk validation errors
At Step 5: Multiple rows have invalid data.
• System displays error summary table highlighting invalid rows. | E1: Invalid file format
At Step 5: File extension is not .xlsx or corrupt.
• System displays: "Định dạng tệp không hợp lệ. Vui lòng sử dụng tệp mẫu .xlsx."

E2: Bulk validation errors
At Step 5: Multiple rows have invalid data.
• System displays error summary table highlighting invalid rows. | E1: Invalid file format
At Step 5: File extension is not .xlsx or corrupt.
• System displays: "Định dạng tệp không hợp lệ. Vui lòng sử dụng tệp mẫu .xlsx."

E2: Bulk validation errors
At Step 5: Multiple rows have invalid data.
• System displays error summary table highlighting invalid rows. |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-10, BR-11, BR-13, BR-14 | • BR-10, BR-11, BR-13, BR-14 | • BR-10, BR-11, BR-13, BR-14 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-11: Update User Account | UC-11: Update User Account | UC-11: Update User Account |
| --- | --- | --- | --- |
| Created By: | Quyet | Date Created: | 2026-06-27 |
| Primary Actor: | Admin | Secondary Actors: | None |
| Trigger: | Admin wants to update user account details or status. | Admin wants to update user account details or status. | Admin wants to update user account details or status. |
| Description: | Admin modifies account profile, role, status (Active/Locked), or resets lock reason. | Admin modifies account profile, role, status (Active/Locked), or resets lock reason. | Admin modifies account profile, role, status (Active/Locked), or resets lock reason. |
| Preconditions: | • Admin is logged in.
• System is operational and database is accessible. | • Admin is logged in.
• System is operational and database is accessible. | • Admin is logged in.
• System is operational and database is accessible. |
| Postconditions: | • Account updates saved to database and audit log created. | • Account updates saved to database and audit log created. | • Account updates saved to database and audit log created. |
| Normal Flow: | 1. Admin is on User List page (UC-07) or User Detail modal (UC-08).
2. Admin clicks [Sửa tài khoản] or status toggle switch.
3. System opens "Update Account" modal dialog pre-filled with user data.
4. Admin modifies profile fields, status, or role, and clicks [Lưu thay đổi]. (A1, E1)
5. System validates required input values. (E1)
6. System updates "User" and MemberProfile tables.
7. System logs change in AuditLogs, closes modal, displays: "Cập nhật thông tin tài khoản thành công", and refreshes User List. | 1. Admin is on User List page (UC-07) or User Detail modal (UC-08).
2. Admin clicks [Sửa tài khoản] or status toggle switch.
3. System opens "Update Account" modal dialog pre-filled with user data.
4. Admin modifies profile fields, status, or role, and clicks [Lưu thay đổi]. (A1, E1)
5. System validates required input values. (E1)
6. System updates "User" and MemberProfile tables.
7. System logs change in AuditLogs, closes modal, displays: "Cập nhật thông tin tài khoản thành công", and refreshes User List. | 1. Admin is on User List page (UC-07) or User Detail modal (UC-08).
2. Admin clicks [Sửa tài khoản] or status toggle switch.
3. System opens "Update Account" modal dialog pre-filled with user data.
4. Admin modifies profile fields, status, or role, and clicks [Lưu thay đổi]. (A1, E1)
5. System validates required input values. (E1)
6. System updates "User" and MemberProfile tables.
7. System logs change in AuditLogs, closes modal, displays: "Cập nhật thông tin tài khoản thành công", and refreshes User List. |
| Alternative Flows: | A1: Cancel update
At Step 4, Admin clicks [Hủy].
1. Modal closes without saving changes. | A1: Cancel update
At Step 4, Admin clicks [Hủy].
1. Modal closes without saving changes. | A1: Cancel update
At Step 4, Admin clicks [Hủy].
1. Modal closes without saving changes. |
| Exceptions: | E1: Validation failure
At Step 5: Required fields left blank.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc." | E1: Validation failure
At Step 5: Required fields left blank.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc." | E1: Validation failure
At Step 5: Required fields left blank.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-14 | • BR-14 | • BR-14 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-12: View Book Catalog & Inventory | UC-12: View Book Catalog & Inventory | UC-12: View Book Catalog & Inventory |
| --- | --- | --- | --- |
| Created By: | Chuong | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | None |
| Trigger: | Librarian or Manager wants to view book catalog and copy inventories. | Librarian or Manager wants to view book catalog and copy inventories. | Librarian or Manager wants to view book catalog and copy inventories. |
| Description: | User views paginated list of all book titles, search by keywords, and check status, location, and barcode details. | User views paginated list of all book titles, search by keywords, and check status, location, and barcode details. | User views paginated list of all book titles, search by keywords, and check status, location, and barcode details. |
| Preconditions: | • User is logged in.
• System is operational and database is accessible. | • User is logged in.
• System is operational and database is accessible. | • User is logged in.
• System is operational and database is accessible. |
| Postconditions: | • Book catalog and inventory details displayed.
• System logs transaction in AuditLogs. | • Book catalog and inventory details displayed.
• System logs transaction in AuditLogs. | • Book catalog and inventory details displayed.
• System logs transaction in AuditLogs. |
| Normal Flow: | 1. User navigates to "Book Management → Catalog & Inventory" from sidebar.
2. System queries Book, BookCopy, Category, Tag tables.
3. System displays Book Catalog page with search bar, category filter, tag filter, and book grid/table.
4. User enters keyword or selects category filter. (A1, E1)
5. System renders matching book titles with totalQuantity and availableQuantity counters. | 1. User navigates to "Book Management → Catalog & Inventory" from sidebar.
2. System queries Book, BookCopy, Category, Tag tables.
3. System displays Book Catalog page with search bar, category filter, tag filter, and book grid/table.
4. User enters keyword or selects category filter. (A1, E1)
5. System renders matching book titles with totalQuantity and availableQuantity counters. | 1. User navigates to "Book Management → Catalog & Inventory" from sidebar.
2. System queries Book, BookCopy, Category, Tag tables.
3. System displays Book Catalog page with search bar, category filter, tag filter, and book grid/table.
4. User enters keyword or selects category filter. (A1, E1)
5. System renders matching book titles with totalQuantity and availableQuantity counters. |
| Alternative Flows: | A1: View copy inventory
At Step 5, User clicks a book row.
1. System opens Copy Inventory modal showing barcodes, locations, conditions, and copy statuses. | A1: View copy inventory
At Step 5, User clicks a book row.
1. System opens Copy Inventory modal showing barcodes, locations, conditions, and copy statuses. | A1: View copy inventory
At Step 5, User clicks a book row.
1. System opens Copy Inventory modal showing barcodes, locations, conditions, and copy statuses. |
| Exceptions: | E1: Book catalog empty
At Step 4: Search keyword returns 0 records.
• System displays: "Không tìm thấy đầu sách nào phù hợp." | E1: Book catalog empty
At Step 4: Search keyword returns 0 records.
• System displays: "Không tìm thấy đầu sách nào phù hợp." | E1: Book catalog empty
At Step 4: Search keyword returns 0 records.
• System displays: "Không tìm thấy đầu sách nào phù hợp." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-38 | • BR-38 | • BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-13: Manage Book Catalog | UC-13: Manage Book Catalog | UC-13: Manage Book Catalog |
| --- | --- | --- | --- |
| Created By: | Chuong | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | None |
| Trigger: | Librarian or Manager wants to add or update book catalog entries. | Librarian or Manager wants to add or update book catalog entries. | Librarian or Manager wants to add or update book catalog entries. |
| Description: | User creates new book title or modifies metadata (ISBN, Title, Author, Publisher, Year, Price, Image). | User creates new book title or modifies metadata (ISBN, Title, Author, Publisher, Year, Price, Image). | User creates new book title or modifies metadata (ISBN, Title, Author, Publisher, Year, Price, Image). |
| Preconditions: | • User is logged in with appropriate permissions.
• System is operational and database is accessible. | • User is logged in with appropriate permissions.
• System is operational and database is accessible. | • User is logged in with appropriate permissions.
• System is operational and database is accessible. |
| Postconditions: | • Book title record saved to database and audit log created. | • Book title record saved to database and audit log created. | • Book title record saved to database and audit log created. |
| Normal Flow: | 1. User is on Book Catalog page (UC-12).
2. User clicks [+ Thêm sách] button or edit icon on book row.
3. System opens "Book Information" modal dialog with fields: ISBN *, Title *, Author *, Publisher, Publication Year, Price *, Cover Image Upload, Category multiselect, Tag multiselect.
4. User enters metadata, selects image, and clicks [Lưu thông tin sách]. (A1, E1, E2)
5. System validates ISBN uniqueness and required fields. (E1, E2)
6. System saves cover image to storage directory via BookImageStorage utility.
7. System inserts/updates Book record, BookCategory, and BookTag junction tables.
8. System logs C/U/D action to AuditLogs, closes modal, displays: "Lưu thông tin đầu sách thành công", and refreshes catalog. | 1. User is on Book Catalog page (UC-12).
2. User clicks [+ Thêm sách] button or edit icon on book row.
3. System opens "Book Information" modal dialog with fields: ISBN *, Title *, Author *, Publisher, Publication Year, Price *, Cover Image Upload, Category multiselect, Tag multiselect.
4. User enters metadata, selects image, and clicks [Lưu thông tin sách]. (A1, E1, E2)
5. System validates ISBN uniqueness and required fields. (E1, E2)
6. System saves cover image to storage directory via BookImageStorage utility.
7. System inserts/updates Book record, BookCategory, and BookTag junction tables.
8. System logs C/U/D action to AuditLogs, closes modal, displays: "Lưu thông tin đầu sách thành công", and refreshes catalog. | 1. User is on Book Catalog page (UC-12).
2. User clicks [+ Thêm sách] button or edit icon on book row.
3. System opens "Book Information" modal dialog with fields: ISBN *, Title *, Author *, Publisher, Publication Year, Price *, Cover Image Upload, Category multiselect, Tag multiselect.
4. User enters metadata, selects image, and clicks [Lưu thông tin sách]. (A1, E1, E2)
5. System validates ISBN uniqueness and required fields. (E1, E2)
6. System saves cover image to storage directory via BookImageStorage utility.
7. System inserts/updates Book record, BookCategory, and BookTag junction tables.
8. System logs C/U/D action to AuditLogs, closes modal, displays: "Lưu thông tin đầu sách thành công", and refreshes catalog. |
| Alternative Flows: | A1: Cancel book management
At Step 4, User clicks [Hủy].
1. Modal closes without saving changes. | A1: Cancel book management
At Step 4, User clicks [Hủy].
1. Modal closes without saving changes. | A1: Cancel book management
At Step 4, User clicks [Hủy].
1. Modal closes without saving changes. |
| Exceptions: | E1: Missing mandatory fields
At Step 5: ISBN, Title, Author, or Price is missing.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."

E2: Duplicate ISBN
At Step 5: Entered ISBN already exists in Book table.
• System displays: "Mã ISBN này đã tồn tại trong hệ thống." | E1: Missing mandatory fields
At Step 5: ISBN, Title, Author, or Price is missing.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."

E2: Duplicate ISBN
At Step 5: Entered ISBN already exists in Book table.
• System displays: "Mã ISBN này đã tồn tại trong hệ thống." | E1: Missing mandatory fields
At Step 5: ISBN, Title, Author, or Price is missing.
• System displays: "Vui lòng điền đầy đủ các trường bắt buộc."

E2: Duplicate ISBN
At Step 5: Entered ISBN already exists in Book table.
• System displays: "Mã ISBN này đã tồn tại trong hệ thống." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-16, BR-18 | • BR-16, BR-18 | • BR-16, BR-18 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-14: Manage Physical Copies | UC-14: Manage Physical Copies | UC-14: Manage Physical Copies |
| --- | --- | --- | --- |
| Created By: | Chuong | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | None |
| Trigger: | Librarian wants to declare physical book copies and barcodes. | Librarian wants to declare physical book copies and barcodes. | Librarian wants to declare physical book copies and barcodes. |
| Description: | Librarian adds physical copy instances for a book title with barcode, location shelf, and initial condition. | Librarian adds physical copy instances for a book title with barcode, location shelf, and initial condition. | Librarian adds physical copy instances for a book title with barcode, location shelf, and initial condition. |
| Preconditions: | • Librarian is logged in.
• System is operational and database is accessible. | • Librarian is logged in.
• System is operational and database is accessible. | • Librarian is logged in.
• System is operational and database is accessible. |
| Postconditions: | • New BookCopy records created, increasing availableQuantity counter. | • New BookCopy records created, increasing availableQuantity counter. | • New BookCopy records created, increasing availableQuantity counter. |
| Normal Flow: | 1. Librarian is on Book Catalog page (UC-12) or Copy Inventory modal.
2. Librarian clicks [+ Thêm bản sao] button.
3. System opens "Add Copy" modal with fields: Barcode * (or auto-generate), Location Shelf *, Initial Condition (New / Good / Fair), Status (Available).
4. Librarian enters barcode and location, then clicks [Lưu bản sao]. (A1, E1, E2)
5. System validates barcode uniqueness in BookCopy table. (E1, E2)
6. System inserts record into BookCopy table.
7. System increments totalQuantity and availableQuantity in Book table.
8. System records action in AuditLogs, displays: "Thêm bản sao sách mới thành công", and refreshes copy list table. | 1. Librarian is on Book Catalog page (UC-12) or Copy Inventory modal.
2. Librarian clicks [+ Thêm bản sao] button.
3. System opens "Add Copy" modal with fields: Barcode * (or auto-generate), Location Shelf *, Initial Condition (New / Good / Fair), Status (Available).
4. Librarian enters barcode and location, then clicks [Lưu bản sao]. (A1, E1, E2)
5. System validates barcode uniqueness in BookCopy table. (E1, E2)
6. System inserts record into BookCopy table.
7. System increments totalQuantity and availableQuantity in Book table.
8. System records action in AuditLogs, displays: "Thêm bản sao sách mới thành công", and refreshes copy list table. | 1. Librarian is on Book Catalog page (UC-12) or Copy Inventory modal.
2. Librarian clicks [+ Thêm bản sao] button.
3. System opens "Add Copy" modal with fields: Barcode * (or auto-generate), Location Shelf *, Initial Condition (New / Good / Fair), Status (Available).
4. Librarian enters barcode and location, then clicks [Lưu bản sao]. (A1, E1, E2)
5. System validates barcode uniqueness in BookCopy table. (E1, E2)
6. System inserts record into BookCopy table.
7. System increments totalQuantity and availableQuantity in Book table.
8. System records action in AuditLogs, displays: "Thêm bản sao sách mới thành công", and refreshes copy list table. |
| Alternative Flows: | A1: Cancel copy creation
At Step 4, Librarian clicks [Hủy].
1. Modal closes without creating copy. | A1: Cancel copy creation
At Step 4, Librarian clicks [Hủy].
1. Modal closes without creating copy. | A1: Cancel copy creation
At Step 4, Librarian clicks [Hủy].
1. Modal closes without creating copy. |
| Exceptions: | E1: Empty mandatory copy fields
At Step 5: Barcode or Location is blank.
• System displays: "Vui lòng nhập mã vạch và vị trí kệ sách."

E2: Duplicate barcode
At Step 5: Barcode already assigned to another physical copy.
• System displays: "Mã vạch bản sao này đã tồn tại trong hệ thống." | E1: Empty mandatory copy fields
At Step 5: Barcode or Location is blank.
• System displays: "Vui lòng nhập mã vạch và vị trí kệ sách."

E2: Duplicate barcode
At Step 5: Barcode already assigned to another physical copy.
• System displays: "Mã vạch bản sao này đã tồn tại trong hệ thống." | E1: Empty mandatory copy fields
At Step 5: Barcode or Location is blank.
• System displays: "Vui lòng nhập mã vạch và vị trí kệ sách."

E2: Duplicate barcode
At Step 5: Barcode already assigned to another physical copy.
• System displays: "Mã vạch bản sao này đã tồn tại trong hệ thống." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-16, BR-17, BR-18 | • BR-16, BR-17, BR-18 | • BR-16, BR-17, BR-18 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-15: Manage Tags & Categories | UC-15: Manage Tags & Categories | UC-15: Manage Tags & Categories |
| --- | --- | --- | --- |
| Created By: | Chuong | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | None |
| Trigger: | Librarian or Manager wants to manage category and tag taxonomies. | Librarian or Manager wants to manage category and tag taxonomies. | Librarian or Manager wants to manage category and tag taxonomies. |
| Description: | User creates, updates, or soft-deletes book categories and tags. | User creates, updates, or soft-deletes book categories and tags. | User creates, updates, or soft-deletes book categories and tags. |
| Preconditions: | • User is logged in with catalog permissions.
• System is operational and database is accessible. | • User is logged in with catalog permissions.
• System is operational and database is accessible. | • User is logged in with catalog permissions.
• System is operational and database is accessible. |
| Postconditions: | • Category / Tag records updated in database. | • Category / Tag records updated in database. | • Category / Tag records updated in database. |
| Normal Flow: | 1. User navigates to "Category & Tag Management" from sidebar.
2. System displays Category list and Tag list tables with C/U/D action buttons.
3. User clicks [+ Thêm danh mục] or [+ Thêm thẻ tag] button.
4. System opens modal dialog with Name * and Description fields.
5. User enters taxonomy details and clicks [Lưu]. (A1, E1)
6. System validates unique name constraint in Category or Tag table. (E1)
7. System inserts or updates record in Category / Tag table.
8. System closes modal, displays: "Cập nhật danh mục / thẻ tag thành công", and refreshes list. | 1. User navigates to "Category & Tag Management" from sidebar.
2. System displays Category list and Tag list tables with C/U/D action buttons.
3. User clicks [+ Thêm danh mục] or [+ Thêm thẻ tag] button.
4. System opens modal dialog with Name * and Description fields.
5. User enters taxonomy details and clicks [Lưu]. (A1, E1)
6. System validates unique name constraint in Category or Tag table. (E1)
7. System inserts or updates record in Category / Tag table.
8. System closes modal, displays: "Cập nhật danh mục / thẻ tag thành công", and refreshes list. | 1. User navigates to "Category & Tag Management" from sidebar.
2. System displays Category list and Tag list tables with C/U/D action buttons.
3. User clicks [+ Thêm danh mục] or [+ Thêm thẻ tag] button.
4. System opens modal dialog with Name * and Description fields.
5. User enters taxonomy details and clicks [Lưu]. (A1, E1)
6. System validates unique name constraint in Category or Tag table. (E1)
7. System inserts or updates record in Category / Tag table.
8. System closes modal, displays: "Cập nhật danh mục / thẻ tag thành công", and refreshes list. |
| Alternative Flows: | A1: Cancel category management
At Step 5, User clicks [Hủy].
1. Modal closes without saving taxonomy. | A1: Cancel category management
At Step 5, User clicks [Hủy].
1. Modal closes without saving taxonomy. | A1: Cancel category management
At Step 5, User clicks [Hủy].
1. Modal closes without saving taxonomy. |
| Exceptions: | E1: Duplicate category/tag name
At Step 6: Name already exists.
• System displays: "Tên danh mục hoặc thẻ tag đã tồn tại." | E1: Duplicate category/tag name
At Step 6: Name already exists.
• System displays: "Tên danh mục hoặc thẻ tag đã tồn tại." | E1: Duplicate category/tag name
At Step 6: Name already exists.
• System displays: "Tên danh mục hoặc thẻ tag đã tồn tại." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-38 | • BR-38 | • BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-16: Reserve Book Online | UC-16: Reserve Book Online | UC-16: Reserve Book Online |
| --- | --- | --- | --- |
| Created By: | Bao | Date Created: | 2026-06-27 |
| Primary Actor: | Student, Lecturer | Secondary Actors: | System |
| Trigger: | Student or Lecturer wants to place an online hold reservation for an out-of-stock book. | Student or Lecturer wants to place an online hold reservation for an out-of-stock book. | Student or Lecturer wants to place an online hold reservation for an out-of-stock book. |
| Description: | User reserves a book when availableQuantity = 0 to join queue. | User reserves a book when availableQuantity = 0 to join queue. | User reserves a book when availableQuantity = 0 to join queue. |
| Preconditions: | • User is logged in.
• System is operational and database is accessible. | • User is logged in.
• System is operational and database is accessible. | • User is logged in.
• System is operational and database is accessible. |
| Postconditions: | • Reservation record created with status 'Pending' and queuePosition assigned. | • Reservation record created with status 'Pending' and queuePosition assigned. | • Reservation record created with status 'Pending' and queuePosition assigned. |
| Normal Flow: | 1. User views Book Detail page (UC-22) where availableQuantity = 0.
2. User clicks [Đặt giữ chỗ sách] button.
3. System checks user active loan count, overdue fines, and existing reservations for this book. (E1, E2, E3)
4. System calculates next queuePosition = MAX(queuePosition) + 1 for this bookId.
5. System inserts record into Reservation table (status = 'Pending', startDate = NOW()).
6. System logs action to AuditLogs and displays success modal: "Đặt giữ chỗ sách trực tuyến thành công." | 1. User views Book Detail page (UC-22) where availableQuantity = 0.
2. User clicks [Đặt giữ chỗ sách] button.
3. System checks user active loan count, overdue fines, and existing reservations for this book. (E1, E2, E3)
4. System calculates next queuePosition = MAX(queuePosition) + 1 for this bookId.
5. System inserts record into Reservation table (status = 'Pending', startDate = NOW()).
6. System logs action to AuditLogs and displays success modal: "Đặt giữ chỗ sách trực tuyến thành công." | 1. User views Book Detail page (UC-22) where availableQuantity = 0.
2. User clicks [Đặt giữ chỗ sách] button.
3. System checks user active loan count, overdue fines, and existing reservations for this book. (E1, E2, E3)
4. System calculates next queuePosition = MAX(queuePosition) + 1 for this bookId.
5. System inserts record into Reservation table (status = 'Pending', startDate = NOW()).
6. System logs action to AuditLogs and displays success modal: "Đặt giữ chỗ sách trực tuyến thành công." |
| Alternative Flows: | A1: Cancel reservation
At Step 2, User clicks [Hủy] on confirmation modal.
1. Reservation request cancelled. | A1: Cancel reservation
At Step 2, User clicks [Hủy] on confirmation modal.
1. Reservation request cancelled. | A1: Cancel reservation
At Step 2, User clicks [Hủy] on confirmation modal.
1. Reservation request cancelled. |
| Exceptions: | E1: Unpaid fine or overdue loan
At Step 3: User has overdue books or pending fines.
• System displays: "Bạn đang có sách quá hạn hoặc nợ tiền phạt. Không thể đặt giữ chỗ."

E2: Already reserved this book
At Step 3: Active Reservation record already exists for this bookId and userId.
• System displays: "Bạn đã đăng ký đặt giữ chỗ cho đầu sách này rồi."

E3: Exceeded reservation limit
At Step 3: Active reservations >= max limit (BR-21).
• System displays: "Bạn đã đạt giới hạn số lượng sách đặt giữ chỗ tối đa." | E1: Unpaid fine or overdue loan
At Step 3: User has overdue books or pending fines.
• System displays: "Bạn đang có sách quá hạn hoặc nợ tiền phạt. Không thể đặt giữ chỗ."

E2: Already reserved this book
At Step 3: Active Reservation record already exists for this bookId and userId.
• System displays: "Bạn đã đăng ký đặt giữ chỗ cho đầu sách này rồi."

E3: Exceeded reservation limit
At Step 3: Active reservations >= max limit (BR-21).
• System displays: "Bạn đã đạt giới hạn số lượng sách đặt giữ chỗ tối đa." | E1: Unpaid fine or overdue loan
At Step 3: User has overdue books or pending fines.
• System displays: "Bạn đang có sách quá hạn hoặc nợ tiền phạt. Không thể đặt giữ chỗ."

E2: Already reserved this book
At Step 3: Active Reservation record already exists for this bookId and userId.
• System displays: "Bạn đã đăng ký đặt giữ chỗ cho đầu sách này rồi."

E3: Exceeded reservation limit
At Step 3: Active reservations >= max limit (BR-21).
• System displays: "Bạn đã đạt giới hạn số lượng sách đặt giữ chỗ tối đa." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-19, BR-20, BR-22 | • BR-19, BR-20, BR-22 | • BR-19, BR-20, BR-22 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-17: Renew Book Online | UC-17: Renew Book Online | UC-17: Renew Book Online |
| --- | --- | --- | --- |
| Created By: | Bao | Date Created: | 2026-06-27 |
| Primary Actor: | Student, Lecturer | Secondary Actors: | None |
| Trigger: | Student or Lecturer wants to extend due date of an active loan online. | Student or Lecturer wants to extend due date of an active loan online. | Student or Lecturer wants to extend due date of an active loan online. |
| Description: | User extends loan period by renewal limit if no other reader has reserved the book. | User extends loan period by renewal limit if no other reader has reserved the book. | User extends loan period by renewal limit if no other reader has reserved the book. |
| Preconditions: | • User is logged in and has an active loan.
• System is operational and database is accessible. | • User is logged in and has an active loan.
• System is operational and database is accessible. | • User is logged in and has an active loan.
• System is operational and database is accessible. |
| Postconditions: | • BorrowRecord endDate extended and extensionCount incremented. | • BorrowRecord endDate extended and extensionCount incremented. | • BorrowRecord endDate extended and extensionCount incremented. |
| Normal Flow: | 1. User navigates to "My Borrowings" page (UC-31).
2. User selects an active loan and clicks [Gia hạn mượn] button.
3. System checks extensionCount < maxRenewals (BR-22) AND no pending Reservations exist for this book. (E1, E2, E3)
4. System calculates new endDate = current endDate + renewalDays from SystemConfigurations.
5. System updates BorrowRecord (endDate = new endDate, extensionCount = extensionCount + 1).
6. System records action in AuditLogs and displays: "Gia hạn mượn sách thành công." | 1. User navigates to "My Borrowings" page (UC-31).
2. User selects an active loan and clicks [Gia hạn mượn] button.
3. System checks extensionCount < maxRenewals (BR-22) AND no pending Reservations exist for this book. (E1, E2, E3)
4. System calculates new endDate = current endDate + renewalDays from SystemConfigurations.
5. System updates BorrowRecord (endDate = new endDate, extensionCount = extensionCount + 1).
6. System records action in AuditLogs and displays: "Gia hạn mượn sách thành công." | 1. User navigates to "My Borrowings" page (UC-31).
2. User selects an active loan and clicks [Gia hạn mượn] button.
3. System checks extensionCount < maxRenewals (BR-22) AND no pending Reservations exist for this book. (E1, E2, E3)
4. System calculates new endDate = current endDate + renewalDays from SystemConfigurations.
5. System updates BorrowRecord (endDate = new endDate, extensionCount = extensionCount + 1).
6. System records action in AuditLogs and displays: "Gia hạn mượn sách thành công." |
| Alternative Flows: | A1: Cancel renewal
At Step 2, User cancels renewal prompt.
1. Due date remains unchanged. | A1: Cancel renewal
At Step 2, User cancels renewal prompt.
1. Due date remains unchanged. | A1: Cancel renewal
At Step 2, User cancels renewal prompt.
1. Due date remains unchanged. |
| Exceptions: | E1: Renewal limit reached
At Step 3: extensionCount >= maxRenewals.
• System displays: "Sách này đã đạt số lần gia hạn tối đa cho phép."

E2: Pending reservations exist
At Step 3: Another user is waiting in Reservation queue.
• System displays: "Không thể gia hạn do đầu sách này đang có độc giả khác chờ mượn."

E3: Loan is overdue
At Step 3: NOW() > endDate.
• System displays: "Sách đã quá hạn trả. Vui lòng mang sách đến quầy thư viện để xử lý." | E1: Renewal limit reached
At Step 3: extensionCount >= maxRenewals.
• System displays: "Sách này đã đạt số lần gia hạn tối đa cho phép."

E2: Pending reservations exist
At Step 3: Another user is waiting in Reservation queue.
• System displays: "Không thể gia hạn do đầu sách này đang có độc giả khác chờ mượn."

E3: Loan is overdue
At Step 3: NOW() > endDate.
• System displays: "Sách đã quá hạn trả. Vui lòng mang sách đến quầy thư viện để xử lý." | E1: Renewal limit reached
At Step 3: extensionCount >= maxRenewals.
• System displays: "Sách này đã đạt số lần gia hạn tối đa cho phép."

E2: Pending reservations exist
At Step 3: Another user is waiting in Reservation queue.
• System displays: "Không thể gia hạn do đầu sách này đang có độc giả khác chờ mượn."

E3: Loan is overdue
At Step 3: NOW() > endDate.
• System displays: "Sách đã quá hạn trả. Vui lòng mang sách đến quầy thư viện để xử lý." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-19, BR-21, BR-22 | • BR-19, BR-21, BR-22 | • BR-19, BR-21, BR-22 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-18: Desk Check-out | UC-18: Desk Check-out | UC-18: Desk Check-out |
| --- | --- | --- | --- |
| Created By: | Thai | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | None |
| Trigger: | Librarian issues books to readers at circulation desk. | Librarian issues books to readers at circulation desk. | Librarian issues books to readers at circulation desk. |
| Description: | Librarian scans reader barcode and copy barcode to check out books. | Librarian scans reader barcode and copy barcode to check out books. | Librarian scans reader barcode and copy barcode to check out books. |
| Preconditions: | • Librarian is logged in.
• System is operational and database is accessible. | • Librarian is logged in.
• System is operational and database is accessible. | • Librarian is logged in.
• System is operational and database is accessible. |
| Postconditions: | • BorrowRecord created, copy status set to 'Borrowed', availableQuantity decremented. | • BorrowRecord created, copy status set to 'Borrowed', availableQuantity decremented. | • BorrowRecord created, copy status set to 'Borrowed', availableQuantity decremented. |
| Normal Flow: | 1. Librarian is on Desk Circulation screen ("Issue Book").
2. Librarian scans/enters Reader Code (Student Code / Staff Code). (E1)
3. System validates account status and active fines. (E1, E2)
4. Librarian scans Copy Barcode. (E3, E4)
5. System verifies BookCopy status = 'Available' (or reserved for this user). (E4)
6. Librarian selects loan duration (14 days student / 30 days lecturer) and clicks [Xác nhận mượn].
7. System inserts BorrowRecord, updates BookCopy status = 'Borrowed', decrements availableQuantity in Book table.
8. System records transaction in AuditLogs and prints loan receipt. | 1. Librarian is on Desk Circulation screen ("Issue Book").
2. Librarian scans/enters Reader Code (Student Code / Staff Code). (E1)
3. System validates account status and active fines. (E1, E2)
4. Librarian scans Copy Barcode. (E3, E4)
5. System verifies BookCopy status = 'Available' (or reserved for this user). (E4)
6. Librarian selects loan duration (14 days student / 30 days lecturer) and clicks [Xác nhận mượn].
7. System inserts BorrowRecord, updates BookCopy status = 'Borrowed', decrements availableQuantity in Book table.
8. System records transaction in AuditLogs and prints loan receipt. | 1. Librarian is on Desk Circulation screen ("Issue Book").
2. Librarian scans/enters Reader Code (Student Code / Staff Code). (E1)
3. System validates account status and active fines. (E1, E2)
4. Librarian scans Copy Barcode. (E3, E4)
5. System verifies BookCopy status = 'Available' (or reserved for this user). (E4)
6. Librarian selects loan duration (14 days student / 30 days lecturer) and clicks [Xác nhận mượn].
7. System inserts BorrowRecord, updates BookCopy status = 'Borrowed', decrements availableQuantity in Book table.
8. System records transaction in AuditLogs and prints loan receipt. |
| Alternative Flows: | A1: Issue from pre-reservation
At Step 4, Librarian selects reader's active reservation.
1. System links Reservation to BorrowRecord and sets Reservation status = 'Fulfilled'. | A1: Issue from pre-reservation
At Step 4, Librarian selects reader's active reservation.
1. System links Reservation to BorrowRecord and sets Reservation status = 'Fulfilled'. | A1: Issue from pre-reservation
At Step 4, Librarian selects reader's active reservation.
1. System links Reservation to BorrowRecord and sets Reservation status = 'Fulfilled'. |
| Exceptions: | E1: Reader code not found or locked
At Step 3: Account invalid or locked.
• System displays: "Mã độc giả không tồn tại hoặc tài khoản đã bị khóa."

E2: Reader has pending fines
At Step 3: Fine balance > 0.
• System displays: "Độc giả đang có tiền phạt chưa nộp. Vui lòng thanh toán trước."

E3: Invalid barcode
At Step 4: Barcode not found in BookCopy table.
• System displays: "Mã vạch bản sao sách không tồn tại."

E4: Copy not available
At Step 5: Copy status is 'Borrowed' or 'Maintenance'.
• System displays: "Bản sao sách này hiện không ở trạng thái sẵn sàng để mượn." | E1: Reader code not found or locked
At Step 3: Account invalid or locked.
• System displays: "Mã độc giả không tồn tại hoặc tài khoản đã bị khóa."

E2: Reader has pending fines
At Step 3: Fine balance > 0.
• System displays: "Độc giả đang có tiền phạt chưa nộp. Vui lòng thanh toán trước."

E3: Invalid barcode
At Step 4: Barcode not found in BookCopy table.
• System displays: "Mã vạch bản sao sách không tồn tại."

E4: Copy not available
At Step 5: Copy status is 'Borrowed' or 'Maintenance'.
• System displays: "Bản sao sách này hiện không ở trạng thái sẵn sàng để mượn." | E1: Reader code not found or locked
At Step 3: Account invalid or locked.
• System displays: "Mã độc giả không tồn tại hoặc tài khoản đã bị khóa."

E2: Reader has pending fines
At Step 3: Fine balance > 0.
• System displays: "Độc giả đang có tiền phạt chưa nộp. Vui lòng thanh toán trước."

E3: Invalid barcode
At Step 4: Barcode not found in BookCopy table.
• System displays: "Mã vạch bản sao sách không tồn tại."

E4: Copy not available
At Step 5: Copy status is 'Borrowed' or 'Maintenance'.
• System displays: "Bản sao sách này hiện không ở trạng thái sẵn sàng để mượn." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-22, BR-23, BR-29 | • BR-22, BR-23, BR-29 | • BR-22, BR-23, BR-29 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-19: Desk Check-in | UC-19: Desk Check-in | UC-19: Desk Check-in |
| --- | --- | --- | --- |
| Created By: | Thai | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | System |
| Trigger: | Librarian processes returned books at circulation desk. | Librarian processes returned books at circulation desk. | Librarian processes returned books at circulation desk. |
| Description: | Librarian scans copy barcode, verifies condition, calculates fine if overdue, and updates inventory. | Librarian scans copy barcode, verifies condition, calculates fine if overdue, and updates inventory. | Librarian scans copy barcode, verifies condition, calculates fine if overdue, and updates inventory. |
| Preconditions: | • Librarian is logged in.
• System is operational and database is accessible. | • Librarian is logged in.
• System is operational and database is accessible. | • Librarian is logged in.
• System is operational and database is accessible. |
| Postconditions: | • BorrowRecord returnedAt updated, copy status set to 'Available', fine created if overdue. | • BorrowRecord returnedAt updated, copy status set to 'Available', fine created if overdue. | • BorrowRecord returnedAt updated, copy status set to 'Available', fine created if overdue. |
| Normal Flow: | 1. Librarian is on Desk Circulation screen ("Receive Return").
2. Librarian scans Copy Barcode. (E1, E2)
3. System retrieves active BorrowRecord for this copy.
4. Librarian selects return condition (Good / Damaged / Lost).
5. System checks if return date > endDate.
6. If overdue, system calculates fineAmount = overdueDays * dailyFineRate and inserts Fine record.
7. Librarian clicks [Xác nhận trả].
8. System updates BorrowRecord (returnedAt = NOW(), status = 'Returned').
9. System updates BookCopy status = 'Available' (or 'Maintenance' if damaged) and increments availableQuantity in Book table.
10. System records transaction in AuditLogs, displays: "Nhận trả sách thành công", and renders Fine payment prompt if fine incurred. | 1. Librarian is on Desk Circulation screen ("Receive Return").
2. Librarian scans Copy Barcode. (E1, E2)
3. System retrieves active BorrowRecord for this copy.
4. Librarian selects return condition (Good / Damaged / Lost).
5. System checks if return date > endDate.
6. If overdue, system calculates fineAmount = overdueDays * dailyFineRate and inserts Fine record.
7. Librarian clicks [Xác nhận trả].
8. System updates BorrowRecord (returnedAt = NOW(), status = 'Returned').
9. System updates BookCopy status = 'Available' (or 'Maintenance' if damaged) and increments availableQuantity in Book table.
10. System records transaction in AuditLogs, displays: "Nhận trả sách thành công", and renders Fine payment prompt if fine incurred. | 1. Librarian is on Desk Circulation screen ("Receive Return").
2. Librarian scans Copy Barcode. (E1, E2)
3. System retrieves active BorrowRecord for this copy.
4. Librarian selects return condition (Good / Damaged / Lost).
5. System checks if return date > endDate.
6. If overdue, system calculates fineAmount = overdueDays * dailyFineRate and inserts Fine record.
7. Librarian clicks [Xác nhận trả].
8. System updates BorrowRecord (returnedAt = NOW(), status = 'Returned').
9. System updates BookCopy status = 'Available' (or 'Maintenance' if damaged) and increments availableQuantity in Book table.
10. System records transaction in AuditLogs, displays: "Nhận trả sách thành công", and renders Fine payment prompt if fine incurred. |
| Alternative Flows: | A1: Process fine payment immediately
At Step 10, Librarian clicks [Thu tiền phạt mặt].
1. System opens Cash Payment dialog (UC-20). | A1: Process fine payment immediately
At Step 10, Librarian clicks [Thu tiền phạt mặt].
1. System opens Cash Payment dialog (UC-20). | A1: Process fine payment immediately
At Step 10, Librarian clicks [Thu tiền phạt mặt].
1. System opens Cash Payment dialog (UC-20). |
| Exceptions: | E1: Barcode not found
At Step 2: Barcode does not exist.
• System displays: "Mã vạch bản sao sách không tồn tại."

E2: Copy not currently borrowed
At Step 3: No active BorrowRecord found for barcode.
• System displays: "Bản sao sách này không nằm trong danh sách đang mượn." | E1: Barcode not found
At Step 2: Barcode does not exist.
• System displays: "Mã vạch bản sao sách không tồn tại."

E2: Copy not currently borrowed
At Step 3: No active BorrowRecord found for barcode.
• System displays: "Bản sao sách này không nằm trong danh sách đang mượn." | E1: Barcode not found
At Step 2: Barcode does not exist.
• System displays: "Mã vạch bản sao sách không tồn tại."

E2: Copy not currently borrowed
At Step 3: No active BorrowRecord found for barcode.
• System displays: "Bản sao sách này không nằm trong danh sách đang mượn." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-24, BR-35, BR-47 | • BR-24, BR-35, BR-47 | • BR-24, BR-35, BR-47 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-20: Process Cash Payment | UC-20: Process Cash Payment | UC-20: Process Cash Payment |
| --- | --- | --- | --- |
| Created By: | Thai | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | None |
| Trigger: | Librarian collects cash fine payments at desk. | Librarian collects cash fine payments at desk. | Librarian collects cash fine payments at desk. |
| Description: | Librarian receives cash payment for overdue/damaged fines and issues receipt. | Librarian receives cash payment for overdue/damaged fines and issues receipt. | Librarian receives cash payment for overdue/damaged fines and issues receipt. |
| Preconditions: | • Librarian is logged in and receiving returned book with fine. | • Librarian is logged in and receiving returned book with fine. | • Librarian is logged in and receiving returned book with fine. |
| Postconditions: | • Fine status updated to 'Paid', Payment record inserted. | • Fine status updated to 'Paid', Payment record inserted. | • Fine status updated to 'Paid', Payment record inserted. |
| Normal Flow: | 1. Librarian is on Desk Fine Payment modal.
2. System displays Fine details: Reader Name, Fine Amount, Reason.
3. Librarian enters paidAmount and selects Payment Method = Cash.
4. Librarian clicks [Xác nhận thu tiền]. (A1, E1)
5. System inserts record into Payment table (processedBy = staffId, paymentMethod = 'Cash').
6. System updates Fine status = 'Paid'.
7. System records transaction in AuditLogs, displays: "Thanh toán tiền phạt thành công", and prints receipt. | 1. Librarian is on Desk Fine Payment modal.
2. System displays Fine details: Reader Name, Fine Amount, Reason.
3. Librarian enters paidAmount and selects Payment Method = Cash.
4. Librarian clicks [Xác nhận thu tiền]. (A1, E1)
5. System inserts record into Payment table (processedBy = staffId, paymentMethod = 'Cash').
6. System updates Fine status = 'Paid'.
7. System records transaction in AuditLogs, displays: "Thanh toán tiền phạt thành công", and prints receipt. | 1. Librarian is on Desk Fine Payment modal.
2. System displays Fine details: Reader Name, Fine Amount, Reason.
3. Librarian enters paidAmount and selects Payment Method = Cash.
4. Librarian clicks [Xác nhận thu tiền]. (A1, E1)
5. System inserts record into Payment table (processedBy = staffId, paymentMethod = 'Cash').
6. System updates Fine status = 'Paid'.
7. System records transaction in AuditLogs, displays: "Thanh toán tiền phạt thành công", and prints receipt. |
| Alternative Flows: | A1: Cancel cash payment
At Step 4, Librarian clicks [Hủy].
1. Fine remains unpaid. | A1: Cancel cash payment
At Step 4, Librarian clicks [Hủy].
1. Fine remains unpaid. | A1: Cancel cash payment
At Step 4, Librarian clicks [Hủy].
1. Fine remains unpaid. |
| Exceptions: | E1: Insufficient cash amount
At Step 4: paidAmount < fineAmount.
• System displays: "Số tiền nộp nhỏ hơn tổng tiền phạt." | E1: Insufficient cash amount
At Step 4: paidAmount < fineAmount.
• System displays: "Số tiền nộp nhỏ hơn tổng tiền phạt." | E1: Insufficient cash amount
At Step 4: paidAmount < fineAmount.
• System displays: "Số tiền nộp nhỏ hơn tổng tiền phạt." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-22, BR-25 | • BR-22, BR-25 | • BR-22, BR-25 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-21: Login with Google | UC-21: Login with Google | UC-21: Login with Google |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | Guest | Secondary Actors: | Google Identity Service |
| Trigger: | User wants to authenticate quickly using Google SSO. | User wants to authenticate quickly using Google SSO. | User wants to authenticate quickly using Google SSO. |
| Description: | User logs into LMS using Google OAuth2 account credentials. | User logs into LMS using Google OAuth2 account credentials. | User logs into LMS using Google OAuth2 account credentials. |
| Preconditions: | • User has an active Google account.
• System is operational and OAuth2 client configured. | • User has an active Google account.
• System is operational and OAuth2 client configured. | • User has an active Google account.
• System is operational and OAuth2 client configured. |
| Postconditions: | • User authenticated and session established.
• System logs action in AuditLogs. | • User authenticated and session established.
• System logs action in AuditLogs. | • User authenticated and session established.
• System logs action in AuditLogs. |
| Normal Flow: | 1. User clicks [Đăng nhập với Google] button on Login page. (A1)
2. System redirects user to Google OAuth2 authorization URL.
3. User authenticates with Google and grants permissions.
4. Google redirects back to LMS callback URL with authorization code.
5. System exchanges code for access token and retrieves Google user profile.
6. System queries "User" table by Google email. (E1)
7. System creates session and redirects user to role dashboard. | 1. User clicks [Đăng nhập với Google] button on Login page. (A1)
2. System redirects user to Google OAuth2 authorization URL.
3. User authenticates with Google and grants permissions.
4. Google redirects back to LMS callback URL with authorization code.
5. System exchanges code for access token and retrieves Google user profile.
6. System queries "User" table by Google email. (E1)
7. System creates session and redirects user to role dashboard. | 1. User clicks [Đăng nhập với Google] button on Login page. (A1)
2. System redirects user to Google OAuth2 authorization URL.
3. User authenticates with Google and grants permissions.
4. Google redirects back to LMS callback URL with authorization code.
5. System exchanges code for access token and retrieves Google user profile.
6. System queries "User" table by Google email. (E1)
7. System creates session and redirects user to role dashboard. |
| Alternative Flows: | A1: Cancel Google SSO
At Step 3, User cancels Google prompt.
1. User returned to Login page. | A1: Cancel Google SSO
At Step 3, User cancels Google prompt.
1. User returned to Login page. | A1: Cancel Google SSO
At Step 3, User cancels Google prompt.
1. User returned to Login page. |
| Exceptions: | E1: Unauthorized email domain
At Step 6: Email domain not allowed.
• System displays: "Email domain is not authorized for library access." | E1: Unauthorized email domain
At Step 6: Email domain not allowed.
• System displays: "Email domain is not authorized for library access." | E1: Unauthorized email domain
At Step 6: Email domain not allowed.
• System displays: "Email domain is not authorized for library access." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-26 | • BR-26 | • BR-26 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-22: Search & View Books | UC-22: Search & View Books | UC-22: Search & View Books |
| --- | --- | --- | --- |
| Created By: | Bao | Date Created: | 2026-06-27 |
| Primary Actor: | User | Secondary Actors: | None |
| Trigger: | Guest or User wants to search and browse books. | Guest or User wants to search and browse books. | Guest or User wants to search and browse books. |
| Description: | User searches book titles by keyword, author, category, or tag. | User searches book titles by keyword, author, category, or tag. | User searches book titles by keyword, author, category, or tag. |
| Preconditions: | • System is operational and database accessible. | • System is operational and database accessible. | • System is operational and database accessible. |
| Postconditions: | • Matching book search results rendered. | • Matching book search results rendered. | • Matching book search results rendered. |
| Normal Flow: | 1. User accesses Search page.
2. System displays search bar, category dropdown, tag filter, and sort options.
3. User enters keyword and clicks [Tìm kiếm]. (A1, E1)
4. System queries Book table matching criteria. (E1)
5. System renders paginated list of books with title, author, cover, availability. | 1. User accesses Search page.
2. System displays search bar, category dropdown, tag filter, and sort options.
3. User enters keyword and clicks [Tìm kiếm]. (A1, E1)
4. System queries Book table matching criteria. (E1)
5. System renders paginated list of books with title, author, cover, availability. | 1. User accesses Search page.
2. System displays search bar, category dropdown, tag filter, and sort options.
3. User enters keyword and clicks [Tìm kiếm]. (A1, E1)
4. System queries Book table matching criteria. (E1)
5. System renders paginated list of books with title, author, cover, availability. |
| Alternative Flows: | A1: Filter by category
At Step 3, User selects Category filter.
1. Search results filtered by selected category. | A1: Filter by category
At Step 3, User selects Category filter.
1. Search results filtered by selected category. | A1: Filter by category
At Step 3, User selects Category filter.
1. Search results filtered by selected category. |
| Exceptions: | E1: No books found
At Step 4: 0 records match criteria.
• System displays: "Không tìm thấy đầu sách nào phù hợp." | E1: No books found
At Step 4: 0 records match criteria.
• System displays: "Không tìm thấy đầu sách nào phù hợp." | E1: No books found
At Step 4: 0 records match criteria.
• System displays: "Không tìm thấy đầu sách nào phù hợp." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-38 | • BR-38 | • BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-23: Get AI Recommendation | UC-23: Get AI Recommendation | UC-23: Get AI Recommendation |
| --- | --- | --- | --- |
| Created By: | Bao | Date Created: | 2026-06-27 |
| Primary Actor: | User | Secondary Actors: | Gemini API |
| Trigger: | User wants AI recommendations for books. | User wants AI recommendations for books. | User wants AI recommendations for books. |
| Description: | User requests AI-powered personalized book suggestions. | User requests AI-powered personalized book suggestions. | User requests AI-powered personalized book suggestions. |
| Preconditions: | • User is logged in.
• OpenAI/Gemini service configured. | • User is logged in.
• OpenAI/Gemini service configured. | • User is logged in.
• OpenAI/Gemini service configured. |
| Postconditions: | • Recommended book list displayed. | • Recommended book list displayed. | • Recommended book list displayed. |
| Normal Flow: | 1. User clicks "AI Book Recommendations" page.
2. System queries user reading history from BorrowRecord table.
3. System sends reading prompt to AI Recommendation API. (E1)
4. System parses AI response into list of recommended ISBNs.
5. System queries Book details and displays recommendations with explanation badges. (A1) | 1. User clicks "AI Book Recommendations" page.
2. System queries user reading history from BorrowRecord table.
3. System sends reading prompt to AI Recommendation API. (E1)
4. System parses AI response into list of recommended ISBNs.
5. System queries Book details and displays recommendations with explanation badges. (A1) | 1. User clicks "AI Book Recommendations" page.
2. System queries user reading history from BorrowRecord table.
3. System sends reading prompt to AI Recommendation API. (E1)
4. System parses AI response into list of recommended ISBNs.
5. System queries Book details and displays recommendations with explanation badges. (A1) |
| Alternative Flows: | A1: Refresh recommendations
At Step 5, User clicks [Làm mới gợi ý].
1. System fetches new recommendations. | A1: Refresh recommendations
At Step 5, User clicks [Làm mới gợi ý].
1. System fetches new recommendations. | A1: Refresh recommendations
At Step 5, User clicks [Làm mới gợi ý].
1. System fetches new recommendations. |
| Exceptions: | E1: AI service timeout
At Step 3: API call times out.
• System displays: "AI Recommendation service is temporarily unavailable." | E1: AI service timeout
At Step 3: API call times out.
• System displays: "AI Recommendation service is temporarily unavailable." | E1: AI service timeout
At Step 3: API call times out.
• System displays: "AI Recommendation service is temporarily unavailable." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-37 | • BR-37 | • BR-37 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-24: Manage Notifications | UC-24: Manage Notifications | UC-24: Manage Notifications |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | Library Manager | Secondary Actors: | None |
| Trigger: | Manager wants to publish or manage system notifications. | Manager wants to publish or manage system notifications. | Manager wants to publish or manage system notifications. |
| Description: | Manager creates, updates, or pins system-wide announcements. | Manager creates, updates, or pins system-wide announcements. | Manager creates, updates, or pins system-wide announcements. |
| Preconditions: | • Manager is logged in.
• System is operational. | • Manager is logged in.
• System is operational. | • Manager is logged in.
• System is operational. |
| Postconditions: | • Notification record updated in database. | • Notification record updated in database. | • Notification record updated in database. |
| Normal Flow: | 1. Manager navigates to "Notification Management" page.
2. System displays notification list.
3. Manager clicks [+ Tạo thông báo] button.
4. System opens modal dialog with Title *, Content *, Type, and Pinned checkbox.
5. Manager enters announcement details and clicks [Đăng thông báo]. (A1, E1)
6. System inserts Notification record.
7. System closes modal and refreshes notification list. | 1. Manager navigates to "Notification Management" page.
2. System displays notification list.
3. Manager clicks [+ Tạo thông báo] button.
4. System opens modal dialog with Title *, Content *, Type, and Pinned checkbox.
5. Manager enters announcement details and clicks [Đăng thông báo]. (A1, E1)
6. System inserts Notification record.
7. System closes modal and refreshes notification list. | 1. Manager navigates to "Notification Management" page.
2. System displays notification list.
3. Manager clicks [+ Tạo thông báo] button.
4. System opens modal dialog with Title *, Content *, Type, and Pinned checkbox.
5. Manager enters announcement details and clicks [Đăng thông báo]. (A1, E1)
6. System inserts Notification record.
7. System closes modal and refreshes notification list. |
| Alternative Flows: | A1: Cancel notification creation
At Step 5, Manager clicks [Hủy].
1. Modal closes with no changes. | A1: Cancel notification creation
At Step 5, Manager clicks [Hủy].
1. Modal closes with no changes. | A1: Cancel notification creation
At Step 5, Manager clicks [Hủy].
1. Modal closes with no changes. |
| Exceptions: | E1: Missing notification title/content
At Step 5: Required fields missing.
• System displays: "Please fill in notification title and content." | E1: Missing notification title/content
At Step 5: Required fields missing.
• System displays: "Please fill in notification title and content." | E1: Missing notification title/content
At Step 5: Required fields missing.
• System displays: "Please fill in notification title and content." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-31, BR-38 | • BR-31, BR-38 | • BR-31, BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-25: View Notifications | UC-25: View Notifications | UC-25: View Notifications |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | User | Secondary Actors: | None |
| Trigger: | User views inbox notifications. | User views inbox notifications. | User views inbox notifications. |
| Description: | User reads notifications sent to their account. | User reads notifications sent to their account. | User reads notifications sent to their account. |
| Preconditions: | • User is logged in. | • User is logged in. | • User is logged in. |
| Postconditions: | • Notifications marked as read. | • Notifications marked as read. | • Notifications marked as read. |
| Normal Flow: | 1. User clicks notification bell icon in header.
2. System queries Notification and UserNotificationStatus tables. (E1)
3. System displays notification dropdown list. (A1)
4. User clicks a notification item.
5. System updates readAt timestamp in UserNotificationStatus table. | 1. User clicks notification bell icon in header.
2. System queries Notification and UserNotificationStatus tables. (E1)
3. System displays notification dropdown list. (A1)
4. User clicks a notification item.
5. System updates readAt timestamp in UserNotificationStatus table. | 1. User clicks notification bell icon in header.
2. System queries Notification and UserNotificationStatus tables. (E1)
3. System displays notification dropdown list. (A1)
4. User clicks a notification item.
5. System updates readAt timestamp in UserNotificationStatus table. |
| Alternative Flows: | A1: Mark all as read
At Step 3, User clicks [Đánh dấu tất cả đã đọc].
1. All notifications set to read. | A1: Mark all as read
At Step 3, User clicks [Đánh dấu tất cả đã đọc].
1. All notifications set to read. | A1: Mark all as read
At Step 3, User clicks [Đánh dấu tất cả đã đọc].
1. All notifications set to read. |
| Exceptions: | E1: Notifications empty
At Step 2: 0 notifications.
• System displays: "You have no unread notifications." | E1: Notifications empty
At Step 2: 0 notifications.
• System displays: "You have no unread notifications." | E1: Notifications empty
At Step 2: 0 notifications.
• System displays: "You have no unread notifications." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-38 | • BR-38 | • BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-26: Manage Document Templates | UC-26: Manage Document Templates | UC-26: Manage Document Templates |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | Library Manager | Secondary Actors: | None |
| Trigger: | Manager creates or updates email/document templates. | Manager creates or updates email/document templates. | Manager creates or updates email/document templates. |
| Description: | Manager modifies template subjects and body content for automated emails. | Manager modifies template subjects and body content for automated emails. | Manager modifies template subjects and body content for automated emails. |
| Preconditions: | • Manager is logged in. | • Manager is logged in. | • Manager is logged in. |
| Postconditions: | • DocumentTemp record updated in database. | • DocumentTemp record updated in database. | • DocumentTemp record updated in database. |
| Normal Flow: | 1. Manager navigates to "Document Template Manager" page.
2. System displays list of document templates.
3. Manager selects a template row and clicks [Sửa mẫu văn bản].
4. System opens editor with Subject * and Body Content (HTML/Markdown).
5. Manager edits template content and clicks [Lưu mẫu văn bản]. (A1, E1)
6. System updates DocumentTemp record in database. | 1. Manager navigates to "Document Template Manager" page.
2. System displays list of document templates.
3. Manager selects a template row and clicks [Sửa mẫu văn bản].
4. System opens editor with Subject * and Body Content (HTML/Markdown).
5. Manager edits template content and clicks [Lưu mẫu văn bản]. (A1, E1)
6. System updates DocumentTemp record in database. | 1. Manager navigates to "Document Template Manager" page.
2. System displays list of document templates.
3. Manager selects a template row and clicks [Sửa mẫu văn bản].
4. System opens editor with Subject * and Body Content (HTML/Markdown).
5. Manager edits template content and clicks [Lưu mẫu văn bản]. (A1, E1)
6. System updates DocumentTemp record in database. |
| Alternative Flows: | A1: Cancel template edit
At Step 5, Manager clicks [Hủy].
1. Template changes discarded. | A1: Cancel template edit
At Step 5, Manager clicks [Hủy].
1. Template changes discarded. | A1: Cancel template edit
At Step 5, Manager clicks [Hủy].
1. Template changes discarded. |
| Exceptions: | E1: Missing template body
At Step 5: Content is blank.
• System displays: "Template subject and body content cannot be empty." | E1: Missing template body
At Step 5: Content is blank.
• System displays: "Template subject and body content cannot be empty." | E1: Missing template body
At Step 5: Content is blank.
• System displays: "Template subject and body content cannot be empty." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-47, BR-51 | • BR-47, BR-51 | • BR-47, BR-51 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-27: Import Bulk Books | UC-27: Import Bulk Books | UC-27: Import Bulk Books |
| --- | --- | --- | --- |
| Created By: | Chuong | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | None |
| Trigger: | Librarian imports bulk book records from Excel. | Librarian imports bulk book records from Excel. | Librarian imports bulk book records from Excel. |
| Description: | Librarian uploads .xlsx file containing book titles and metadata. | Librarian uploads .xlsx file containing book titles and metadata. | Librarian uploads .xlsx file containing book titles and metadata. |
| Preconditions: | • Librarian is logged in. | • Librarian is logged in. | • Librarian is logged in. |
| Postconditions: | • Multiple Book records inserted into database. | • Multiple Book records inserted into database. | • Multiple Book records inserted into database. |
| Normal Flow: | 1. Librarian navigates to Book Catalog page.
2. Librarian clicks [Nhập danh sách sách Excel] button.
3. System opens import modal dialog.
4. Librarian uploads Excel file and clicks [Xem trước danh sách]. (A1, E1)
5. System validates rows using BookImportValidator. (E1)
6. System displays preview summary.
7. Librarian clicks [Xác nhận nhập sách].
8. System inserts books in batch transaction and records in BookImportBatch. | 1. Librarian navigates to Book Catalog page.
2. Librarian clicks [Nhập danh sách sách Excel] button.
3. System opens import modal dialog.
4. Librarian uploads Excel file and clicks [Xem trước danh sách]. (A1, E1)
5. System validates rows using BookImportValidator. (E1)
6. System displays preview summary.
7. Librarian clicks [Xác nhận nhập sách].
8. System inserts books in batch transaction and records in BookImportBatch. | 1. Librarian navigates to Book Catalog page.
2. Librarian clicks [Nhập danh sách sách Excel] button.
3. System opens import modal dialog.
4. Librarian uploads Excel file and clicks [Xem trước danh sách]. (A1, E1)
5. System validates rows using BookImportValidator. (E1)
6. System displays preview summary.
7. Librarian clicks [Xác nhận nhập sách].
8. System inserts books in batch transaction and records in BookImportBatch. |
| Alternative Flows: | A1: Cancel bulk book import
At Step 4, Librarian clicks [Hủy].
1. Import cancelled. | A1: Cancel bulk book import
At Step 4, Librarian clicks [Hủy].
1. Import cancelled. | A1: Cancel bulk book import
At Step 4, Librarian clicks [Hủy].
1. Import cancelled. |
| Exceptions: | E1: Corrupt Excel file
At Step 5: File invalid.
• System displays: "Invalid file format. Please use sample Excel template." | E1: Corrupt Excel file
At Step 5: File invalid.
• System displays: "Invalid file format. Please use sample Excel template." | E1: Corrupt Excel file
At Step 5: File invalid.
• System displays: "Invalid file format. Please use sample Excel template." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-16, BR-17, BR-27 | • BR-16, BR-17, BR-27 | • BR-16, BR-17, BR-27 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-28: Report Book Incident | UC-28: Report Book Incident | UC-28: Report Book Incident |
| --- | --- | --- | --- |
| Created By: | Chuong | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | System |
| Trigger: | Librarian or reader reports damaged or lost physical book copy. | Librarian or reader reports damaged or lost physical book copy. | Librarian or reader reports damaged or lost physical book copy. |
| Description: | Librarian creates incident report for copy and sets status to Damaged/Lost. | Librarian creates incident report for copy and sets status to Damaged/Lost. | Librarian creates incident report for copy and sets status to Damaged/Lost. |
| Preconditions: | • User is logged in. | • User is logged in. | • User is logged in. |
| Postconditions: | • BookCopyIncident record inserted and copy status updated. | • BookCopyIncident record inserted and copy status updated. | • BookCopyIncident record inserted and copy status updated. |
| Normal Flow: | 1. Librarian navigates to "Book Copy Incident Reporting" screen.
2. Librarian scans copy barcode. (E1)
3. System retrieves copy details.
4. Librarian selects Incident Type (Damaged / Lost / Misplaced) and enters description.
5. Librarian clicks [Gửi báo cáo sự cố]. (A1)
6. System inserts BookCopyIncident record and updates BookCopy status. | 1. Librarian navigates to "Book Copy Incident Reporting" screen.
2. Librarian scans copy barcode. (E1)
3. System retrieves copy details.
4. Librarian selects Incident Type (Damaged / Lost / Misplaced) and enters description.
5. Librarian clicks [Gửi báo cáo sự cố]. (A1)
6. System inserts BookCopyIncident record and updates BookCopy status. | 1. Librarian navigates to "Book Copy Incident Reporting" screen.
2. Librarian scans copy barcode. (E1)
3. System retrieves copy details.
4. Librarian selects Incident Type (Damaged / Lost / Misplaced) and enters description.
5. Librarian clicks [Gửi báo cáo sự cố]. (A1)
6. System inserts BookCopyIncident record and updates BookCopy status. |
| Alternative Flows: | A1: Cancel incident report
At Step 5, Librarian clicks [Hủy].
1. Report cancelled. | A1: Cancel incident report
At Step 5, Librarian clicks [Hủy].
1. Report cancelled. | A1: Cancel incident report
At Step 5, Librarian clicks [Hủy].
1. Report cancelled. |
| Exceptions: | E1: Barcode not found
At Step 2: Barcode invalid.
• System displays: "Mã vạch bản sao sách không tồn tại." | E1: Barcode not found
At Step 2: Barcode invalid.
• System displays: "Mã vạch bản sao sách không tồn tại." | E1: Barcode not found
At Step 2: Barcode invalid.
• System displays: "Mã vạch bản sao sách không tồn tại." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-24, BR-28 | • BR-24, BR-28 | • BR-24, BR-28 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-29: Inventory Reconciliation | UC-29: Inventory Reconciliation | UC-29: Inventory Reconciliation |
| --- | --- | --- | --- |
| Created By: | Chuong | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | None |
| Trigger: | Librarian conducts physical inventory reconciliation. | Librarian conducts physical inventory reconciliation. | Librarian conducts physical inventory reconciliation. |
| Description: | Librarian scans shelf copy barcodes during inventory audit session. | Librarian scans shelf copy barcodes during inventory audit session. | Librarian scans shelf copy barcodes during inventory audit session. |
| Preconditions: | • Librarian is logged in. | • Librarian is logged in. | • Librarian is logged in. |
| Postconditions: | • InventorySession and InventoryItem records updated. | • InventorySession and InventoryItem records updated. | • InventorySession and InventoryItem records updated. |
| Normal Flow: | 1. Librarian starts new Inventory Session for location shelf. (E1)
2. System creates InventorySession record (status = 'In Progress').
3. Librarian scans copy barcodes on physical shelf.
4. System matches scanned location against expectedLocation in BookCopy table.
5. Librarian clicks [Hoàn tất kiểm kê]. (A1)
6. System generates reconciliation discrepancy report. | 1. Librarian starts new Inventory Session for location shelf. (E1)
2. System creates InventorySession record (status = 'In Progress').
3. Librarian scans copy barcodes on physical shelf.
4. System matches scanned location against expectedLocation in BookCopy table.
5. Librarian clicks [Hoàn tất kiểm kê]. (A1)
6. System generates reconciliation discrepancy report. | 1. Librarian starts new Inventory Session for location shelf. (E1)
2. System creates InventorySession record (status = 'In Progress').
3. Librarian scans copy barcodes on physical shelf.
4. System matches scanned location against expectedLocation in BookCopy table.
5. Librarian clicks [Hoàn tất kiểm kê]. (A1)
6. System generates reconciliation discrepancy report. |
| Alternative Flows: | A1: Pause session
At Step 5, Librarian clicks [Tạm dừng phiên].
1. Session saved for later resume. | A1: Pause session
At Step 5, Librarian clicks [Tạm dừng phiên].
1. Session saved for later resume. | A1: Pause session
At Step 5, Librarian clicks [Tạm dừng phiên].
1. Session saved for later resume. |
| Exceptions: | E1: Location missing
At Step 1: Shelf location empty.
• System displays: "Please enter a valid shelf location." | E1: Location missing
At Step 1: Shelf location empty.
• System displays: "Please enter a valid shelf location." | E1: Location missing
At Step 1: Shelf location empty.
• System displays: "Please enter a valid shelf location." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-44 | • BR-44 | • BR-44 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-30: Export User List | UC-30: Export User List | UC-30: Export User List |
| --- | --- | --- | --- |
| Created By: | Quyet | Date Created: | 2026-06-27 |
| Primary Actor: | Admin | Secondary Actors: | None |
| Trigger: | Admin exports user account list to Excel file. | Admin exports user account list to Excel file. | Admin exports user account list to Excel file. |
| Description: | Admin downloads user list matching filter criteria as .xlsx file. | Admin downloads user list matching filter criteria as .xlsx file. | Admin downloads user list matching filter criteria as .xlsx file. |
| Preconditions: | • Admin is logged in and viewing User List. | • Admin is logged in and viewing User List. | • Admin is logged in and viewing User List. |
| Postconditions: | • Excel file generated and downloaded. | • Excel file generated and downloaded. | • Excel file generated and downloaded. |
| Normal Flow: | 1. Admin is on User List page (UC-07).
2. Admin applies search/filter criteria and clicks [Xuất Excel] button. (A1)
3. System queries "User", MemberProfile, Student, Lecturer tables matching filter. (E1)
4. System generates Excel workbook using Apache POI.
5. System sends HTTP download response headers, triggering file download.
6. System logs export transaction to AuditLogs and displays: "Xuất danh sách người dùng thành công." | 1. Admin is on User List page (UC-07).
2. Admin applies search/filter criteria and clicks [Xuất Excel] button. (A1)
3. System queries "User", MemberProfile, Student, Lecturer tables matching filter. (E1)
4. System generates Excel workbook using Apache POI.
5. System sends HTTP download response headers, triggering file download.
6. System logs export transaction to AuditLogs and displays: "Xuất danh sách người dùng thành công." | 1. Admin is on User List page (UC-07).
2. Admin applies search/filter criteria and clicks [Xuất Excel] button. (A1)
3. System queries "User", MemberProfile, Student, Lecturer tables matching filter. (E1)
4. System generates Excel workbook using Apache POI.
5. System sends HTTP download response headers, triggering file download.
6. System logs export transaction to AuditLogs and displays: "Xuất danh sách người dùng thành công." |
| Alternative Flows: | A1: Cancel export
At Step 2, Admin cancels export prompt.
1. User list remains displayed without file generation. | A1: Cancel export
At Step 2, Admin cancels export prompt.
1. User list remains displayed without file generation. | A1: Cancel export
At Step 2, Admin cancels export prompt.
1. User list remains displayed without file generation. |
| Exceptions: | E1: No data available
At Step 3: Filter criteria returns 0 records.
• System displays: "No user data available for export." | E1: No data available
At Step 3: Filter criteria returns 0 records.
• System displays: "No user data available for export." | E1: No data available
At Step 3: Filter criteria returns 0 records.
• System displays: "No user data available for export." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-38 | • BR-38 | • BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-31: View My Borrowings & Reservations | UC-31: View My Borrowings & Reservations | UC-31: View My Borrowings & Reservations |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | Student, Lecturer | Secondary Actors: | None |
| Trigger: | Student or Lecturer views active borrowings and reservations. | Student or Lecturer views active borrowings and reservations. | Student or Lecturer views active borrowings and reservations. |
| Description: | User checks current loans, due dates, renewal counts, and reservation queue positions. | User checks current loans, due dates, renewal counts, and reservation queue positions. | User checks current loans, due dates, renewal counts, and reservation queue positions. |
| Preconditions: | • User is logged in. | • User is logged in. | • User is logged in. |
| Postconditions: | • Borrowing and reservation summary table rendered. | • Borrowing and reservation summary table rendered. | • Borrowing and reservation summary table rendered. |
| Normal Flow: | 1. User navigates to "My Borrowings & Reservations" page from top menu.
2. System queries BorrowRecord and Reservation tables for active userId. (E1)
3. System renders active loans table (Title, Barcode, Borrow Date, Due Date, Renewal Count, Action buttons). (A1)
4. System renders active reservations table (Title, Queue Position, Reservation Date, Expiration Date, Action buttons). | 1. User navigates to "My Borrowings & Reservations" page from top menu.
2. System queries BorrowRecord and Reservation tables for active userId. (E1)
3. System renders active loans table (Title, Barcode, Borrow Date, Due Date, Renewal Count, Action buttons). (A1)
4. System renders active reservations table (Title, Queue Position, Reservation Date, Expiration Date, Action buttons). | 1. User navigates to "My Borrowings & Reservations" page from top menu.
2. System queries BorrowRecord and Reservation tables for active userId. (E1)
3. System renders active loans table (Title, Barcode, Borrow Date, Due Date, Renewal Count, Action buttons). (A1)
4. System renders active reservations table (Title, Queue Position, Reservation Date, Expiration Date, Action buttons). |
| Alternative Flows: | A1: Renew loan
At Step 3, User clicks [Gia hạn mượn].
1. System executes Online Loan Renewal workflow (UC-17). | A1: Renew loan
At Step 3, User clicks [Gia hạn mượn].
1. System executes Online Loan Renewal workflow (UC-17). | A1: Renew loan
At Step 3, User clicks [Gia hạn mượn].
1. System executes Online Loan Renewal workflow (UC-17). |
| Exceptions: | E1: No active borrowings
At Step 2: 0 records found.
• System displays: "You currently have no active borrowings or reservations." | E1: No active borrowings
At Step 2: 0 records found.
• System displays: "You currently have no active borrowings or reservations." | E1: No active borrowings
At Step 2: 0 records found.
• System displays: "You currently have no active borrowings or reservations." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-19, BR-38 | • BR-19, BR-38 | • BR-19, BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-32: View System Configuration | UC-32: View System Configuration | UC-32: View System Configuration |
| --- | --- | --- | --- |
| Created By: | Quyet | Date Created: | 2026-06-27 |
| Primary Actor: | Quản lý thư viện, Quản trị viên (Admin) | Secondary Actors: | None |
| Trigger: | Manager or Admin inspects system configuration parameters. | Manager or Admin inspects system configuration parameters. | Manager or Admin inspects system configuration parameters. |
| Description: | User views global parameters such as fine rates, max loans, max renewals, and loan durations. | User views global parameters such as fine rates, max loans, max renewals, and loan durations. | User views global parameters such as fine rates, max loans, max renewals, and loan durations. |
| Preconditions: | • Authorized user is logged in. | • Authorized user is logged in. | • Authorized user is logged in. |
| Postconditions: | • Configuration parameters rendered. | • Configuration parameters rendered. | • Configuration parameters rendered. |
| Normal Flow: | 1. User navigates to "System Configurations" page from sidebar.
2. System queries SystemConfigurations table. (E1)
3. System displays configuration parameters grouped by configGroup. (A1) | 1. User navigates to "System Configurations" page from sidebar.
2. System queries SystemConfigurations table. (E1)
3. System displays configuration parameters grouped by configGroup. (A1) | 1. User navigates to "System Configurations" page from sidebar.
2. System queries SystemConfigurations table. (E1)
3. System displays configuration parameters grouped by configGroup. (A1) |
| Alternative Flows: | A1: Edit configuration
At Step 3, User clicks [Edit Value].
1. System opens Update Configuration modal (UC-33). | A1: Edit configuration
At Step 3, User clicks [Edit Value].
1. System opens Update Configuration modal (UC-33). | A1: Edit configuration
At Step 3, User clicks [Edit Value].
1. System opens Update Configuration modal (UC-33). |
| Exceptions: | E1: Configurations empty
At Step 2: Query fails.
• System displays: "System configuration data unavailable." | E1: Configurations empty
At Step 2: Query fails.
• System displays: "System configuration data unavailable." | E1: Configurations empty
At Step 2: Query fails.
• System displays: "System configuration data unavailable." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-31 | • BR-31 | • BR-31 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-33: Update System Configuration | UC-33: Update System Configuration | UC-33: Update System Configuration |
| --- | --- | --- | --- |
| Created By: | Quyet | Date Created: | 2026-06-27 |
| Primary Actor: | Quản lý thư viện, Quản trị viên (Admin) | Secondary Actors: | None |
| Trigger: | Manager or Admin updates system parameters. | Manager or Admin updates system parameters. | Manager or Admin updates system parameters. |
| Description: | User modifies configuration values (e.g. daily fine rate, renewal limit). | User modifies configuration values (e.g. daily fine rate, renewal limit). | User modifies configuration values (e.g. daily fine rate, renewal limit). |
| Preconditions: | • Authorized user is logged in. | • Authorized user is logged in. | • Authorized user is logged in. |
| Postconditions: | • SystemConfigurations record updated in database. | • SystemConfigurations record updated in database. | • SystemConfigurations record updated in database. |
| Normal Flow: | 1. User is on System Configuration page (UC-32).
2. User selects parameter row and clicks [Edit Value].
3. System opens Update Configuration modal.
4. User enters new value and description, then clicks [Lưu thay đổi]. (A1, E1)
5. System updates SystemConfigurations table and logs to AuditLogs. | 1. User is on System Configuration page (UC-32).
2. User selects parameter row and clicks [Edit Value].
3. System opens Update Configuration modal.
4. User enters new value and description, then clicks [Lưu thay đổi]. (A1, E1)
5. System updates SystemConfigurations table and logs to AuditLogs. | 1. User is on System Configuration page (UC-32).
2. User selects parameter row and clicks [Edit Value].
3. System opens Update Configuration modal.
4. User enters new value and description, then clicks [Lưu thay đổi]. (A1, E1)
5. System updates SystemConfigurations table and logs to AuditLogs. |
| Alternative Flows: | A1: Cancel configuration update
At Step 4, User clicks [Hủy].
1. Modal closes without updating. | A1: Cancel configuration update
At Step 4, User clicks [Hủy].
1. Modal closes without updating. | A1: Cancel configuration update
At Step 4, User clicks [Hủy].
1. Modal closes without updating. |
| Exceptions: | E1: Invalid parameter value
At Step 4: Value is negative or invalid format.
• System displays: "Please enter a valid configuration parameter value." | E1: Invalid parameter value
At Step 4: Value is negative or invalid format.
• System displays: "Please enter a valid configuration parameter value." | E1: Invalid parameter value
At Step 4: Value is negative or invalid format.
• System displays: "Please enter a valid configuration parameter value." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-30, BR-31, BR-40 | • BR-30, BR-31, BR-40 | • BR-30, BR-31, BR-40 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-34: View System Reports | UC-34: View System Reports | UC-34: View System Reports |
| --- | --- | --- | --- |
| Created By: | Quyet | Date Created: | 2026-06-27 |
| Primary Actor: | Quản lý thư viện, Quản trị viên (Admin) | Secondary Actors: | None |
| Trigger: | Manager views executive analytics and library operation reports. | Manager views executive analytics and library operation reports. | Manager views executive analytics and library operation reports. |
| Description: | Manager views charts and summaries of borrowings, returns, overdue fines, and active readers. | Manager views charts and summaries of borrowings, returns, overdue fines, and active readers. | Manager views charts and summaries of borrowings, returns, overdue fines, and active readers. |
| Preconditions: | • Manager is logged in. | • Manager is logged in. | • Manager is logged in. |
| Postconditions: | • Report dashboard rendered. | • Report dashboard rendered. | • Report dashboard rendered. |
| Normal Flow: | 1. Manager navigates to "System Reports & Analytics" page.
2. System queries aggregated metrics from BorrowRecord, Fine, Payment, and Book tables. (E1)
3. System renders summary metrics cards and charts. (A1) | 1. Manager navigates to "System Reports & Analytics" page.
2. System queries aggregated metrics from BorrowRecord, Fine, Payment, and Book tables. (E1)
3. System renders summary metrics cards and charts. (A1) | 1. Manager navigates to "System Reports & Analytics" page.
2. System queries aggregated metrics from BorrowRecord, Fine, Payment, and Book tables. (E1)
3. System renders summary metrics cards and charts. (A1) |
| Alternative Flows: | A1: Export report
At Step 3, Manager clicks [Export Report Excel].
1. System triggers Export Reports workflow (UC-35). | A1: Export report
At Step 3, Manager clicks [Export Report Excel].
1. System triggers Export Reports workflow (UC-35). | A1: Export report
At Step 3, Manager clicks [Export Report Excel].
1. System triggers Export Reports workflow (UC-35). |
| Exceptions: | E1: Report data load failure
At Step 2: Query timeout.
• System displays: "Report data currently unavailable." | E1: Report data load failure
At Step 2: Query timeout.
• System displays: "Report data currently unavailable." | E1: Report data load failure
At Step 2: Query timeout.
• System displays: "Report data currently unavailable." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-43, BR-44, BR-45 | • BR-43, BR-44, BR-45 | • BR-43, BR-44, BR-45 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-35: Export Reports | UC-35: Export Reports | UC-35: Export Reports |
| --- | --- | --- | --- |
| Created By: | Quyet | Date Created: | 2026-06-27 |
| Primary Actor: | Quản lý thư viện, Quản trị viên (Admin) | Secondary Actors: | None |
| Trigger: | Manager exports analytics report data to Excel. | Manager exports analytics report data to Excel. | Manager exports analytics report data to Excel. |
| Description: | Manager downloads operational metrics and financial summaries as Excel file. | Manager downloads operational metrics and financial summaries as Excel file. | Manager downloads operational metrics and financial summaries as Excel file. |
| Preconditions: | • Manager is logged in. | • Manager is logged in. | • Manager is logged in. |
| Postconditions: | • Excel report generated and downloaded. | • Excel report generated and downloaded. | • Excel report generated and downloaded. |
| Normal Flow: | 1. Manager is on System Reports page (UC-34).
2. Manager selects report date range and clicks [Xuất Excel]. (A1, E1)
3. System queries aggregated metrics from BorrowRecord, Fine, Payment, and Book tables and generates Excel file via Apache POI.
4. System sends file download stream to browser. | 1. Manager is on System Reports page (UC-34).
2. Manager selects report date range and clicks [Xuất Excel]. (A1, E1)
3. System queries aggregated metrics from BorrowRecord, Fine, Payment, and Book tables and generates Excel file via Apache POI.
4. System sends file download stream to browser. | 1. Manager is on System Reports page (UC-34).
2. Manager selects report date range and clicks [Xuất Excel]. (A1, E1)
3. System queries aggregated metrics from BorrowRecord, Fine, Payment, and Book tables and generates Excel file via Apache POI.
4. System sends file download stream to browser. |
| Alternative Flows: | A1: Cancel export
At Step 2, Manager cancels export.
1. Returns to report screen. | A1: Cancel export
At Step 2, Manager cancels export.
1. Returns to report screen. | A1: Cancel export
At Step 2, Manager cancels export.
1. Returns to report screen. |
| Exceptions: | E1: Date range invalid
At Step 2: Start Date > End Date.
• System displays: "Start Date cannot be greater than End Date." | E1: Date range invalid
At Step 2: Start Date > End Date.
• System displays: "Start Date cannot be greater than End Date." | E1: Date range invalid
At Step 2: Start Date > End Date.
• System displays: "Start Date cannot be greater than End Date." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-31, BR-43 | • BR-31, BR-43 | • BR-31, BR-43 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-36: Ask Chatbot | UC-36: Ask Chatbot | UC-36: Ask Chatbot |
| --- | --- | --- | --- |
| Created By: | Thai | Date Created: | 2026-06-27 |
| Primary Actor: | Guest, User | Secondary Actors: | Gemini API |
| Trigger: | User asks AI Chatbot questions about library rules or book availability. | User asks AI Chatbot questions about library rules or book availability. | User asks AI Chatbot questions about library rules or book availability. |
| Description: | User interacts with integrated AI Chatbot assistant. | User interacts with integrated AI Chatbot assistant. | User interacts with integrated AI Chatbot assistant. |
| Preconditions: | • User is on any page. | • User is on any page. | • User is on any page. |
| Postconditions: | • Chatbot response generated and rendered in chat window. | • Chatbot response generated and rendered in chat window. | • Chatbot response generated and rendered in chat window. |
| Normal Flow: | 1. User clicks AI Chatbot floating widget icon.
2. System opens chat widget window.
3. User types question in prompt box and clicks [Gửi]. (A1)
4. System sends prompt to AI Chatbot Service. (E1)
5. System renders AI response message in chat bubble. | 1. User clicks AI Chatbot floating widget icon.
2. System opens chat widget window.
3. User types question in prompt box and clicks [Gửi]. (A1)
4. System sends prompt to AI Chatbot Service. (E1)
5. System renders AI response message in chat bubble. | 1. User clicks AI Chatbot floating widget icon.
2. System opens chat widget window.
3. User types question in prompt box and clicks [Gửi]. (A1)
4. System sends prompt to AI Chatbot Service. (E1)
5. System renders AI response message in chat bubble. |
| Alternative Flows: | A1: Clear chat history
At Step 3, User clicks [Clear History].
1. Chat window cleared. | A1: Clear chat history
At Step 3, User clicks [Clear History].
1. Chat window cleared. | A1: Clear chat history
At Step 3, User clicks [Clear History].
1. Chat window cleared. |
| Exceptions: | E1: AI service unreachable
At Step 4: API connection failed.
• System displays: "AI Chatbot service is temporarily unreachable." | E1: AI service unreachable
At Step 4: API connection failed.
• System displays: "AI Chatbot service is temporarily unreachable." | E1: AI service unreachable
At Step 4: API connection failed.
• System displays: "AI Chatbot service is temporarily unreachable." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-37 | • BR-37 | • BR-37 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-37: View Chat History | UC-37: View Chat History | UC-37: View Chat History |
| --- | --- | --- | --- |
| Created By: | Thai | Date Created: | 2026-06-27 |
| Primary Actor: | User | Secondary Actors: | None |
| Trigger: | User views past AI Chatbot conversation history. | User views past AI Chatbot conversation history. | User views past AI Chatbot conversation history. |
| Description: | User inspects prior chat logs and questions. | User inspects prior chat logs and questions. | User inspects prior chat logs and questions. |
| Preconditions: | • User is logged in. | • User is logged in. | • User is logged in. |
| Postconditions: | • Chat history logs displayed. | • Chat history logs displayed. | • Chat history logs displayed. |
| Normal Flow: | 1. User opens AI Chatbot widget.
2. User clicks "History" tab.
3. System displays list of past question/answer sessions. (A1, E1) | 1. User opens AI Chatbot widget.
2. User clicks "History" tab.
3. System displays list of past question/answer sessions. (A1, E1) | 1. User opens AI Chatbot widget.
2. User clicks "History" tab.
3. System displays list of past question/answer sessions. (A1, E1) |
| Alternative Flows: | A1: Resume past session
At Step 3, User clicks a past session.
1. Chat widget loads selected conversation. | A1: Resume past session
At Step 3, User clicks a past session.
1. Chat widget loads selected conversation. | A1: Resume past session
At Step 3, User clicks a past session.
1. Chat widget loads selected conversation. |
| Exceptions: | E1: History empty
At Step 3: 0 past sessions.
• System displays: "No previous chat history found." | E1: History empty
At Step 3: 0 past sessions.
• System displays: "No previous chat history found." | E1: History empty
At Step 3: 0 past sessions.
• System displays: "No previous chat history found." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-37 | • BR-37 | • BR-37 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-38: View Fine History | UC-38: View Fine History | UC-38: View Fine History |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | User | Secondary Actors: | None |
| Trigger: | User views fine transaction history. | User views fine transaction history. | User views fine transaction history. |
| Description: | User checks accrued fines, reasons, and payment statuses (Paid / Unpaid). | User checks accrued fines, reasons, and payment statuses (Paid / Unpaid). | User checks accrued fines, reasons, and payment statuses (Paid / Unpaid). |
| Preconditions: | • User is logged in. | • User is logged in. | • User is logged in. |
| Postconditions: | • Fine history list rendered. | • Fine history list rendered. | • Fine history list rendered. |
| Normal Flow: | 1. User navigates to "Fine History & Payments" page.
2. System queries Fine and Payment tables for active user. (E1)
3. System displays fine table (Fine ID, Borrow Record, Amount, Reason, Status, Created At, Action button). (A1) | 1. User navigates to "Fine History & Payments" page.
2. System queries Fine and Payment tables for active user. (E1)
3. System displays fine table (Fine ID, Borrow Record, Amount, Reason, Status, Created At, Action button). (A1) | 1. User navigates to "Fine History & Payments" page.
2. System queries Fine and Payment tables for active user. (E1)
3. System displays fine table (Fine ID, Borrow Record, Amount, Reason, Status, Created At, Action button). (A1) |
| Alternative Flows: | A1: Pay online
At Step 3, User selects unpaid fine and clicks [Thanh toán Online].
1. System redirects to Pay Fine Online workflow (UC-39). | A1: Pay online
At Step 3, User selects unpaid fine and clicks [Thanh toán Online].
1. System redirects to Pay Fine Online workflow (UC-39). | A1: Pay online
At Step 3, User selects unpaid fine and clicks [Thanh toán Online].
1. System redirects to Pay Fine Online workflow (UC-39). |
| Exceptions: | E1: Fine history empty
At Step 2: 0 fine records.
• System displays: "You have no fine history records." | E1: Fine history empty
At Step 2: 0 fine records.
• System displays: "You have no fine history records." | E1: Fine history empty
At Step 2: 0 fine records.
• System displays: "You have no fine history records." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-22, BR-35 | • BR-22, BR-35 | • BR-22, BR-35 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-39: Pay Fine Online | UC-39: Pay Fine Online | UC-39: Pay Fine Online |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | User | Secondary Actors: | SePay API |
| Trigger: | User pays unpaid fines online via payment gateway (VNPAY / SePay). | User pays unpaid fines online via payment gateway (VNPAY / SePay). | User pays unpaid fines online via payment gateway (VNPAY / SePay). |
| Description: | User initiates online payment for library fines. | User initiates online payment for library fines. | User initiates online payment for library fines. |
| Preconditions: | • User has unpaid fines and is logged in. | • User has unpaid fines and is logged in. | • User has unpaid fines and is logged in. |
| Postconditions: | • Payment processed, Fine status set to 'Paid'. | • Payment processed, Fine status set to 'Paid'. | • Payment processed, Fine status set to 'Paid'. |
| Normal Flow: | 1. User is on Fine History page (UC-38) and selects unpaid Fine record(s).
2. User clicks [Thanh toán Online (SePay / VNPAY)]. (A1)
3. System creates pending Payment record and generates payment URL.
4. System redirects user to Payment Gateway page.
5. User completes payment on gateway.
6. Payment gateway sends webhook callback to LMS. (E1)
7. System updates Payment status = 'Completed' and Fine status = 'Paid'.
8. System displays: "Thanh toán tiền phạt thành công." | 1. User is on Fine History page (UC-38) and selects unpaid Fine record(s).
2. User clicks [Thanh toán Online (SePay / VNPAY)]. (A1)
3. System creates pending Payment record and generates payment URL.
4. System redirects user to Payment Gateway page.
5. User completes payment on gateway.
6. Payment gateway sends webhook callback to LMS. (E1)
7. System updates Payment status = 'Completed' and Fine status = 'Paid'.
8. System displays: "Thanh toán tiền phạt thành công." | 1. User is on Fine History page (UC-38) and selects unpaid Fine record(s).
2. User clicks [Thanh toán Online (SePay / VNPAY)]. (A1)
3. System creates pending Payment record and generates payment URL.
4. System redirects user to Payment Gateway page.
5. User completes payment on gateway.
6. Payment gateway sends webhook callback to LMS. (E1)
7. System updates Payment status = 'Completed' and Fine status = 'Paid'.
8. System displays: "Thanh toán tiền phạt thành công." |
| Alternative Flows: | A1: Cancel online payment
At Step 4, User cancels payment on gateway.
1. System marks payment as cancelled and fine remains unpaid. | A1: Cancel online payment
At Step 4, User cancels payment on gateway.
1. System marks payment as cancelled and fine remains unpaid. | A1: Cancel online payment
At Step 4, User cancels payment on gateway.
1. System marks payment as cancelled and fine remains unpaid. |
| Exceptions: | E1: Gateway verification error
At Step 6: Webhook signature invalid.
• System rejects transaction and logs error. | E1: Gateway verification error
At Step 6: Webhook signature invalid.
• System rejects transaction and logs error. | E1: Gateway verification error
At Step 6: Webhook signature invalid.
• System rejects transaction and logs error. |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-22, BR-25, BR-53 | • BR-22, BR-25, BR-53 | • BR-22, BR-25, BR-53 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-40: View Audit Log | UC-40: View Audit Log | UC-40: View Audit Log |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | SysQuản trị viên (Admin) | Secondary Actors: | None |
| Trigger: | Admin views system audit logs. | Admin views system audit logs. | Admin views system audit logs. |
| Description: | Admin inspects C/U/D security audit logs to track user actions. | Admin inspects C/U/D security audit logs to track user actions. | Admin inspects C/U/D security audit logs to track user actions. |
| Preconditions: | • Admin is logged in. | • Admin is logged in. | • Admin is logged in. |
| Postconditions: | • AuditLog table rendered. | • AuditLog table rendered. | • AuditLog table rendered. |
| Normal Flow: | 1. Admin navigates to "System Audit Logs" page from sidebar.
2. System queries AuditLogs table. (E1)
3. System displays audit log table (Log ID, User, Action Type, Entity Name, Entity ID, Timestamp, Details). (A1) | 1. Admin navigates to "System Audit Logs" page from sidebar.
2. System queries AuditLogs table. (E1)
3. System displays audit log table (Log ID, User, Action Type, Entity Name, Entity ID, Timestamp, Details). (A1) | 1. Admin navigates to "System Audit Logs" page from sidebar.
2. System queries AuditLogs table. (E1)
3. System displays audit log table (Log ID, User, Action Type, Entity Name, Entity ID, Timestamp, Details). (A1) |
| Alternative Flows: | A1: Export audit log
At Step 3, Admin clicks [Xuất Audit Log Excel].
1. System triggers Export Audit Log workflow (UC-41). | A1: Export audit log
At Step 3, Admin clicks [Xuất Audit Log Excel].
1. System triggers Export Audit Log workflow (UC-41). | A1: Export audit log
At Step 3, Admin clicks [Xuất Audit Log Excel].
1. System triggers Export Audit Log workflow (UC-41). |
| Exceptions: | E1: Audit logs empty
At Step 2: 0 records found.
• System displays: "No audit logs found matching filter criteria." | E1: Audit logs empty
At Step 2: 0 records found.
• System displays: "No audit logs found matching filter criteria." | E1: Audit logs empty
At Step 2: 0 records found.
• System displays: "No audit logs found matching filter criteria." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-32, BR-33, BR-34 | • BR-32, BR-33, BR-34 | • BR-32, BR-33, BR-34 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-41: Export Audit Log | UC-41: Export Audit Log | UC-41: Export Audit Log |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | SysQuản trị viên (Admin) | Secondary Actors: | None |
| Trigger: | Admin exports audit log records to Excel. | Admin exports audit log records to Excel. | Admin exports audit log records to Excel. |
| Description: | Admin downloads security and action audit log history as Excel file. | Admin downloads security and action audit log history as Excel file. | Admin downloads security and action audit log history as Excel file. |
| Preconditions: | • Admin is logged in. | • Admin is logged in. | • Admin is logged in. |
| Postconditions: | • Excel file generated and downloaded. | • Excel file generated and downloaded. | • Excel file generated and downloaded. |
| Normal Flow: | 1. Admin is on Audit Logs page (UC-40).
2. Admin applies date/user filter and clicks [Xuất Audit Log Excel]. (A1)
3. System queries AuditLogs table and generates Excel file. (E1)
4. System sends file download stream to browser. | 1. Admin is on Audit Logs page (UC-40).
2. Admin applies date/user filter and clicks [Xuất Audit Log Excel]. (A1)
3. System queries AuditLogs table and generates Excel file. (E1)
4. System sends file download stream to browser. | 1. Admin is on Audit Logs page (UC-40).
2. Admin applies date/user filter and clicks [Xuất Audit Log Excel]. (A1)
3. System queries AuditLogs table and generates Excel file. (E1)
4. System sends file download stream to browser. |
| Alternative Flows: | A1: Cancel export
At Step 2, Admin cancels export.
1. Returns to audit log screen. | A1: Cancel export
At Step 2, Admin cancels export.
1. Returns to audit log screen. | A1: Cancel export
At Step 2, Admin cancels export.
1. Returns to audit log screen. |
| Exceptions: | E1: Audit logs empty
At Step 3: 0 records match filter.
• System displays: "No audit logs available for export." | E1: Audit logs empty
At Step 3: 0 records match filter.
• System displays: "No audit logs available for export." | E1: Audit logs empty
At Step 3: 0 records match filter.
• System displays: "No audit logs available for export." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-32, BR-34 | • BR-32, BR-34 | • BR-32, BR-34 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-42: Run Overdue Processor | UC-42: Run Overdue Processor | UC-42: Run Overdue Processor |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | System, SysQuản trị viên (Admin) | Secondary Actors: | None |
| Trigger: | Cron job or SysAdmin triggers overdue loan processing. | Cron job or SysAdmin triggers overdue loan processing. | Cron job or SysAdmin triggers overdue loan processing. |
| Description: | System background job identifies overdue loans, calculates daily fine amounts, and notifies users. | System background job identifies overdue loans, calculates daily fine amounts, and notifies users. | System background job identifies overdue loans, calculates daily fine amounts, and notifies users. |
| Preconditions: | • Cron scheduler active or SysAdmin manual trigger. | • Cron scheduler active or SysAdmin manual trigger. | • Cron scheduler active or SysAdmin manual trigger. |
| Postconditions: | • Overdue loans updated to 'Overdue' status, Fine records created, email notifications queued. | • Overdue loans updated to 'Overdue' status, Fine records created, email notifications queued. | • Overdue loans updated to 'Overdue' status, Fine records created, email notifications queued. |
| Normal Flow: | 1. System Cron Scheduler (or SysAdmin via manual trigger button) triggers Overdue Processor job. (A1)
2. Processor queries BorrowRecord table for active loans where NOW() > endDate AND status = 'Borrowed'. (E1)
3. For each overdue record found, Processor:
   a. Calculates overdue days = NOW() - endDate
   b. Calculates fine amount = overdue days * fineRatePerDay from SystemConfigurations
   c. Inserts / Updates Fine record in Fine table linked to BorrowRecord and userId
   d. Updates BorrowRecord status to 'Overdue'
   e. Creates Notification for user ("Sách của bạn đã quá hạn mượn")
   f. Triggers EmailService async notification to user email
4. Processor records execution summary in AuditLogs and system log file. | 1. System Cron Scheduler (or SysAdmin via manual trigger button) triggers Overdue Processor job. (A1)
2. Processor queries BorrowRecord table for active loans where NOW() > endDate AND status = 'Borrowed'. (E1)
3. For each overdue record found, Processor:
   a. Calculates overdue days = NOW() - endDate
   b. Calculates fine amount = overdue days * fineRatePerDay from SystemConfigurations
   c. Inserts / Updates Fine record in Fine table linked to BorrowRecord and userId
   d. Updates BorrowRecord status to 'Overdue'
   e. Creates Notification for user ("Sách của bạn đã quá hạn mượn")
   f. Triggers EmailService async notification to user email
4. Processor records execution summary in AuditLogs and system log file. | 1. System Cron Scheduler (or SysAdmin via manual trigger button) triggers Overdue Processor job. (A1)
2. Processor queries BorrowRecord table for active loans where NOW() > endDate AND status = 'Borrowed'. (E1)
3. For each overdue record found, Processor:
   a. Calculates overdue days = NOW() - endDate
   b. Calculates fine amount = overdue days * fineRatePerDay from SystemConfigurations
   c. Inserts / Updates Fine record in Fine table linked to BorrowRecord and userId
   d. Updates BorrowRecord status to 'Overdue'
   e. Creates Notification for user ("Sách của bạn đã quá hạn mượn")
   f. Triggers EmailService async notification to user email
4. Processor records execution summary in AuditLogs and system log file. |
| Alternative Flows: | A1: Manual trigger by SysAdmin
At Step 1, SysAdmin clicks [Chạy xử lý quá hạn ngay] on Admin Dashboard.
1. System executes processor synchronously and displays execution summary modal. | A1: Manual trigger by SysAdmin
At Step 1, SysAdmin clicks [Chạy xử lý quá hạn ngay] on Admin Dashboard.
1. System executes processor synchronously and displays execution summary modal. | A1: Manual trigger by SysAdmin
At Step 1, SysAdmin clicks [Chạy xử lý quá hạn ngay] on Admin Dashboard.
1. System executes processor synchronously and displays execution summary modal. |
| Exceptions: | E1: Database connection failure during cron execution
At Step 2: ConnectionPool unavailable.
• System logs error to application error log and reschedules job execution. | E1: Database connection failure during cron execution
At Step 2: ConnectionPool unavailable.
• System logs error to application error log and reschedules job execution. | E1: Database connection failure during cron execution
At Step 2: ConnectionPool unavailable.
• System logs error to application error log and reschedules job execution. |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-22, BR-35 | • BR-22, BR-35 | • BR-22, BR-35 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-43: Auto-cancel Expired Reservations | UC-43: Auto-cancel Expired Reservations | UC-43: Auto-cancel Expired Reservations |
| --- | --- | --- | --- |
| Created By: | Bao | Date Created: | 2026-06-27 |
| Primary Actor: | System, SysQuản trị viên (Admin) | Secondary Actors: | None |
| Trigger: | System automatically cancels expired reservation holds. | System automatically cancels expired reservation holds. | System automatically cancels expired reservation holds. |
| Description: | Background job cancels pending reservations when expiration date passes without reader pick-up. | Background job cancels pending reservations when expiration date passes without reader pick-up. | Background job cancels pending reservations when expiration date passes without reader pick-up. |
| Preconditions: | • System cron active. | • System cron active. | • System cron active. |
| Postconditions: | • Expired Reservation status updated to 'Expired', next queue position notified. | • Expired Reservation status updated to 'Expired', next queue position notified. | • Expired Reservation status updated to 'Expired', next queue position notified. |
| Normal Flow: | 1. System Cron Scheduler (or SysAdmin manual trigger) executes Reservation Auto-cancel job. (A1)
2. Job queries Reservation table for records where status = 'Pending' AND NOW() > expirationDate. (E1)
3. For each expired reservation found, Job:
   a. Updates Reservation status to 'Expired'
   b. Re-assigns queuePosition for remaining reservations of that book
   c. Checks next user in queue for BookCopy; if found, sends Notification to next user ("Sách đã sẵn sàng cho bạn")
4. Job records execution summary in AuditLogs. | 1. System Cron Scheduler (or SysAdmin manual trigger) executes Reservation Auto-cancel job. (A1)
2. Job queries Reservation table for records where status = 'Pending' AND NOW() > expirationDate. (E1)
3. For each expired reservation found, Job:
   a. Updates Reservation status to 'Expired'
   b. Re-assigns queuePosition for remaining reservations of that book
   c. Checks next user in queue for BookCopy; if found, sends Notification to next user ("Sách đã sẵn sàng cho bạn")
4. Job records execution summary in AuditLogs. | 1. System Cron Scheduler (or SysAdmin manual trigger) executes Reservation Auto-cancel job. (A1)
2. Job queries Reservation table for records where status = 'Pending' AND NOW() > expirationDate. (E1)
3. For each expired reservation found, Job:
   a. Updates Reservation status to 'Expired'
   b. Re-assigns queuePosition for remaining reservations of that book
   c. Checks next user in queue for BookCopy; if found, sends Notification to next user ("Sách đã sẵn sàng cho bạn")
4. Job records execution summary in AuditLogs. |
| Alternative Flows: | A1: Manual execution by SysAdmin
At Step 1, SysAdmin clicks [Quét hủy đặt giữ chỗ quá hạn].
1. Job executes and displays summary modal. | A1: Manual execution by SysAdmin
At Step 1, SysAdmin clicks [Quét hủy đặt giữ chỗ quá hạn].
1. Job executes and displays summary modal. | A1: Manual execution by SysAdmin
At Step 1, SysAdmin clicks [Quét hủy đặt giữ chỗ quá hạn].
1. Job executes and displays summary modal. |
| Exceptions: | E1: Database transaction error
At Step 2/3: Transaction error.
• System rolls back partial changes, logs error, and retries next batch. | E1: Database transaction error
At Step 2/3: Transaction error.
• System rolls back partial changes, logs error, and retries next batch. | E1: Database transaction error
At Step 2/3: Transaction error.
• System rolls back partial changes, logs error, and retries next batch. |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-20, BR-36 | • BR-20, BR-36 | • BR-20, BR-36 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-44: View Thủ thư Dashboard | UC-44: View Thủ thư Dashboard | UC-44: View Thủ thư Dashboard |
| --- | --- | --- | --- |
| Created By: | Thai | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | None |
| Trigger: | Librarian views operational dashboard. | Librarian views operational dashboard. | Librarian views operational dashboard. |
| Description: | Librarian inspects daily check-out/check-in metrics and operational shortcuts. | Librarian inspects daily check-out/check-in metrics and operational shortcuts. | Librarian inspects daily check-out/check-in metrics and operational shortcuts. |
| Preconditions: | • Librarian is logged in. | • Librarian is logged in. | • Librarian is logged in. |
| Postconditions: | • Operational dashboard rendered. | • Operational dashboard rendered. | • Operational dashboard rendered. |
| Normal Flow: | 1. Librarian logs in and navigates to Librarian Dashboard.
2. System queries BorrowRecord, BookCopy, Fine, BookCopyIncident tables. (E1)
3. System renders Dashboard view showing operational metrics and action shortcuts:
   a. Operational Metrics Cards: Today's Check-outs, Today's Check-ins, Pending Damaged Reports, Overdue Loans Count
   b. Quick Action Shortcuts: [Lập phiếu mượn], [Nhận trả sách], [Báo hỏng sách]
   c. Recent Activity Feed: Latest desk transactions
4. Librarian views dashboard or navigates to shortcut. (A1) | 1. Librarian logs in and navigates to Librarian Dashboard.
2. System queries BorrowRecord, BookCopy, Fine, BookCopyIncident tables. (E1)
3. System renders Dashboard view showing operational metrics and action shortcuts:
   a. Operational Metrics Cards: Today's Check-outs, Today's Check-ins, Pending Damaged Reports, Overdue Loans Count
   b. Quick Action Shortcuts: [Lập phiếu mượn], [Nhận trả sách], [Báo hỏng sách]
   c. Recent Activity Feed: Latest desk transactions
4. Librarian views dashboard or navigates to shortcut. (A1) | 1. Librarian logs in and navigates to Librarian Dashboard.
2. System queries BorrowRecord, BookCopy, Fine, BookCopyIncident tables. (E1)
3. System renders Dashboard view showing operational metrics and action shortcuts:
   a. Operational Metrics Cards: Today's Check-outs, Today's Check-ins, Pending Damaged Reports, Overdue Loans Count
   b. Quick Action Shortcuts: [Lập phiếu mượn], [Nhận trả sách], [Báo hỏng sách]
   c. Recent Activity Feed: Latest desk transactions
4. Librarian views dashboard or navigates to shortcut. (A1) |
| Alternative Flows: | A1: Click quick shortcut
At Step 3b/4, Librarian clicks [Lập phiếu mượn].
1. System redirects directly to Desk Check-out screen (UC-18). | A1: Click quick shortcut
At Step 3b/4, Librarian clicks [Lập phiếu mượn].
1. System redirects directly to Desk Check-out screen (UC-18). | A1: Click quick shortcut
At Step 3b/4, Librarian clicks [Lập phiếu mượn].
1. System redirects directly to Desk Check-out screen (UC-18). |
| Exceptions: | E1: Failed loading metrics
At Step 2: Database query timeout.
• System displays alert message and renders cached summary. | E1: Failed loading metrics
At Step 2: Database query timeout.
• System displays alert message and renders cached summary. | E1: Failed loading metrics
At Step 2: Database query timeout.
• System displays alert message and renders cached summary. |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-38 | • BR-38 | • BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-45: View Manager Dashboard | UC-45: View Manager Dashboard | UC-45: View Manager Dashboard |
| --- | --- | --- | --- |
| Created By: | Quyet | Date Created: | 2026-06-27 |
| Primary Actor: | Library Manager | Secondary Actors: | None |
| Trigger: | Library Manager views executive overview dashboard. | Library Manager views executive overview dashboard. | Library Manager views executive overview dashboard. |
| Description: | Manager inspects catalog metrics, monthly revenue, fine stats, and announcements. | Manager inspects catalog metrics, monthly revenue, fine stats, and announcements. | Manager inspects catalog metrics, monthly revenue, fine stats, and announcements. |
| Preconditions: | • Manager is logged in. | • Manager is logged in. | • Manager is logged in. |
| Postconditions: | • Executive dashboard rendered. | • Executive dashboard rendered. | • Executive dashboard rendered. |
| Normal Flow: | 1. Library Manager logs in and navigates to Manager Dashboard.
2. System queries Book, BorrowRecord, Fine, Payment, Notification, SystemConfigurations tables. (E1)
3. System renders Executive Overview metrics cards and shortcuts:
   a. Catalog Metrics: Total Book Titles, Total Physical Copies, Active Loans Ratio
   b. Financial Metrics: Monthly Fines Collected, Pending Revenue
   c. System Announcements Overview & Management Shortcuts
4. Manager reviews operational performance. (A1) | 1. Library Manager logs in and navigates to Manager Dashboard.
2. System queries Book, BorrowRecord, Fine, Payment, Notification, SystemConfigurations tables. (E1)
3. System renders Executive Overview metrics cards and shortcuts:
   a. Catalog Metrics: Total Book Titles, Total Physical Copies, Active Loans Ratio
   b. Financial Metrics: Monthly Fines Collected, Pending Revenue
   c. System Announcements Overview & Management Shortcuts
4. Manager reviews operational performance. (A1) | 1. Library Manager logs in and navigates to Manager Dashboard.
2. System queries Book, BorrowRecord, Fine, Payment, Notification, SystemConfigurations tables. (E1)
3. System renders Executive Overview metrics cards and shortcuts:
   a. Catalog Metrics: Total Book Titles, Total Physical Copies, Active Loans Ratio
   b. Financial Metrics: Monthly Fines Collected, Pending Revenue
   c. System Announcements Overview & Management Shortcuts
4. Manager reviews operational performance. (A1) |
| Alternative Flows: | A1: Navigate to Report Details
At Step 3/4, Manager clicks [Xem báo cáo chi tiết].
1. System redirects to System Reports page (UC-34). | A1: Navigate to Report Details
At Step 3/4, Manager clicks [Xem báo cáo chi tiết].
1. System redirects to System Reports page (UC-34). | A1: Navigate to Report Details
At Step 3/4, Manager clicks [Xem báo cáo chi tiết].
1. System redirects to System Reports page (UC-34). |
| Exceptions: | E1: Data load failure
At Step 2: Query execution failure.
• System displays error notification. | E1: Data load failure
At Step 2: Query execution failure.
• System displays error notification. | E1: Data load failure
At Step 2: Query execution failure.
• System displays error notification. |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-38 | • BR-38 | • BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-46: View Quản trị viên (Quản trị viên (Quản trị viên (Admin))) Dashboard | UC-46: View Quản trị viên (Quản trị viên (Quản trị viên (Admin))) Dashboard | UC-46: View Quản trị viên (Quản trị viên (Quản trị viên (Admin))) Dashboard |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | Admin | Secondary Actors: | None |
| Trigger: | Admin views system security and account overview dashboard. | Admin views system security and account overview dashboard. | Admin views system security and account overview dashboard. |
| Description: | Admin monitors total accounts, locked accounts, security alerts, and recent audit logs. | Admin monitors total accounts, locked accounts, security alerts, and recent audit logs. | Admin monitors total accounts, locked accounts, security alerts, and recent audit logs. |
| Preconditions: | • Admin is logged in. | • Admin is logged in. | • Admin is logged in. |
| Postconditions: | • Admin dashboard rendered. | • Admin dashboard rendered. | • Admin dashboard rendered. |
| Normal Flow: | 1. Admin logs in and navigates to SysAdmin Dashboard.
2. System queries "User", UserLockReason, AuditLogs, SystemConfigurations tables. (E1)
3. System renders Admin System Overview cards and Audit Log preview widget:
   a. User Statistics Cards: Total Accounts, Active Students, Active Lecturers, Staff Count, Locked Accounts Count
   b. Security Alert Box: Recent failed login spikes, Locked account reasons
   c. Recent Audit Logs Widget: Latest 10 C/U/D system actions
4. Admin reviews system status. (A1) | 1. Admin logs in and navigates to SysAdmin Dashboard.
2. System queries "User", UserLockReason, AuditLogs, SystemConfigurations tables. (E1)
3. System renders Admin System Overview cards and Audit Log preview widget:
   a. User Statistics Cards: Total Accounts, Active Students, Active Lecturers, Staff Count, Locked Accounts Count
   b. Security Alert Box: Recent failed login spikes, Locked account reasons
   c. Recent Audit Logs Widget: Latest 10 C/U/D system actions
4. Admin reviews system status. (A1) | 1. Admin logs in and navigates to SysAdmin Dashboard.
2. System queries "User", UserLockReason, AuditLogs, SystemConfigurations tables. (E1)
3. System renders Admin System Overview cards and Audit Log preview widget:
   a. User Statistics Cards: Total Accounts, Active Students, Active Lecturers, Staff Count, Locked Accounts Count
   b. Security Alert Box: Recent failed login spikes, Locked account reasons
   c. Recent Audit Logs Widget: Latest 10 C/U/D system actions
4. Admin reviews system status. (A1) |
| Alternative Flows: | A1: Click Audit Log details
At Step 3/4, Admin clicks [Xem tất cả Audit Logs].
1. System redirects to Audit Log Management page (UC-40). | A1: Click Audit Log details
At Step 3/4, Admin clicks [Xem tất cả Audit Logs].
1. System redirects to Audit Log Management page (UC-40). | A1: Click Audit Log details
At Step 3/4, Admin clicks [Xem tất cả Audit Logs].
1. System redirects to Audit Log Management page (UC-40). |
| Exceptions: | E1: System metric error
At Step 2: Query failure.
• System displays error message. | E1: System metric error
At Step 2: Query failure.
• System displays error message. | E1: System metric error
At Step 2: Query failure.
• System displays error message. |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-38 | • BR-38 | • BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-47: View Public Homepage | UC-47: View Public Homepage | UC-47: View Public Homepage |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | Guest | Secondary Actors: | None |
| Trigger: | Guest or User views public homepage. | Guest or User views public homepage. | Guest or User views public homepage. |
| Description: | User accesses LMS home page featuring book search hero section and announcements. | User accesses LMS home page featuring book search hero section and announcements. | User accesses LMS home page featuring book search hero section and announcements. |
| Preconditions: | • System is operational. | • System is operational. | • System is operational. |
| Postconditions: | • Public homepage rendered. | • Public homepage rendered. | • Public homepage rendered. |
| Normal Flow: | 1. Guest or User accesses LMS web application base URL.
2. System queries featured books and announcements from database. (E1)
3. System renders Public Homepage containing hero search bar, featured books carousel, and announcements.
4. User browses homepage content or performs quick book search. (A1) | 1. Guest or User accesses LMS web application base URL.
2. System queries featured books and announcements from database. (E1)
3. System renders Public Homepage containing hero search bar, featured books carousel, and announcements.
4. User browses homepage content or performs quick book search. (A1) | 1. Guest or User accesses LMS web application base URL.
2. System queries featured books and announcements from database. (E1)
3. System renders Public Homepage containing hero search bar, featured books carousel, and announcements.
4. User browses homepage content or performs quick book search. (A1) |
| Alternative Flows: | A1: Search book from Hero banner
At Step 3/4, User enters keyword in hero search bar.
1. System redirects to Search & View Books page (UC-22) with search results. | A1: Search book from Hero banner
At Step 3/4, User enters keyword in hero search bar.
1. System redirects to Search & View Books page (UC-22) with search results. | A1: Search book from Hero banner
At Step 3/4, User enters keyword in hero search bar.
1. System redirects to Search & View Books page (UC-22) with search results. |
| Exceptions: | E1: Homepage asset load error
At Step 2: Static assets or DB connection issue.
• System renders static fallback layout. | E1: Homepage asset load error
At Step 2: Static assets or DB connection issue.
• System renders static fallback layout. | E1: Homepage asset load error
At Step 2: Static assets or DB connection issue.
• System renders static fallback layout. |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-37 | • BR-37 | • BR-37 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-48: View Library Policies | UC-48: View Library Policies | UC-48: View Library Policies |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | Guest, User | Secondary Actors: | None |
| Trigger: | Guest or User inspects library rules and policies. | Guest or User inspects library rules and policies. | Guest or User inspects library rules and policies. |
| Description: | User views borrowing limits, fine rates, opening hours, and card guidelines. | User views borrowing limits, fine rates, opening hours, and card guidelines. | User views borrowing limits, fine rates, opening hours, and card guidelines. |
| Preconditions: | • System is operational. | • System is operational. | • System is operational. |
| Postconditions: | • Library policies page rendered. | • Library policies page rendered. | • Library policies page rendered. |
| Normal Flow: | 1. Guest or User clicks "Nội quy & Chính sách thư viện" from header or footer.
2. System queries Notification and SystemConfigurations tables for policy documents. (E1)
3. System displays Library Policies Page detailing loan rules, fine rates, opening hours, and card guidelines.
4. User views policy documents or downloads PDF. (A1) | 1. Guest or User clicks "Nội quy & Chính sách thư viện" from header or footer.
2. System queries Notification and SystemConfigurations tables for policy documents. (E1)
3. System displays Library Policies Page detailing loan rules, fine rates, opening hours, and card guidelines.
4. User views policy documents or downloads PDF. (A1) | 1. Guest or User clicks "Nội quy & Chính sách thư viện" from header or footer.
2. System queries Notification and SystemConfigurations tables for policy documents. (E1)
3. System displays Library Policies Page detailing loan rules, fine rates, opening hours, and card guidelines.
4. User views policy documents or downloads PDF. (A1) |
| Alternative Flows: | A1: Download policy PDF
At Step 4, User clicks [Tải nội quy PDF].
1. System initiates PDF download. | A1: Download policy PDF
At Step 4, User clicks [Tải nội quy PDF].
1. System initiates PDF download. | A1: Download policy PDF
At Step 4, User clicks [Tải nội quy PDF].
1. System initiates PDF download. |
| Exceptions: | E1: Policy document missing
At Step 2: Content unavailable.
• System displays: "Library policy content is currently being updated." | E1: Policy document missing
At Step 2: Content unavailable.
• System displays: "Library policy content is currently being updated." | E1: Policy document missing
At Step 2: Content unavailable.
• System displays: "Library policy content is currently being updated." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-37 | • BR-37 | • BR-37 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-49: View Full Borrow/Return History | UC-49: View Full Borrow/Return History | UC-49: View Full Borrow/Return History |
| --- | --- | --- | --- |
| Created By: | Bao | Date Created: | 2026-06-27 |
| Primary Actor: | Student, Lecturer | Secondary Actors: | None |
| Trigger: | User views complete historical log of all past loans and returns. | User views complete historical log of all past loans and returns. | User views complete historical log of all past loans and returns. |
| Description: | User views full lifetime history of borrowed and returned books. | User views full lifetime history of borrowed and returned books. | User views full lifetime history of borrowed and returned books. |
| Preconditions: | • User is logged in. | • User is logged in. | • User is logged in. |
| Postconditions: | • Complete borrowing history table rendered. | • Complete borrowing history table rendered. | • Complete borrowing history table rendered. |
| Normal Flow: | 1. User navigates to "My Borrowings" page and selects "Full History" tab.
2. System queries BorrowRecord table for active userId. (E1)
3. System renders complete loan history table (Title, Barcode, Borrow Date, Due Date, Returned Date, Status). (A1) | 1. User navigates to "My Borrowings" page and selects "Full History" tab.
2. System queries BorrowRecord table for active userId. (E1)
3. System renders complete loan history table (Title, Barcode, Borrow Date, Due Date, Returned Date, Status). (A1) | 1. User navigates to "My Borrowings" page and selects "Full History" tab.
2. System queries BorrowRecord table for active userId. (E1)
3. System renders complete loan history table (Title, Barcode, Borrow Date, Due Date, Returned Date, Status). (A1) |
| Alternative Flows: | A1: Export history
At Step 3, User clicks [Xuất lịch sử mượn trả].
1. System generates Excel/PDF file of user loan history. | A1: Export history
At Step 3, User clicks [Xuất lịch sử mượn trả].
1. System generates Excel/PDF file of user loan history. | A1: Export history
At Step 3, User clicks [Xuất lịch sử mượn trả].
1. System generates Excel/PDF file of user loan history. |
| Exceptions: | E1: Loan history empty
At Step 2: 0 records found.
• System displays: "You have no past borrowing history." | E1: Loan history empty
At Step 2: 0 records found.
• System displays: "You have no past borrowing history." | E1: Loan history empty
At Step 2: 0 records found.
• System displays: "You have no past borrowing history." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-19 | • BR-19 | • BR-19 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-50: Cancel Online Reservation | UC-50: Cancel Online Reservation | UC-50: Cancel Online Reservation |
| --- | --- | --- | --- |
| Created By: | Bao | Date Created: | 2026-06-27 |
| Primary Actor: | Student, Lecturer | Secondary Actors: | None |
| Trigger: | User cancels pending online reservation request. | User cancels pending online reservation request. | User cancels pending online reservation request. |
| Description: | User cancels reservation while status is still 'Pending'. | User cancels reservation while status is still 'Pending'. | User cancels reservation while status is still 'Pending'. |
| Preconditions: | • User has pending reservation and is logged in. | • User has pending reservation and is logged in. | • User has pending reservation and is logged in. |
| Postconditions: | • Reservation status updated to 'Cancelled'. | • Reservation status updated to 'Cancelled'. | • Reservation status updated to 'Cancelled'. |
| Normal Flow: | 1. User is on My Reservations page (UC-31).
2. User selects pending reservation and clicks [Hủy đặt giữ chỗ]. (E1)
3. System prompts confirmation modal: "Are you sure you want to cancel this reservation?"
4. User clicks [Xác nhận hủy]. (A1)
5. System updates Reservation status = 'Cancelled' and updates queuePosition for remaining users.
6. System displays: "Hủy đặt giữ chỗ sách thành công." | 1. User is on My Reservations page (UC-31).
2. User selects pending reservation and clicks [Hủy đặt giữ chỗ]. (E1)
3. System prompts confirmation modal: "Are you sure you want to cancel this reservation?"
4. User clicks [Xác nhận hủy]. (A1)
5. System updates Reservation status = 'Cancelled' and updates queuePosition for remaining users.
6. System displays: "Hủy đặt giữ chỗ sách thành công." | 1. User is on My Reservations page (UC-31).
2. User selects pending reservation and clicks [Hủy đặt giữ chỗ]. (E1)
3. System prompts confirmation modal: "Are you sure you want to cancel this reservation?"
4. User clicks [Xác nhận hủy]. (A1)
5. System updates Reservation status = 'Cancelled' and updates queuePosition for remaining users.
6. System displays: "Hủy đặt giữ chỗ sách thành công." |
| Alternative Flows: | A1: Dismiss cancellation
At Step 4, User clicks [Giữ nguyên đặt chỗ].
1. Reservation remains pending. | A1: Dismiss cancellation
At Step 4, User clicks [Giữ nguyên đặt chỗ].
1. Reservation remains pending. | A1: Dismiss cancellation
At Step 4, User clicks [Giữ nguyên đặt chỗ].
1. Reservation remains pending. |
| Exceptions: | E1: Reservation already fulfilled or expired
At Step 2: Status is no longer 'Pending'.
• System displays: "Reservation cannot be cancelled because it is already fulfilled or expired." | E1: Reservation already fulfilled or expired
At Step 2: Status is no longer 'Pending'.
• System displays: "Reservation cannot be cancelled because it is already fulfilled or expired." | E1: Reservation already fulfilled or expired
At Step 2: Status is no longer 'Pending'.
• System displays: "Reservation cannot be cancelled because it is already fulfilled or expired." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-20 | • BR-20 | • BR-20 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-51: Register Desk Reservation | UC-51: Register Desk Reservation | UC-51: Register Desk Reservation |
| --- | --- | --- | --- |
| Created By: | Thai | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | None |
| Trigger: | Librarian registers desk reservation hold for reader. | Librarian registers desk reservation hold for reader. | Librarian registers desk reservation hold for reader. |
| Description: | Librarian places reservation hold for reader at desk. | Librarian places reservation hold for reader at desk. | Librarian places reservation hold for reader at desk. |
| Preconditions: | • Librarian is logged in. | • Librarian is logged in. | • Librarian is logged in. |
| Postconditions: | • Reservation record created. | • Reservation record created. | • Reservation record created. |
| Normal Flow: | 1. Librarian is on Desk Circulation screen.
2. Librarian enters Reader Code and scans Book Barcode.
3. System checks user eligibility and reservation limits. (E1)
4. Librarian clicks [Đăng ký giữ chỗ tại quầy]. (A1)
5. System inserts Reservation record and assigns queuePosition.
6. System displays: "Đặt giữ chỗ sách trực tuyến thành công." | 1. Librarian is on Desk Circulation screen.
2. Librarian enters Reader Code and scans Book Barcode.
3. System checks user eligibility and reservation limits. (E1)
4. Librarian clicks [Đăng ký giữ chỗ tại quầy]. (A1)
5. System inserts Reservation record and assigns queuePosition.
6. System displays: "Đặt giữ chỗ sách trực tuyến thành công." | 1. Librarian is on Desk Circulation screen.
2. Librarian enters Reader Code and scans Book Barcode.
3. System checks user eligibility and reservation limits. (E1)
4. Librarian clicks [Đăng ký giữ chỗ tại quầy]. (A1)
5. System inserts Reservation record and assigns queuePosition.
6. System displays: "Đặt giữ chỗ sách trực tuyến thành công." |
| Alternative Flows: | A1: Cancel hold
At Step 4, Librarian clicks [Hủy].
1. Registration cancelled. | A1: Cancel hold
At Step 4, Librarian clicks [Hủy].
1. Registration cancelled. | A1: Cancel hold
At Step 4, Librarian clicks [Hủy].
1. Registration cancelled. |
| Exceptions: | E1: Reader has overdue loans
At Step 3: Overdue count > 0.
• System displays: "Reader has overdue loans. Cannot register hold." | E1: Reader has overdue loans
At Step 3: Overdue count > 0.
• System displays: "Reader has overdue loans. Cannot register hold." | E1: Reader has overdue loans
At Step 3: Overdue count > 0.
• System displays: "Reader has overdue loans. Cannot register hold." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-19, BR-21, BR-22, BR-41 | • BR-19, BR-21, BR-22, BR-41 | • BR-19, BR-21, BR-22, BR-41 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-52: View Book Import History | UC-52: View Book Import History | UC-52: View Book Import History |
| --- | --- | --- | --- |
| Created By: | Chuong | Date Created: | 2026-06-27 |
| Primary Actor: | Librarian | Secondary Actors: | None |
| Trigger: | Librarian or Manager views book import batch history and error logs. | Librarian or Manager views book import batch history and error logs. | Librarian or Manager views book import batch history and error logs. |
| Description: | User inspects history of bulk book imports and error row logs. | User inspects history of bulk book imports and error row logs. | User inspects history of bulk book imports and error row logs. |
| Preconditions: | • User is logged in. | • User is logged in. | • User is logged in. |
| Postconditions: | • Import batch history table displayed. | • Import batch history table displayed. | • Import batch history table displayed. |
| Normal Flow: | 1. Librarian or Manager navigates to "Lịch sử Import Sách" from sidebar.
2. System queries BookImportBatch and BookImportError tables. (E1)
3. System displays Import Batch History table: Batch ID, File Name, Imported By, Total Rows, Success Rows, Failed Rows, Status (Completed/Failed), Created At.
4. User clicks a batch row. (A1)
5. System opens Import Batch Detail modal showing line-by-line validation error log (Sheet Name, Row Number, Column Name, Error Message). | 1. Librarian or Manager navigates to "Lịch sử Import Sách" from sidebar.
2. System queries BookImportBatch and BookImportError tables. (E1)
3. System displays Import Batch History table: Batch ID, File Name, Imported By, Total Rows, Success Rows, Failed Rows, Status (Completed/Failed), Created At.
4. User clicks a batch row. (A1)
5. System opens Import Batch Detail modal showing line-by-line validation error log (Sheet Name, Row Number, Column Name, Error Message). | 1. Librarian or Manager navigates to "Lịch sử Import Sách" from sidebar.
2. System queries BookImportBatch and BookImportError tables. (E1)
3. System displays Import Batch History table: Batch ID, File Name, Imported By, Total Rows, Success Rows, Failed Rows, Status (Completed/Failed), Created At.
4. User clicks a batch row. (A1)
5. System opens Import Batch Detail modal showing line-by-line validation error log (Sheet Name, Row Number, Column Name, Error Message). |
| Alternative Flows: | A1: Download error log Excel
At Step 5, User clicks [Tải file lỗi Excel].
1. System generates Excel file containing error rows for correction. | A1: Download error log Excel
At Step 5, User clicks [Tải file lỗi Excel].
1. System generates Excel file containing error rows for correction. | A1: Download error log Excel
At Step 5, User clicks [Tải file lỗi Excel].
1. System generates Excel file containing error rows for correction. |
| Exceptions: | E1: Import history empty
At Step 2: Zero batch import records.
• System displays: "No book import history records found." | E1: Import history empty
At Step 2: Zero batch import records.
• System displays: "No book import history records found." | E1: Import history empty
At Step 2: Zero batch import records.
• System displays: "No book import history records found." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-38 | • BR-38 | • BR-38 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-53: Configure Payment Gateway Integration | UC-53: Configure Payment Gateway Integration | UC-53: Configure Payment Gateway Integration |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-06-27 |
| Primary Actor: | Library Manager | Secondary Actors: | None |
| Trigger: | Manager configures SePay / VNPAY API keys and webhook settings. | Manager configures SePay / VNPAY API keys and webhook settings. | Manager configures SePay / VNPAY API keys and webhook settings. |
| Description: | Manager sets client IDs, secret tokens, and webhook URLs for payment integration. | Manager sets client IDs, secret tokens, and webhook URLs for payment integration. | Manager sets client IDs, secret tokens, and webhook URLs for payment integration. |
| Preconditions: | • Manager is logged in. | • Manager is logged in. | • Manager is logged in. |
| Postconditions: | • SystemConfigurations updated securely. | • SystemConfigurations updated securely. | • SystemConfigurations updated securely. |
| Normal Flow: | 1. Library Manager accesses "Cấu hình cổng thanh toán" from sidebar.
2. System displays Payment Integration configuration form (VNPAY / SePay parameters).
3. Manager updates Client ID, Secret Key, Merchant Code, and Webhook URL fields.
4. Manager clicks [Lưu cấu hình cổng thanh toán]. (A1, E1)
5. System validates parameter inputs. (E1)
6. System updates SystemConfigurations table and logs to AuditLogs.
7. System displays: "Cập nhật cấu hình / mẫu văn bản thành công." | 1. Library Manager accesses "Cấu hình cổng thanh toán" from sidebar.
2. System displays Payment Integration configuration form (VNPAY / SePay parameters).
3. Manager updates Client ID, Secret Key, Merchant Code, and Webhook URL fields.
4. Manager clicks [Lưu cấu hình cổng thanh toán]. (A1, E1)
5. System validates parameter inputs. (E1)
6. System updates SystemConfigurations table and logs to AuditLogs.
7. System displays: "Cập nhật cấu hình / mẫu văn bản thành công." | 1. Library Manager accesses "Cấu hình cổng thanh toán" from sidebar.
2. System displays Payment Integration configuration form (VNPAY / SePay parameters).
3. Manager updates Client ID, Secret Key, Merchant Code, and Webhook URL fields.
4. Manager clicks [Lưu cấu hình cổng thanh toán]. (A1, E1)
5. System validates parameter inputs. (E1)
6. System updates SystemConfigurations table and logs to AuditLogs.
7. System displays: "Cập nhật cấu hình / mẫu văn bản thành công." |
| Alternative Flows: | A1: Test webhook connection
At Step 4, Manager clicks [Kiểm tra kết nối Webhook].
1. System dispatches test ping to webhook URL. | A1: Test webhook connection
At Step 4, Manager clicks [Kiểm tra kết nối Webhook].
1. System dispatches test ping to webhook URL. | A1: Test webhook connection
At Step 4, Manager clicks [Kiểm tra kết nối Webhook].
1. System dispatches test ping to webhook URL. |
| Exceptions: | E1: Invalid API key format
At Step 5: Key field blank or invalid format.
• System displays: "Please enter valid payment gateway credentials." | E1: Invalid API key format
At Step 5: Key field blank or invalid format.
• System displays: "Please enter valid payment gateway credentials." | E1: Invalid API key format
At Step 5: Key field blank or invalid format.
• System displays: "Please enter valid payment gateway credentials." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-53, BR-31 | • BR-53, BR-31 | • BR-53, BR-31 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-54: View Staff Performance Report | UC-54: View Staff Performance Report | UC-54: View Staff Performance Report |
| --- | --- | --- | --- |
| Created By: | Quyet | Date Created: | 2026-06-27 |
| Primary Actor: | Library Manager | Secondary Actors: | None |
| Trigger: | Manager evaluates desk clerk productivity and metrics. | Manager evaluates desk clerk productivity and metrics. | Manager evaluates desk clerk productivity and metrics. |
| Description: | Manager views check-outs, check-ins, and cash fine collections grouped by staff member. | Manager views check-outs, check-ins, and cash fine collections grouped by staff member. | Manager views check-outs, check-ins, and cash fine collections grouped by staff member. |
| Preconditions: | • Manager is logged in. | • Manager is logged in. | • Manager is logged in. |
| Postconditions: | • Staff performance metrics rendered. | • Staff performance metrics rendered. | • Staff performance metrics rendered. |
| Normal Flow: | 1. Library Manager navigates to "Báo cáo hiệu suất nhân viên" from sidebar.
2. System queries BorrowRecord, Payment, and "User" tables. (E1)
3. System displays Staff Performance Table showing: Staff ID, Full Name, Total Check-outs, Total Check-ins, Total Cash Fines Collected, Incident Reports Count.
4. Manager selects date range filter. (A1) | 1. Library Manager navigates to "Báo cáo hiệu suất nhân viên" from sidebar.
2. System queries BorrowRecord, Payment, and "User" tables. (E1)
3. System displays Staff Performance Table showing: Staff ID, Full Name, Total Check-outs, Total Check-ins, Total Cash Fines Collected, Incident Reports Count.
4. Manager selects date range filter. (A1) | 1. Library Manager navigates to "Báo cáo hiệu suất nhân viên" from sidebar.
2. System queries BorrowRecord, Payment, and "User" tables. (E1)
3. System displays Staff Performance Table showing: Staff ID, Full Name, Total Check-outs, Total Check-ins, Total Cash Fines Collected, Incident Reports Count.
4. Manager selects date range filter. (A1) |
| Alternative Flows: | A1: Filter by Date Range
At Step 4, Manager selects Start Date & End Date.
1. Table refreshes with staff performance metrics for selected period. | A1: Filter by Date Range
At Step 4, Manager selects Start Date & End Date.
1. Table refreshes with staff performance metrics for selected period. | A1: Filter by Date Range
At Step 4, Manager selects Start Date & End Date.
1. Table refreshes with staff performance metrics for selected period. |
| Exceptions: | E1: No staff activity found
At Step 2: Query returns 0 staff records.
• System displays: "Không có dữ liệu hiệu suất nhân viên cho khoảng thời gian này." | E1: No staff activity found
At Step 2: Query returns 0 staff records.
• System displays: "Không có dữ liệu hiệu suất nhân viên cho khoảng thời gian này." | E1: No staff activity found
At Step 2: Query returns 0 staff records.
• System displays: "Không có dữ liệu hiệu suất nhân viên cho khoảng thời gian này." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-52 | • BR-52 | • BR-52 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-55: Submit & Vote Book Suggestion | UC-55: Submit & Vote Book Suggestion | UC-55: Submit & Vote Book Suggestion |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-07-05 |
| Primary Actor: | Student, Lecturer | Secondary Actors: | None |
| Trigger: | Student or Lecturer submits new book suggestion or upvotes existing suggestion. | Student or Lecturer submits new book suggestion or upvotes existing suggestion. | Student or Lecturer submits new book suggestion or upvotes existing suggestion. |
| Description: | User proposes new book titles or upvotes suggestions to prioritize library acquisitions. | User proposes new book titles or upvotes suggestions to prioritize library acquisitions. | User proposes new book titles or upvotes suggestions to prioritize library acquisitions. |
| Preconditions: | • User is logged in. | • User is logged in. | • User is logged in. |
| Postconditions: | • BookSuggestion record created or upvoteCount incremented. | • BookSuggestion record created or upvoteCount incremented. | • BookSuggestion record created or upvoteCount incremented. |
| Normal Flow: | 1. Student or Lecturer navigates to "Đề xuất mua sách mới" (Book Suggestions).
2. System queries BookSuggestion and SuggestionVote tables.
3. System displays Book Suggestion Page with:
   a. List of user-submitted book suggestions ordered by upvoteCount descending
   b. Each item displays: Book Title, Author, Publisher, Reason, Upvote Count badge, Status (Pending / Approved / Purchased), Action buttons
   c. [+ Đề xuất sách mới] button
4. User clicks [+ Đề xuất sách mới].
5. System opens Modal Dialog with fields: Tên sách *, Tác giả *, Nhà xuất bản, Mã ISBN, Lý do đề xuất *.
6. User enters suggestion details and clicks [Gửi đề xuất]. (A1, E1)
7. System inserts record into BookSuggestion table (status = 'Pending', upvoteCount = 1), inserts record into SuggestionVote for current user.
8. Alternatively, for existing suggestion, User clicks [Tôi cũng cần (+1)] button. (A2, E2)
9. System creates SuggestionVote record, increments upvoteCount in BookSuggestion table by +1.
10. System logs transaction to AuditLogs, closes modal, displays: "Gửi đề xuất sách thành công", and refreshes suggestion list. | 1. Student or Lecturer navigates to "Đề xuất mua sách mới" (Book Suggestions).
2. System queries BookSuggestion and SuggestionVote tables.
3. System displays Book Suggestion Page with:
   a. List of user-submitted book suggestions ordered by upvoteCount descending
   b. Each item displays: Book Title, Author, Publisher, Reason, Upvote Count badge, Status (Pending / Approved / Purchased), Action buttons
   c. [+ Đề xuất sách mới] button
4. User clicks [+ Đề xuất sách mới].
5. System opens Modal Dialog with fields: Tên sách *, Tác giả *, Nhà xuất bản, Mã ISBN, Lý do đề xuất *.
6. User enters suggestion details and clicks [Gửi đề xuất]. (A1, E1)
7. System inserts record into BookSuggestion table (status = 'Pending', upvoteCount = 1), inserts record into SuggestionVote for current user.
8. Alternatively, for existing suggestion, User clicks [Tôi cũng cần (+1)] button. (A2, E2)
9. System creates SuggestionVote record, increments upvoteCount in BookSuggestion table by +1.
10. System logs transaction to AuditLogs, closes modal, displays: "Gửi đề xuất sách thành công", and refreshes suggestion list. | 1. Student or Lecturer navigates to "Đề xuất mua sách mới" (Book Suggestions).
2. System queries BookSuggestion and SuggestionVote tables.
3. System displays Book Suggestion Page with:
   a. List of user-submitted book suggestions ordered by upvoteCount descending
   b. Each item displays: Book Title, Author, Publisher, Reason, Upvote Count badge, Status (Pending / Approved / Purchased), Action buttons
   c. [+ Đề xuất sách mới] button
4. User clicks [+ Đề xuất sách mới].
5. System opens Modal Dialog with fields: Tên sách *, Tác giả *, Nhà xuất bản, Mã ISBN, Lý do đề xuất *.
6. User enters suggestion details and clicks [Gửi đề xuất]. (A1, E1)
7. System inserts record into BookSuggestion table (status = 'Pending', upvoteCount = 1), inserts record into SuggestionVote for current user.
8. Alternatively, for existing suggestion, User clicks [Tôi cũng cần (+1)] button. (A2, E2)
9. System creates SuggestionVote record, increments upvoteCount in BookSuggestion table by +1.
10. System logs transaction to AuditLogs, closes modal, displays: "Gửi đề xuất sách thành công", and refreshes suggestion list. |
| Alternative Flows: | A1: Cancel submission
At Step 6, User clicks [Hủy] or [×] on modal.
1. Modal closes with no suggestion saved.

A2: Cancel upvote
At Step 8, User clicks [Hủy vote].
1. System removes SuggestionVote record and decrements upvoteCount. | A1: Cancel submission
At Step 6, User clicks [Hủy] or [×] on modal.
1. Modal closes with no suggestion saved.

A2: Cancel upvote
At Step 8, User clicks [Hủy vote].
1. System removes SuggestionVote record and decrements upvoteCount. | A1: Cancel submission
At Step 6, User clicks [Hủy] or [×] on modal.
1. Modal closes with no suggestion saved.

A2: Cancel upvote
At Step 8, User clicks [Hủy vote].
1. System removes SuggestionVote record and decrements upvoteCount. |
| Exceptions: | E1: Missing mandatory suggestion fields
At Step 6: Title, Author, or Reason is empty.
• System displays: "Vui lòng nhập Tên sách, Tác giả và Lý do đề xuất."
• Modal remains open.

E2: User already voted for this suggestion
At Step 8: User already has SuggestionVote record for this suggestion.
• System displays: "Bạn đã bình chọn cho đề xuất sách này rồi." | E1: Missing mandatory suggestion fields
At Step 6: Title, Author, or Reason is empty.
• System displays: "Vui lòng nhập Tên sách, Tác giả và Lý do đề xuất."
• Modal remains open.

E2: User already voted for this suggestion
At Step 8: User already has SuggestionVote record for this suggestion.
• System displays: "Bạn đã bình chọn cho đề xuất sách này rồi." | E1: Missing mandatory suggestion fields
At Step 6: Title, Author, or Reason is empty.
• System displays: "Vui lòng nhập Tên sách, Tác giả và Lý do đề xuất."
• Modal remains open.

E2: User already voted for this suggestion
At Step 8: User already has SuggestionVote record for this suggestion.
• System displays: "Bạn đã bình chọn cho đề xuất sách này rồi." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-56, BR-57, BR-58 | • BR-56, BR-57, BR-58 | • BR-56, BR-57, BR-58 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |
| UC ID and Name: | UC-56: Manage Book Suggestion Status | UC-56: Manage Book Suggestion Status | UC-56: Manage Book Suggestion Status |
| --- | --- | --- | --- |
| Created By: | Tuan | Date Created: | 2026-07-05 |
| Primary Actor: | Librarian, Library Manager | Secondary Actors: | None |
| Trigger: | Librarian or Manager reviews and updates book suggestion statuses. | Librarian or Manager reviews and updates book suggestion statuses. | Librarian or Manager reviews and updates book suggestion statuses. |
| Description: | User reviews proposed book list ordered by upvotes and updates status (Pending, Approved, Rejected, Purchased). | User reviews proposed book list ordered by upvotes and updates status (Pending, Approved, Rejected, Purchased). | User reviews proposed book list ordered by upvotes and updates status (Pending, Approved, Rejected, Purchased). |
| Preconditions: | • User is logged in with staff role. | • User is logged in with staff role. | • User is logged in with staff role. |
| Postconditions: | • Suggestion status updated and notification sent to proposer. | • Suggestion status updated and notification sent to proposer. | • Suggestion status updated and notification sent to proposer. |
| Normal Flow: | 1. Librarian or Library Manager navigates to "Quản lý đề xuất mua sách" from sidebar.
2. System queries BookSuggestion, SuggestionVote, "User", MemberProfile tables.
3. System displays Suggestion Management Table ordered by upvoteCount descending showing: Suggestion ID, Book Title, Author, Suggested By, Upvote Count, Status Badge, Review Notes, Action dropdown.
4. User selects a suggestion row and clicks [Cập nhật trạng thái].
5. System opens Status Update Modal Dialog with:
   a. Trạng thái mới * — dropdown (Đã phê duyệt / Từ chối / Đã mua về kho / Đang chờ)
   b. Ghi chú phản hồi thủ thư — text area
   c. [Hủy] and [Lưu cập nhật] buttons
6. User selects new status, enters review notes, and clicks [Lưu cập nhật]. (A1, E1)
7. System updates status and reviewNotes in BookSuggestion table. (E1)
8. System creates Notification for submitting user ("Đề xuất mua sách của bạn đã được phê duyệt/mua về").
9. System records UPDATE_SUGGESTION_STATUS in AuditLogs, closes modal, displays: "Cập nhật trạng thái đề xuất thành công", and refreshes table. | 1. Librarian or Library Manager navigates to "Quản lý đề xuất mua sách" from sidebar.
2. System queries BookSuggestion, SuggestionVote, "User", MemberProfile tables.
3. System displays Suggestion Management Table ordered by upvoteCount descending showing: Suggestion ID, Book Title, Author, Suggested By, Upvote Count, Status Badge, Review Notes, Action dropdown.
4. User selects a suggestion row and clicks [Cập nhật trạng thái].
5. System opens Status Update Modal Dialog with:
   a. Trạng thái mới * — dropdown (Đã phê duyệt / Từ chối / Đã mua về kho / Đang chờ)
   b. Ghi chú phản hồi thủ thư — text area
   c. [Hủy] and [Lưu cập nhật] buttons
6. User selects new status, enters review notes, and clicks [Lưu cập nhật]. (A1, E1)
7. System updates status and reviewNotes in BookSuggestion table. (E1)
8. System creates Notification for submitting user ("Đề xuất mua sách của bạn đã được phê duyệt/mua về").
9. System records UPDATE_SUGGESTION_STATUS in AuditLogs, closes modal, displays: "Cập nhật trạng thái đề xuất thành công", and refreshes table. | 1. Librarian or Library Manager navigates to "Quản lý đề xuất mua sách" from sidebar.
2. System queries BookSuggestion, SuggestionVote, "User", MemberProfile tables.
3. System displays Suggestion Management Table ordered by upvoteCount descending showing: Suggestion ID, Book Title, Author, Suggested By, Upvote Count, Status Badge, Review Notes, Action dropdown.
4. User selects a suggestion row and clicks [Cập nhật trạng thái].
5. System opens Status Update Modal Dialog with:
   a. Trạng thái mới * — dropdown (Đã phê duyệt / Từ chối / Đã mua về kho / Đang chờ)
   b. Ghi chú phản hồi thủ thư — text area
   c. [Hủy] and [Lưu cập nhật] buttons
6. User selects new status, enters review notes, and clicks [Lưu cập nhật]. (A1, E1)
7. System updates status and reviewNotes in BookSuggestion table. (E1)
8. System creates Notification for submitting user ("Đề xuất mua sách của bạn đã được phê duyệt/mua về").
9. System records UPDATE_SUGGESTION_STATUS in AuditLogs, closes modal, displays: "Cập nhật trạng thái đề xuất thành công", and refreshes table. |
| Alternative Flows: | A1: Cancel status update
At Step 6, User clicks [Hủy] or [×] on modal.
1. Modal closes without updating suggestion status. | A1: Cancel status update
At Step 6, User clicks [Hủy] or [×] on modal.
1. Modal closes without updating suggestion status. | A1: Cancel status update
At Step 6, User clicks [Hủy] or [×] on modal.
1. Modal closes without updating suggestion status. |
| Exceptions: | E1: Database transaction error during update
At Step 7: Connection failure or update error.
• System rolls back transaction and displays: "Không thể cập nhật trạng thái đề xuất. Vui lòng thử lại." | E1: Database transaction error during update
At Step 7: Connection failure or update error.
• System rolls back transaction and displays: "Không thể cập nhật trạng thái đề xuất. Vui lòng thử lại." | E1: Database transaction error during update
At Step 7: Connection failure or update error.
• System rolls back transaction and displays: "Không thể cập nhật trạng thái đề xuất. Vui lòng thử lại." |
| Priority: | High | High | High |
| Frequency of Use: | Medium | Medium | Medium |
| Business Rules: | • BR-56, BR-57, BR-58 | • BR-56, BR-57, BR-58 | • BR-56, BR-57, BR-58 |
| Non-Functional Requirements: | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. | • Response time must be less than 3 seconds.
• All data transmitted must be encrypted via TLS 1.2+.
• The UI must be responsive and accessible. |