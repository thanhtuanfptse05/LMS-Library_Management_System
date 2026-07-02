# Detailed Use Case Specifications
**Project:** Library Management System (LMS)
**Version:** 1.0.0
**Date:** 2026-06-29

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
    <td colspan="3">The user wants to log in to access the system features.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">The user provides their credentials (Email and Password) to authenticate their identity and access system dashboards matching their role.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• The user is on the Login page and has an active account.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• The user is authenticated and redirected to their role-specific dashboard.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User enters their registered Email and Password.<br><br>2. User clicks the "Đăng nhập" button.<br><br>3. System validates the credentials against the database.<br><br>4. System creates a secure session and redirects the user to their dashboard.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Incorrect credentials &rarr; System displays generic error "Tài khoản hoặc mật khẩu không chính xác" (BR-03).<br><br>E5. Account locked due to 5 failed attempts &rarr; System locks account for 30 minutes (BR-01, BR-02).<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-01, BR-02, BR-03, BR-05, BR-06
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">The user logs out of the system, invalidating the current active HTTP session to protect personal information.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• The user is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• The user session is invalidated and redirected to the login page.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User clicks the "Đăng xuất" button.<br><br>2. System invalidates the current session.<br><br>3. System redirects the user to the login screen.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-39
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">The guest enters their registered email to request a system-generated 8-character random temporary password sent to their email.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• The guest is on the Forgot Password page.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• A generic success message is displayed, and a temporary password email is queued if the email is valid.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Guest inputs their Email address.<br><br>2. Guest clicks the "Gửi yêu cầu" button.<br><br>3. System displays a generic hypothetical message.<br><br>4. System generates an 8-character temporary password, updates the database, and queues the email.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Invalid email format &rarr; System shows validation error.<br><br>E5. Email not in database &rarr; System still displays the success message to prevent user enumeration (BR-04).<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-04, BR-07, BR-47
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">The user accesses the profile section to view their personal identification, contact information, and role-specific metadata.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• The user is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• System displays the user's profile details successfully.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User clicks on "Hồ sơ cá nhân" in the menu.<br><br>2. System fetches profile data from the database.<br><br>3. System renders the details on screen.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-08
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">
• The user is logged in and viewing their profile.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• The updated profile details are saved to the database.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User clicks the "Chỉnh sửa" button.<br><br>2. User modifies their Phone Number or Date of Birth.<br><br>3. User clicks "Lưu thay đổi".<br><br>4. System validates inputs and updates the database using UPSERT.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Empty mandatory fields or invalid formats &rarr; System shows validation errors.<br><br>E5. User attempts to edit system-immutable fields &rarr; System rejects the changes.<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-08, BR-15
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">User wants to update their password for security reasons.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">The user inputs their current password and provides a new secure password to replace the old one.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• The user is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Password is changed, the audit log is updated, and the user session is invalidated.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User navigates to the Change Password screen.<br><br>2. User enters Current Password, New Password, and Confirm Password.<br><br>3. User clicks "Lưu".<br><br>4. System verifies the current password and validates the new password strength.<br><br>5. System updates the password hash, records an audit log, invalidates the session, and redirects to login.<br><br>6. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Incorrect current password &rarr; System shows "Mật khẩu hiện tại không chính xác".<br><br>E5. Password does not meet security criteria &rarr; System displays password policy error (BR-09).<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-09, BR-14
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Admin wants to view all registered accounts.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin accesses the User Management module to view a paginated list of all users, filtered by role or status.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Admin is logged in and authorized.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• A list of all user accounts is displayed with pagination.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Admin navigates to the User Management screen.<br><br>2. System queries user accounts from the database.<br><br>3. System renders the list showing name, email, role, and status.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Admin filters user list by Role (Student, Lecturer, Librarian) or status (Active, Locked).
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Admin selects a user from the list to display their full profile, contact details, and account status history.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Admin is logged in and viewing the User List.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Detailed profile of the selected user is shown.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Admin clicks on "Xem chi tiết" next to a user record.<br><br>2. System fetches the user profile and role details.<br><br>3. System displays the profile details window.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. User not found &rarr; System redirects back with an error.<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Admin fills in a registration form to create a single user account (Student, Lecturer, Librarian, or Manager).</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Admin is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• A new user account is successfully saved and an audit log is created.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Admin clicks "Tạo tài khoản".<br><br>2. Admin fills in Email, Name, Role, Phone, and Code.<br><br>3. Admin clicks "Lưu".<br><br>4. System validates inputs (uniqueness of Email and Code).<br><br>5. System hashes password (= Email), saves user to database, logs the action, and shows success.<br><br>6. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Duplicate email/code &rarr; System shows "Email hoặc Mã số đã tồn tại" (BR-10).<br><br>E5. Missing mandatory fields &rarr; System prompts the admin to complete fields.<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-10, BR-12, BR-14
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">
• Admin is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Multiple user accounts are created inside a database transaction, or none if errors occur.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Admin selects a Role (e.g., Student) and uploads an Excel file.<br><br>2. System parses the spreadsheet and runs pre-validation on RAM.<br><br>3. System shows a preview page of the imported list.<br><br>4. Admin confirms the import.<br><br>5. System commits the users to the database inside a transaction, logs the batch action, and shows success.<br><br>6. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Invalid file format/size &rarr; System rejects the file.<br><br>E5. Any formatting or duplication error in the sheet &rarr; System rolls back and displays detailed error logs (BR-11, BR-13).<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-10, BR-11, BR-13, BR-14
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Admin wants to edit or lock/unlock a user account.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin updates a user's details, changes their system role, or locks/unlocks their account with a specified reason.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Admin is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• User account details are updated, and the action is audited.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Admin selects a user and clicks "Chỉnh sửa tài khoản".<br><br>2. Admin edits contact details or toggles status (Active/Locked).<br><br>3. If locking, Admin selects or enters a lock reason.<br><br>4. Admin clicks "Cập nhật".<br><br>5. System saves changes, updates UserLockReason if locked, and creates an audit log entry.<br><br>6. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Editing key identifiers fails &rarr; System prevents changes.<br><br>E5. DB transaction error &rarr; System displays failure message.<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-14
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Librarian wants to view the books and physical copies in stock.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian views a list of all book titles, search by keywords, and check status, location, and barcode details of copies.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Paginated book titles and copy inventories are displayed.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian opens Book Inventory screen.<br><br>2. System queries the book database.<br><br>3. System renders the list showing title, author, total quantity, available quantity, and physical copies.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Librarian filters books by Category or Tag, or searches by ISBN/Barcode.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Librarian wants to add or update metadata for a book title.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian adds a new book title with ISBN, author, publisher, cover image, and description, or edits existing metadata.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Book metadata is saved and synchronized with index filters.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian clicks "Thêm đầu sách".<br><br>2. Librarian enters Title, Author, ISBN, Publisher, and uploads cover image.<br><br>3. Librarian clicks "Lưu".<br><br>4. System validates ISBN uniqueness, saves metadata, and shows success.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Librarian updates metadata of an existing book.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Duplicate ISBN &rarr; System shows "ISBN đã tồn tại" (BR-16).<br><br>E5. Invalid inputs &rarr; System shows error boundaries.<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-16, BR-18
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Librarian wants to add or modify copies of a book.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian adds copies of a book by registering barcode and shelf locations, or updates copy conditions.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Physical copies are saved, and quantities on Book table are synchronized.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian navigates to Book Details &rarr; Physical Copies.<br><br>2. Librarian enters a Barcode, shelf location, and copy condition (e.g., New).<br><br>3. Librarian clicks "Thêm bản sao".<br><br>4. System validates barcode uniqueness, saves copy, updates total/available book quantities, and returns success.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Librarian edits copy location or marks copy condition.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Duplicate Barcode &rarr; System rejects with "Mã vạch đã tồn tại" (BR-16).<br><br>E5. Core fields modification blocked &rarr; System rejects immutable updates (BR-18).<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-16, BR-17, BR-18
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Librarian wants to add or update categorization metrics.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian creates, updates, or deactivates Categories and classification Tags applied to books.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Categories/Tags are saved in system taxonomy.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian opens Categories/Tags screen.<br><br>2. Librarian enters a Category Name and Description.<br><br>3. Librarian clicks "Lưu".<br><br>4. System saves taxonomy parameters.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Librarian toggles status of tags or categories to "inactive".
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Duplicate category/tag name &rarr; System displays duplicate error.<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Reader wants to reserve a book online.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Readers reserve books. If available, they get queuePosition 0 (ready for pickup). If unavailable, they enter a waiting queue (position > 0).</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Reader is logged in, account is active, and they have no unpaid fines.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• A Reservation record is created and queue index is allocated.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Reader searches for a book and clicks "Đặt sách".<br><br>2. System validates reader eligibility (active, no unpaid fines).<br><br>3. System checks book copy availability.<br><br>4. System creates Reservation: if copy is available, status='readypickup', queuePosition=0; otherwise, status='pending', queuePosition > 0.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Unpaid fines exists &rarr; System blocks request (BR-19, BR-22).<br><br>E5. Limit exceeded &rarr; System blocks reservation.<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-19, BR-20, BR-22
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Reader wants to extend their book loan online.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Reader extends the due date of a book they currently borrow, provided no other users are waiting in queue.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Reader is logged in, and book is currently borrowed.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Loan due date is extended, and extension count is incremented.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Reader opens "Hàng mượn & chờ sách" and clicks "Gia hạn" next to a borrowed book.<br><br>2. System checks renewal eligibility (passed % duration, extensionCount limit, and empty queue).<br><br>3. System updates the BorrowRecord: extends due date, increments extensionCount, and saves changes.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Extension count exceeded &rarr; System rejects renewal.<br><br>E5. Book is reserved by others &rarr; System rejects renewal (BR-21).<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-19, BR-21, BR-22
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Reader comes to the desk to pick up or borrow a book.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian scans user barcode and copy barcode to issue a book. Handles both walk-ins and pre-reservations.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• BorrowRecord is saved, copy status is updated to 'borrowed'.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian scans Reader card and Book Copy barcode.<br><br>2. System checks user block reasons and limits.<br><br>3. System checks copy: if walk-in, copy must be 'available'; if pre-reserved, copy must be 'reserved' with user's active reservation.<br><br>4. System processes transaction, creates virtual reservation if walk-in, inserts BorrowRecord, updates copy status to 'borrowed', and updates book availability.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. User has unpaid fines &rarr; System blocks check-out (BR-22).<br><br>E5. Walk-in requests a book copy currently reserved &rarr; System blocks check-out (BR-23, BR-29).<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-22, BR-23, BR-29
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Reader returns a borrowed book.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian scans returned copy barcode, assesses condition, processes late fees, and allocates the book to the next person in queue.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• BorrowRecord updated with return date, copy status changed, and fine calculated.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian scans copy barcode.<br><br>2. System retrieves BorrowRecord.<br><br>3. Librarian selects book condition (e.g., Normal).<br><br>4. System updates BorrowRecord.returnedAt, checks for late fees.<br><br>5. System updates copy status: if there's a queue, status='reserved' for next queue person; else status='available'.<br><br>6. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Book returned is Damaged/Lost &rarr; System deducts total book quantity, calculates replacement fines, and locks the user synchronously (BR-24).
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Copy was not recorded as borrowed &rarr; System shows warning.<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-24, BR-35, BR-47
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Reader pays fine in cash at the counter.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian collects cash, logs payment, closes the fine, and auto-unlocks user account if all dues are cleared.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Payment recorded, Fine status updated to 'paid', UserLockReason cleared, and account unlocked if clear.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian enters reader email/code to search for unpaid fines.<br><br>2. Librarian collects cash and clicks "Duyệt thanh toán".<br><br>3. System inserts Payment record, marks Fine status as 'paid'.<br><br>4. System deletes 'unpaid' lock reason from UserLockReason.<br><br>5. System checks remaining locks: if 0, updates user status to 'active'.<br><br>6. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Error writing database &rarr; Transaction is rolled back.<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-22, BR-25
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Guest wants to log in using Google Single Sign-On.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Guest authenticates with Google SSO. System logs them in if their Google email is pre-registered by Admin.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Guest is on the Login page and has a Google account.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Guest is authenticated and redirected to their dashboard.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Guest clicks "Đăng nhập bằng Google".<br><br>2. Guest completes Google sign-in popup.<br><br>3. Google returns ID token.<br><br>4. System verifies email: if email exists, initializes session, redirects to role dashboard.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Google email not registered in system database &rarr; System blocks access and shows email not allowed (BR-26).<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-26
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">User wants to find a book in the library.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User searches for book titles, views availability statistics, and checks the shelf location of physical copies.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• User is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• System displays matching books and their catalog details.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User enters keywords in the search bar (Title, Author, ISBN).<br><br>2. System searches the books catalog.<br><br>3. System renders the list showing book details, total quantity, available quantity, and location.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. User filters results by Category or Tag.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">User wants to get personalized book suggestions from AI.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User receives a curated list of book recommendation cards suggested by Gemini based on user preferences.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• User is logged in and AI integration is configured.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• System renders AI suggested books successfully.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User navigates to Recommendation section.<br><br>2. System collects user profile and historical loan tags.<br><br>3. System sends request to Gemini API.<br><br>4. Gemini returns book categories/titles.<br><br>5. System retrieves matching catalog books and renders them.<br><br>6. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Gemini API Timeout/Error &rarr; System fallback to trending/popular books catalog.<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Could Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-37
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Manager wants to issue or edit system-wide notifications.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager drafts, edits, pins, or deletes announcements visible to library users.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Manager is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Notification saved, updated, or deleted, and rendered on dashboards.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Manager clicks "Đăng thông báo".<br><br>2. Manager enters Title, Content, Type, and checks "Ghim thông báo" if needed.<br><br>3. Manager clicks "Lưu".<br><br>4. System saves notification and clears cache.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Manager deletes or unpins an announcement.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Required fields empty &rarr; System prompts manager.<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-31, BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">User checks their notification bell or inbox.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User views list of system announcements and marks them as read.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• User is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• User is up to date, and notifications read status is updated.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User clicks the Notification bell icon.<br><br>2. System retrieves latest notifications.<br><br>3. User reads announcement.<br><br>4. System logs read event in `UserNotificationStatus`.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. User clicks "Đánh dấu tất cả đã đọc".
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Manager wants to edit automated email templates.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager modifies email subject and body content templates using predefined placeholders (e.g., `{{fullName}}`).</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Manager is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Updated templates are saved to database.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Manager opens Template Manager screen.<br><br>2. Manager selects template type (e.g., OVERDUE_NOTICE).<br><br>3. Manager edits Subject and Body Content.<br><br>4. Manager clicks "Lưu mẫu".<br><br>5. System saves templates.<br><br>6. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Invalid template placeholders &rarr; System flags validation error.<br><br>E5. Attempting to delete protected template &rarr; System blocks delete (BR-47).<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-47, BR-51
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Librarian wants to add multiple books via spreadsheet.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian uploads an Excel spreadsheet containing book and copy rows to import catalog elements.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Book catalog and inventory copies are inserted inside a database transaction.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian uploads Excel file.<br><br>2. System validates fields and barcodes on RAM.<br><br>3. System shows import preview.<br><br>4. Librarian clicks "Xác nhận nhập kho".<br><br>5. System inserts books and copies, commits transaction, and shows success.<br><br>6. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Any validation failure or duplication of ISBN/barcode &rarr; System rolls back transaction, showing Excel error details (BR-16, BR-27).<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-16, BR-17, BR-27
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">A book copy is lost, damaged, or returned in poor condition.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian records an incident regarding a book copy, updating its status to unavailable, and assessing fine parameters.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in, and target book copy exists.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Incident record is created, copy availability is updated, and fine processes trigger.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian searches for copy barcode and clicks "Báo cáo sự cố".<br><br>2. Librarian enters incident type (Damaged/Lost) and details.<br><br>3. Librarian clicks "Gửi báo cáo".<br><br>4. System logs the incident, changes copy status to unavailable, decrements availableQuantity, and calculates fines.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Copy not found &rarr; System alerts librarian.<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-24, BR-28
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Librarian conducts a regular shelf inventory audit.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian starts an inventory session, scans books on shelves, and reconciles system inventory records with physical location.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Inventory session is closed, discrepancy report is generated.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian clicks "Bắt đầu đợt kiểm kê".<br><br>2. Librarian scans copy barcodes on shelves.<br><br>3. System compares scanned locations against database targets.<br><br>4. Librarian clicks "Hoàn tất kiểm kê".<br><br>5. System logs discrepancies and creates reconciliation report.<br><br>6. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Scanning non-registered barcodes &rarr; System flags warning.<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-44
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Admin wants to backup or share user records.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin exports the paginated or filtered list of user accounts into an Excel spreadsheet.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Admin is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Excel file downloaded successfully.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Admin navigates to User Management.<br><br>2. Admin filters list (if needed) and clicks "Xuất file Excel".<br><br>3. System writes user details to spreadsheet and triggers download.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Reader wants to see their active loans and waitlists.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Readers check active borrowings, past loan history, and outstanding reservations (including waitlist positions).</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Reader is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Reader's borrowings and reservation details are displayed.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Reader opens "Hàng mượn & chờ sách" screen.<br><br>2. System queries active loans, reservation waitlist, and queues.<br><br>3. System renders records on dashboard.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Reader cancels a pending reservation (UC-50).
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-19, BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td>Library Manager, Admin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Manager/Admin wants to inspect system policies.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager/Admin views parameters such as overdue rates, maximum renewals, SMTP settings, and gateway variables.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Manager or Admin is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Configuration parameters retrieved and rendered.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User navigates to System Configurations.<br><br>2. System queries the configuration table.<br><br>3. System renders fields categorized by groups.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-31
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td>Library Manager, Admin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Manager/Admin wants to adjust system variables.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager/Admin updates key-value config records in database to adapt rules without code modifications.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Manager/Admin is logged in and authorized.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Updated configurations saved to database.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User edits target configuration values (e.g., maximum renewal limit).<br><br>2. User clicks "Lưu cấu hình".<br><br>3. System validates values against whitelisted data types (BR-40).<br><br>4. System updates values and creates an audit log entry.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Invalid data format &rarr; System displays validation error.<br><br>E5. Deleting config keys &rarr; System blocks delete (BR-30).<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-30, BR-31, BR-40
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td>Library Manager, Admin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Manager/Admin wants to analyze library activity.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager/Admin views chart widgets showing trends of borrowing rates, fines collected, and book inventory allocations.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Manager/Admin is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Chart report metrics are fetched and displayed.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User opens Reports dashboard.<br><br>2. System aggregates fine collections, inventory assets, and circulation logs.<br><br>3. System displays statistics via chart trends.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. User changes filter granularity (Day, Month, Year).
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-43, BR-44, BR-45
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td>Library Manager, Admin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Manager/Admin wants to download report archives.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager/Admin exports calculated reports data into an Excel sheet.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Manager/Admin is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Excel file downloaded.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User clicks "Xuất báo cáo thống kê".<br><br>2. System queries reporting data and compiles file.<br><br>3. File downloads.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-31, BR-43
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Guest/User wants to ask questions to AI Chatbot.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Users ask chatbot about rules, catalog information, or library procedures. System calls Gemini to reply under safety filters.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• AI Integration is configured.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• AI Chatbot response is returned and rendered.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User inputs query in Chatbot dialog.<br><br>2. System sends request to Gemini with prompt constraints.<br><br>3. Gemini returns structured answer.<br><br>4. System displays answer.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Requesting chatbot to perform checkout/renew transactions &rarr; System blocks execution (BR-37).<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Could Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-37
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">User wants to review past conversation exchanges.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User reviews previous messages in their chat thread within the current active session.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• User is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Chat session records are fetched and rendered.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User opens Chat interface.<br><br>2. System retrieves current session chat logs.<br><br>3. Chat history is rendered on screen.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Could Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-37
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">User wants to check their fine transactions.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User views a history of their fines, showing status (Paid/Unpaid), dates, and reason descriptions.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• User is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Fine logs are retrieved and rendered.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User opens Fine History screen.<br><br>2. System queries fines belonging to userId.<br><br>3. System renders paid and unpaid records.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-22, BR-35
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">User wants to settle their outstanding fine online.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">User selects a fine and scans a SePay-generated QR code. Webhook verifies payment, marks fine paid, and unlocks account.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• User is logged in and has unpaid fines.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Fine is marked paid, and UserLockReason is resolved.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User clicks "Thanh toán Online" next to an unpaid fine.<br><br>2. System fetches gateway configuration and renders dynamic QR code.<br><br>3. User scans and transfers money.<br><br>4. SePay webhook alerts system of successful transaction.<br><br>5. System verifies transaction, marks Fine status 'paid', deletes unpaid lock reason, and unlocks account.<br><br>6. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Verification checksum mismatch &rarr; Webhook rejects update.<br><br>E5. Connection errors &rarr; System retries payment checks.<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-22, BR-25, BR-53
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td>SysAdmin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Admin wants to audit user actions or system anomalies.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin views a read-only paginated list of all DB changes, filtered by actor, table name, or date.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Admin is logged in and has access rights.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Paginated log records with JSON comparative diffs are rendered.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Admin navigates to Audit Logs.<br><br>2. System fetches audit entries (20 per page).<br><br>3. Admin views details of changes (oldValues vs newValues JSON).<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Admin filters by actor, action type, or date.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-32, BR-33, BR-34
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td>SysAdmin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Admin needs to extract log logs for external analysis.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin exports the filtered database audit log trail into an Excel file.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Admin is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Excel file containing log histories downloaded successfully.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Admin clicks "Xuất dữ liệu Audit Log".<br><br>2. System compiles Excel sheet and streams it.<br><br>3. File downloaded.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-32, BR-34
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td>System, SysAdmin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Periodic schedule triggered (or Admin manual command).</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">System scans active BorrowRecord loans past due date, updates statuses, penalizes with fine rate, locks user status, and sends warnings.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• None (runs as a scheduled background job).<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Overdue records updated, fines logged, users locked, and notifications sent.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. System scans active BorrowRecords (status='borrowed') where endDate &lt; NOW().<br><br>2. System calculates late days and multiplies by fine rates.<br><br>3. System locks user account, inserting 'unpaid' lock reason.<br><br>4. System queues overdue notice emails.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Admin manually clicks "Chạy quét quá hạn" in dashboard.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-22, BR-35
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td>System, SysAdmin</td>
    <td><b>Secondary Actors:</b></td>
    <td>None</td>
  </tr>
  <tr>
    <td><b>Trigger:</b></td>
    <td colspan="3">Periodic cron schedule triggers (or Admin manual request).</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">System scans reservation records in ready-for-pickup state that exceed hold limits, cancels them, and advances waitlist queues.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• None.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Expired reservation records cancelled, and next in queue notified.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. System checks reservations where status='readypickup' and endDate &lt; NOW().<br><br>2. System updates reservation status to 'expired'.<br><br>3. System increments available quantity or assigns the book copy to the next queue position (0) in line.<br><br>4. System queues notification email.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Admin manually executes cleanup from system configuration dashboard.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-20, BR-36
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
  </tr>
</table>

---

## UC-44: View Librarian Dashboard

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-44: View Librarian Dashboard</b></td>
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
    <td colspan="3">Librarian logs in or accesses home.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian views operational metrics: outstanding counter loans, transactions completed, overdue books, and incident summaries.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Role-specific dashboard graphs are displayed.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian accesses home screen.<br><br>2. System aggregates data matching librarian role bounds.<br><br>3. System renders numbers on dashboard.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Manager logs in or opens home screen.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager views operational trends (KPIs) - fine collections progress, catalog health, notification schedules, and system alerts.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Manager is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Manager KPI summary widgets are displayed.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Manager opens home screen.<br><br>2. System collects statistics matching manager profile bounds.<br><br>3. Dashboard widgets render on screen.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
  </tr>
</table>

---

## UC-46: View Admin Dashboard

<table border="1" width="100%">
  <tr>
    <td width="20%"><b>UC ID and Name:</b></td>
    <td colspan="3"><b>UC-46: View Admin Dashboard</b></td>
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
    <td colspan="3">Admin logs in or navigates home.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Admin views system security metrics: total accounts active/locked, audit alerts, configuration logs, and database metrics.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Admin is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• System admin metrics are rendered.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Admin accesses dashboard.<br><br>2. System gathers overall network statistics.<br><br>3. Dashboard displays active indices.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Guest accesses the library domain homepage.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Guests inspect library introductions, contact points, list of latest acquisitions, and pinned announcements.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Guest has network access.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Public homepage rendered successfully.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Guest visits homepage URL.<br><br>2. System queries public information and pinned announcements.<br><br>3. System renders landing page.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-37
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">User/Guest wants to read the rules and instructions of the library.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Readers read circulation guides, penalty structures, and contact information.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• None.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Policy information documents are displayed.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. User clicks on "Nội quy thư viện".<br><br>2. System displays structured policy contents.<br><br>3. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-37
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Reader wants to see past mượn/trả records.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Readers inspect a comprehensive list of all their borrow transactions, showing borrow dates, due dates, return dates, and statuses.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Reader is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Historic borrowing logs are displayed.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Reader clicks "Lịch sử mượn trả" in dashboard.<br><br>2. System fetches all records in BorrowRecord for userId.<br><br>3. System displays history page.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">High</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-19
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Reader decides they no longer need a reserved book copy.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Reader actively cancels their reservation, whether pending in queue or ready for pickup.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Reader is logged in and has an active reservation.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Reservation is cancelled, copy is released or next user in queue gets ready.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Reader opens active reservation list.<br><br>2. Reader clicks "Hủy đặt sách" next to a record.<br><br>3. System updates Reservation status to 'cancelled'.<br><br>4. System recalculates queue indices and promotes next in queue if applicable.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Reservation is already cancelled or picked up &rarr; System shows error.<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Must Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-20
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Reader requests desk reservation because they don't have internet access.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian creates a book reservation at the desk on behalf of the reader, complying with standard system policies.</td>
  </tr>
  <tr>
    <td rowspan="1"><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• A reservation is successfully registered under the reader's account.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian inputs Reader Code and scans/enters Book ISBN.<br><br>2. System validates reader eligibility (active, no unpaid fines).<br><br>3. System checks copy availability and registers reservation.<br><br>4. System outputs reservation ID and queue number.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. User has unpaid fines &rarr; System blocks counter reservation (BR-41, BR-22).<br><br>E5. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Medium</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-19, BR-21, BR-22, BR-41
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Librarian wants to audit Excel upload events.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Librarian inspects the history of import files, tracking successful/failed rows and inspecting error logs.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Librarian is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Book import batch logs are rendered.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Librarian navigates to "Lịch sử nhập sách".<br><br>2. System queries import batches from DB.<br><br>3. System displays batch files, total rows, success count, and failure count.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Librarian clicks a batch to view row-by-row import errors.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-38
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Manager wants to setup or adjust SePay API variables.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager configures client ID, webhook URLs, and parameters prefixed with `SEPAY_` for online payments.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Manager is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• SePay configurations updated securely.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Manager opens Gateway Configuration.<br><br>2. Manager enters API key, secret, and webhook endpoints.<br><br>3. Manager clicks "Lưu thiết lập".<br><br>4. System validates keys, updates the system configurations, and logs audit logs.<br><br>5. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A (User cancels operation):</b><br><br>A1. At any step before submission, user clicks "Cancel".<br><br>A2. System discards any unsaved changes and returns to the previous screen.<br><br>A3. Use case ends.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Non-authorized access &rarr; System rejects updates.<br><br>E5. Wrong keys format &rarr; System flags formatting errors.<br><br>E6. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-53, BR-31
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
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
    <td colspan="3">Manager wants to evaluate desk clerk productivity.</td>
  </tr>
  <tr>
    <td><b>Description:</b></td>
    <td colspan="3">Manager views aggregations of check-outs, check-ins, and fines collected by each librarian account.</td>
  </tr>
  <tr>
    <td><b>Preconditions:</b></td>
    <td colspan="3">
• Manager is logged in.<br>• System is operational and database is accessible.
</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">
• Paginated performance metrics table rendered.<br>• System logs the transaction in AuditLogs.
</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
1. Manager opens Staff Performance tab.<br><br>2. System aggregates desk transaction stats filtering by Librarian role.<br><br>3. System renders metrics showing librarian code, checkout counts, check-in counts, and cash collections.<br><br>4. Use case ends successfully.
</td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">
<b>Alternative Flow A:</b><br><br>A1. Manager filters logs by Month/Year.
</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
<b>Exception Flow:</b><br><br>E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.<br><br>E2. System logs the error in AuditLogs and rolls back any partial data.<br><br>E3. User is advised to retry or contact Administrator.<br><br>E4. Use case ends abnormally.
</td>
  </tr>
  <tr>
    <td><b>Priority:</b></td>
    <td colspan="3">Should Have</td>
  </tr>
  <tr>
    <td><b>Frequency of Use:</b></td>
    <td colspan="3">Low</td>
  </tr>
  <tr>
    <td><b>Business Rules:</b></td>
    <td colspan="3">
• BR-52
</td>
  </tr>
  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
  </tr>
</table>
