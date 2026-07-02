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
    <td colspan="3">The user is on the Login page and has an active account.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">The user is authenticated and redirected to their role-specific dashboard.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User enters their registered Email and Password.<br>
      2. User clicks the "Đăng nhập" button.<br>
      3. System validates the credentials against the database.<br>
      4. System creates a secure session and redirects the user to their dashboard.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Incorrect credentials &rarr; System displays generic error "Tài khoản hoặc mật khẩu không chính xác" (BR-03).<br>
      - Account locked due to 5 failed attempts &rarr; System locks account for 30 minutes (BR-01, BR-02).
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
    <td colspan="3">BR-01, BR-02, BR-03, BR-05, BR-06</td>
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
    <td colspan="3">The user is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">The user session is invalidated and redirected to the login page.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User clicks the "Đăng xuất" button.<br>
      2. System invalidates the current session.<br>
      3. System redirects the user to the login screen.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-39</td>
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
    <td colspan="3">The guest is on the Forgot Password page.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">A generic success message is displayed, and a temporary password email is queued if the email is valid.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Guest inputs their Email address.<br>
      2. Guest clicks the "Gửi yêu cầu" button.<br>
      3. System displays a generic hypothetical message.<br>
      4. System generates an 8-character temporary password, updates the database, and queues the email.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Invalid email format &rarr; System shows validation error.<br>
      - Email not in database &rarr; System still displays the success message to prevent user enumeration (BR-04).
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
    <td colspan="3">BR-04, BR-07, BR-47</td>
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
    <td colspan="3">The user is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">System displays the user's profile details successfully.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User clicks on "Hồ sơ cá nhân" in the menu.<br>
      2. System fetches profile data from the database.<br>
      3. System renders the details on screen.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-08</td>
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
    <td colspan="3">The user is logged in and viewing their profile.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">The updated profile details are saved to the database.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User clicks the "Chỉnh sửa" button.<br>
      2. User modifies their Phone Number or Date of Birth.<br>
      3. User clicks "Lưu thay đổi".<br>
      4. System validates inputs and updates the database using UPSERT.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Empty mandatory fields or invalid formats &rarr; System shows validation errors.<br>
      - User attempts to edit system-immutable fields &rarr; System rejects the changes.
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
    <td colspan="3">BR-08, BR-15</td>
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
    <td colspan="3">The user is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Password is changed, the audit log is updated, and the user session is invalidated.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User navigates to the Change Password screen.<br>
      2. User enters Current Password, New Password, and Confirm Password.<br>
      3. User clicks "Lưu".<br>
      4. System verifies the current password and validates the new password strength.<br>
      5. System updates the password hash, records an audit log, invalidates the session, and redirects to login.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Incorrect current password &rarr; System shows "Mật khẩu hiện tại không chính xác".<br>
      - Password does not meet security criteria &rarr; System displays password policy error (BR-09).
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
    <td colspan="3">BR-09, BR-14</td>
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
    <td colspan="3">Admin is logged in and authorized.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">A list of all user accounts is displayed with pagination.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Admin navigates to the User Management screen.<br>
      2. System queries user accounts from the database.<br>
      3. System renders the list showing name, email, role, and status.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Admin filters user list by Role (Student, Lecturer, Librarian) or status (Active, Locked).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-38</td>
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
    <td width="30%">Admin</td>
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
    <td colspan="3">Admin is logged in and viewing the User List.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Detailed profile of the selected user is shown.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Admin clicks on "Xem chi tiết" next to a user record.<br>
      2. System fetches the user profile and role details.<br>
      3. System displays the profile details window.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - User not found &rarr; System redirects back with an error.
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
    <td colspan="3">BR-38</td>
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
    <td colspan="3">Admin is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">A new user account is successfully saved and an audit log is created.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Admin clicks "Tạo tài khoản".<br>
      2. Admin fills in Email, Name, Role, Phone, and Code.<br>
      3. Admin clicks "Lưu".<br>
      4. System validates inputs (uniqueness of Email and Code).<br>
      5. System hashes password (= Email), saves user to database, logs the action, and shows success.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Duplicate email/code &rarr; System shows "Email hoặc Mã số đã tồn tại" (BR-10).<br>
      - Missing mandatory fields &rarr; System prompts the admin to complete fields.
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
    <td colspan="3">BR-10, BR-12, BR-14</td>
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
    <td colspan="3">Admin is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Multiple user accounts are created inside a database transaction, or none if errors occur.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Admin selects a Role (e.g., Student) and uploads an Excel file.<br>
      2. System parses the spreadsheet and runs pre-validation on RAM.<br>
      3. System shows a preview page of the imported list.<br>
      4. Admin confirms the import.<br>
      5. System commits the users to the database inside a transaction, logs the batch action, and shows success.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Invalid file format/size &rarr; System rejects the file.<br>
      - Any formatting or duplication error in the sheet &rarr; System rolls back and displays detailed error logs (BR-11, BR-13).
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
    <td colspan="3">BR-10, BR-11, BR-13, BR-14</td>
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
    <td colspan="3">Admin is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">User account details are updated, and the action is audited.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Admin selects a user and clicks "Chỉnh sửa tài khoản".<br>
      2. Admin edits contact details or toggles status (Active/Locked).<br>
      3. If locking, Admin selects or enters a lock reason.<br>
      4. Admin clicks "Cập nhật".<br>
      5. System saves changes, updates UserLockReason if locked, and creates an audit log entry.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Editing key identifiers fails &rarr; System prevents changes.<br>
      - DB transaction error &rarr; System displays failure message.
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
    <td colspan="3">BR-14</td>
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
    <td colspan="3">Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Paginated book titles and copy inventories are displayed.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian opens Book Inventory screen.<br>
      2. System queries the book database.<br>
      3. System renders the list showing title, author, total quantity, available quantity, and physical copies.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Librarian filters books by Category or Tag, or searches by ISBN/Barcode.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-38</td>
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
    <td colspan="3">Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Book metadata is saved and synchronized with index filters.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian clicks "Thêm đầu sách".<br>
      2. Librarian enters Title, Author, ISBN, Publisher, and uploads cover image.<br>
      3. Librarian clicks "Lưu".<br>
      4. System validates ISBN uniqueness, saves metadata, and shows success.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Librarian updates metadata of an existing book.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Duplicate ISBN &rarr; System shows "ISBN đã tồn tại" (BR-16).<br>
      - Invalid inputs &rarr; System shows error boundaries.
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
    <td colspan="3">BR-16, BR-18</td>
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
    <td colspan="3">Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Physical copies are saved, and quantities on Book table are synchronized.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian navigates to Book Details &rarr; Physical Copies.<br>
      2. Librarian enters a Barcode, shelf location, and copy condition (e.g., New).<br>
      3. Librarian clicks "Thêm bản sao".<br>
      4. System validates barcode uniqueness, saves copy, updates total/available book quantities, and returns success.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Librarian edits copy location or marks copy condition.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Duplicate Barcode &rarr; System rejects with "Mã vạch đã tồn tại" (BR-16).<br>
      - Core fields modification blocked &rarr; System rejects immutable updates (BR-18).
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
    <td colspan="3">BR-16, BR-17, BR-18</td>
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
    <td colspan="3">Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Categories/Tags are saved in system taxonomy.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian opens Categories/Tags screen.<br>
      2. Librarian enters a Category Name and Description.<br>
      3. Librarian clicks "Lưu".<br>
      4. System saves taxonomy parameters.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Librarian toggles status of tags or categories to "inactive".</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Duplicate category/tag name &rarr; System displays duplicate error.
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
    <td colspan="3">BR-38</td>
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
    <td colspan="3">Reader is logged in, account is active, and they have no unpaid fines.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">A Reservation record is created and queue index is allocated.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Reader searches for a book and clicks "Đặt sách".<br>
      2. System validates reader eligibility (active, no unpaid fines).<br>
      3. System checks book copy availability.<br>
      4. System creates Reservation: if copy is available, status='readypickup', queuePosition=0; otherwise, status='pending', queuePosition > 0.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Unpaid fines exists &rarr; System blocks request (BR-19, BR-22).<br>
      - Limit exceeded &rarr; System blocks reservation.
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
    <td colspan="3">BR-19, BR-20, BR-22</td>
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
    <td colspan="3">Reader is logged in, and book is currently borrowed.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Loan due date is extended, and extension count is incremented.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Reader opens "Hàng mượn & chờ sách" and clicks "Gia hạn" next to a borrowed book.<br>
      2. System checks renewal eligibility (passed % duration, extensionCount limit, and empty queue).<br>
      3. System updates the BorrowRecord: extends due date, increments extensionCount, and saves changes.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Extension count exceeded &rarr; System rejects renewal.<br>
      - Book is reserved by others &rarr; System rejects renewal (BR-21).
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
    <td colspan="3">BR-19, BR-21, BR-22</td>
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
    <td colspan="3">Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">BorrowRecord is saved, copy status is updated to 'borrowed'.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian scans Reader card and Book Copy barcode.<br>
      2. System checks user block reasons and limits.<br>
      3. System checks copy: if walk-in, copy must be 'available'; if pre-reserved, copy must be 'reserved' with user's active reservation.<br>
      4. System processes transaction, creates virtual reservation if walk-in, inserts BorrowRecord, updates copy status to 'borrowed', and updates book availability.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - User has unpaid fines &rarr; System blocks check-out (BR-22).<br>
      - Walk-in requests a book copy currently reserved &rarr; System blocks check-out (BR-23, BR-29).
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
    <td colspan="3">BR-22, BR-23, BR-29</td>
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
    <td colspan="3">Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">BorrowRecord updated with return date, copy status changed, and fine calculated.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian scans copy barcode.<br>
      2. System retrieves BorrowRecord.<br>
      3. Librarian selects book condition (e.g., Normal).<br>
      4. System updates BorrowRecord.returnedAt, checks for late fees.<br>
      5. System updates copy status: if there's a queue, status='reserved' for next queue person; else status='available'.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Book returned is Damaged/Lost &rarr; System deducts total book quantity, calculates replacement fines, and locks the user synchronously (BR-24).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Copy was not recorded as borrowed &rarr; System shows warning.
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
    <td colspan="3">BR-24, BR-35, BR-47</td>
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
    <td colspan="3">Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Payment recorded, Fine status updated to 'paid', UserLockReason cleared, and account unlocked if clear.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian enters reader email/code to search for unpaid fines.<br>
      2. Librarian collects cash and clicks "Duyệt thanh toán".<br>
      3. System inserts Payment record, marks Fine status as 'paid'.<br>
      4. System deletes 'unpaid' lock reason from UserLockReason.<br>
      5. System checks remaining locks: if 0, updates user status to 'active'.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Error writing database &rarr; Transaction is rolled back.
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
    <td colspan="3">BR-22, BR-25</td>
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
    <td colspan="3">Guest is on the Login page and has a Google account.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Guest is authenticated and redirected to their dashboard.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Guest clicks "Đăng nhập bằng Google".<br>
      2. Guest completes Google sign-in popup.<br>
      3. Google returns ID token.<br>
      4. System verifies email: if email exists, initializes session, redirects to role dashboard.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Google email not registered in system database &rarr; System blocks access and shows email not allowed (BR-26).
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
    <td colspan="3">BR-26</td>
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
    <td colspan="3">User is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">System displays matching books and their catalog details.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User enters keywords in the search bar (Title, Author, ISBN).<br>
      2. System searches the books catalog.<br>
      3. System renders the list showing book details, total quantity, available quantity, and location.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">User filters results by Category or Tag.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-38</td>
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
    <td colspan="3">User is logged in and AI integration is configured.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">System renders AI suggested books successfully.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User navigates to Recommendation section.<br>
      2. System collects user profile and historical loan tags.<br>
      3. System sends request to Gemini API.<br>
      4. Gemini returns book categories/titles.<br>
      5. System retrieves matching catalog books and renders them.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Gemini API Timeout/Error &rarr; System fallback to trending/popular books catalog.
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
    <td colspan="3">BR-37</td>
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
    <td colspan="3">Manager is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Notification saved, updated, or deleted, and rendered on dashboards.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Manager clicks "Đăng thông báo".<br>
      2. Manager enters Title, Content, Type, and checks "Ghim thông báo" if needed.<br>
      3. Manager clicks "Lưu".<br>
      4. System saves notification and clears cache.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Manager deletes or unpins an announcement.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Required fields empty &rarr; System prompts manager.
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
    <td colspan="3">BR-31, BR-38</td>
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
    <td colspan="3">User is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">User is up to date, and notifications read status is updated.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User clicks the Notification bell icon.<br>
      2. System retrieves latest notifications.<br>
      3. User reads announcement.<br>
      4. System logs read event in `UserNotificationStatus`.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">User clicks "Đánh dấu tất cả đã đọc".</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-38</td>
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
    <td width="30%">Library Manager</td>
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
    <td colspan="3">Manager is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Updated templates are saved to database.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Manager opens Template Manager screen.<br>
      2. Manager selects template type (e.g., OVERDUE_NOTICE).<br>
      3. Manager edits Subject and Body Content.<br>
      4. Manager clicks "Lưu mẫu".<br>
      5. System saves templates.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Invalid template placeholders &rarr; System flags validation error.<br>
      - Attempting to delete protected template &rarr; System blocks delete (BR-47).
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
    <td colspan="3">BR-47, BR-51</td>
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
    <td colspan="3">Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Book catalog and inventory copies are inserted inside a database transaction.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian uploads Excel file.<br>
      2. System validates fields and barcodes on RAM.<br>
      3. System shows import preview.<br>
      4. Librarian clicks "Xác nhận nhập kho".<br>
      5. System inserts books and copies, commits transaction, and shows success.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Any validation failure or duplication of ISBN/barcode &rarr; System rolls back transaction, showing Excel error details (BR-16, BR-27).
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
    <td colspan="3">BR-16, BR-17, BR-27</td>
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
    <td width="30%">Librarian</td>
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
    <td colspan="3">Librarian is logged in, and target book copy exists.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Incident record is created, copy availability is updated, and fine processes trigger.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian searches for copy barcode and clicks "Báo cáo sự cố".<br>
      2. Librarian enters incident type (Damaged/Lost) and details.<br>
      3. Librarian clicks "Gửi báo cáo".<br>
      4. System logs the incident, changes copy status to unavailable, decrements availableQuantity, and calculates fines.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Copy not found &rarr; System alerts librarian.
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
    <td colspan="3">BR-24, BR-28</td>
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
    <td width="30%">Librarian</td>
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
    <td colspan="3">Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Inventory session is closed, discrepancy report is generated.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian clicks "Bắt đầu đợt kiểm kê".<br>
      2. Librarian scans copy barcodes on shelves.<br>
      3. System compares scanned locations against database targets.<br>
      4. Librarian clicks "Hoàn tất kiểm kê".<br>
      5. System logs discrepancies and creates reconciliation report.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Scanning non-registered barcodes &rarr; System flags warning.
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
    <td colspan="3">BR-44</td>
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
    <td colspan="3">Admin is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Excel file downloaded successfully.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Admin navigates to User Management.<br>
      2. Admin filters list (if needed) and clicks "Xuất file Excel".<br>
      3. System writes user details to spreadsheet and triggers download.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-38</td>
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
    <td colspan="3">Reader is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Reader's borrowings and reservation details are displayed.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Reader opens "Hàng mượn & chờ sách" screen.<br>
      2. System queries active loans, reservation waitlist, and queues.<br>
      3. System renders records on dashboard.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Reader cancels a pending reservation (UC-50).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-19, BR-38</td>
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
    <td colspan="3">Manager or Admin is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Configuration parameters retrieved and rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User navigates to System Configurations.<br>
      2. System queries the configuration table.<br>
      3. System renders fields categorized by groups.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-31</td>
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
    <td colspan="3">Manager/Admin is logged in and authorized.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Updated configurations saved to database.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User edits target configuration values (e.g., maximum renewal limit).<br>
      2. User clicks "Lưu cấu hình".<br>
      3. System validates values against whitelisted data types (BR-40).<br>
      4. System updates values and creates an audit log entry.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Invalid data format &rarr; System displays validation error.<br>
      - Deleting config keys &rarr; System blocks delete (BR-30).
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
    <td colspan="3">BR-30, BR-31, BR-40</td>
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
    <td colspan="3">Manager/Admin is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Chart report metrics are fetched and displayed.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User opens Reports dashboard.<br>
      2. System aggregates fine collections, inventory assets, and circulation logs.<br>
      3. System displays statistics via chart trends.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">User changes filter granularity (Day, Month, Year).</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-43, BR-44, BR-45</td>
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
    <td colspan="3">Manager/Admin is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Excel file downloaded.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User clicks "Xuất báo cáo thống kê".<br>
      2. System queries reporting data and compiles file.<br>
      3. File downloads.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-31, BR-43</td>
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
    <td colspan="3">AI Integration is configured.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">AI Chatbot response is returned and rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User inputs query in Chatbot dialog.<br>
      2. System sends request to Gemini with prompt constraints.<br>
      3. Gemini returns structured answer.<br>
      4. System displays answer.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Requesting chatbot to perform checkout/renew transactions &rarr; System blocks execution (BR-37).
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
    <td colspan="3">BR-37</td>
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
    <td colspan="3">User is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Chat session records are fetched and rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User opens Chat interface.<br>
      2. System retrieves current session chat logs.<br>
      3. Chat history is rendered on screen.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-37</td>
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
    <td colspan="3">User is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Fine logs are retrieved and rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User opens Fine History screen.<br>
      2. System queries fines belonging to userId.<br>
      3. System renders paid and unpaid records.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-22, BR-35</td>
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
    <td colspan="3">User is logged in and has unpaid fines.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Fine is marked paid, and UserLockReason is resolved.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User clicks "Thanh toán Online" next to an unpaid fine.<br>
      2. System fetches gateway configuration and renders dynamic QR code.<br>
      3. User scans and transfers money.<br>
      4. SePay webhook alerts system of successful transaction.<br>
      5. System verifies transaction, marks Fine status 'paid', deletes unpaid lock reason, and unlocks account.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Verification checksum mismatch &rarr; Webhook rejects update.<br>
      - Connection errors &rarr; System retries payment checks.
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
    <td colspan="3">BR-22, BR-25, BR-53</td>
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
    <td colspan="3">Admin is logged in and has access rights.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Paginated log records with JSON comparative diffs are rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Admin navigates to Audit Logs.<br>
      2. System fetches audit entries (20 per page).<br>
      3. Admin views details of changes (oldValues vs newValues JSON).
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Admin filters by actor, action type, or date.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-32, BR-33, BR-34</td>
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
    <td colspan="3">Admin is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Excel file containing log histories downloaded successfully.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Admin clicks "Xuất dữ liệu Audit Log".<br>
      2. System compiles Excel sheet and streams it.<br>
      3. File downloaded.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-32, BR-34</td>
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
    <td width="30%">System</td>
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
    <td colspan="3">None (runs as a scheduled background job).</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Overdue records updated, fines logged, users locked, and notifications sent.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. System scans active BorrowRecords (status='borrowed') where endDate &lt; NOW().<br>
      2. System calculates late days and multiplies by fine rates.<br>
      3. System locks user account, inserting 'unpaid' lock reason.<br>
      4. System queues overdue notice emails.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Admin manually clicks "Chạy quét quá hạn" in dashboard.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-22, BR-35</td>
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
    <td width="30%">System</td>
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
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Expired reservation records cancelled, and next in queue notified.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. System checks reservations where status='readypickup' and endDate &lt; NOW().<br>
      2. System updates reservation status to 'expired'.<br>
      3. System increments available quantity or assigns the book copy to the next queue position (0) in line.<br>
      4. System queues notification email.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Admin manually executes cleanup from system configuration dashboard.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-20, BR-36</td>
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
    <td colspan="3">Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Role-specific dashboard graphs are displayed.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian accesses home screen.<br>
      2. System aggregates data matching librarian role bounds.<br>
      3. System renders numbers on dashboard.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-38</td>
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
    <td colspan="3">Manager is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Manager KPI summary widgets are displayed.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Manager opens home screen.<br>
      2. System collects statistics matching manager profile bounds.<br>
      3. Dashboard widgets render on screen.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-38</td>
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
    <td colspan="3">Admin is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">System admin metrics are rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Admin accesses dashboard.<br>
      2. System gathers overall network statistics.<br>
      3. Dashboard displays active indices.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-38</td>
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
    <td width="30%">Guest</td>
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
    <td colspan="3">Guest has network access.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Public homepage rendered successfully.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Guest visits homepage URL.<br>
      2. System queries public information and pinned announcements.<br>
      3. System renders landing page.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-37</td>
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
    <td width="30%">Guest, User</td>
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
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Policy information documents are displayed.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. User clicks on "Nội quy thư viện".<br>
      2. System displays structured policy contents.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-37</td>
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
    <td width="30%">Student, Lecturer</td>
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
    <td colspan="3">Reader is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Historic borrowing logs are displayed.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Reader clicks "Lịch sử mượn trả" in dashboard.<br>
      2. System fetches all records in BorrowRecord for userId.<br>
      3. System displays history page.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-19</td>
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
    <td width="30%">Student, Lecturer</td>
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
    <td colspan="3">Reader is logged in and has an active reservation.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Reservation is cancelled, copy is released or next user in queue gets ready.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Reader opens active reservation list.<br>
      2. Reader clicks "Hủy đặt sách" next to a record.<br>
      3. System updates Reservation status to 'cancelled'.<br>
      4. System recalculates queue indices and promotes next in queue if applicable.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Reservation is already cancelled or picked up &rarr; System shows error.
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
    <td colspan="3">BR-20</td>
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
    <td width="30%">Librarian</td>
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
    <td colspan="3">Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">A reservation is successfully registered under the reader's account.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian inputs Reader Code and scans/enters Book ISBN.<br>
      2. System validates reader eligibility (active, no unpaid fines).<br>
      3. System checks copy availability and registers reservation.<br>
      4. System outputs reservation ID and queue number.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - User has unpaid fines &rarr; System blocks counter reservation (BR-41, BR-22).
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
    <td colspan="3">BR-19, BR-21, BR-22, BR-41</td>
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
    <td width="30%">Librarian</td>
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
    <td colspan="3">Librarian is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Book import batch logs are rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Librarian navigates to "Lịch sử nhập sách".<br>
      2. System queries import batches from DB.<br>
      3. System displays batch files, total rows, success count, and failure count.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Librarian clicks a batch to view row-by-row import errors.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-38</td>
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
    <td width="30%">Library Manager</td>
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
    <td colspan="3">Manager is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">SePay configurations updated securely.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Manager opens Gateway Configuration.<br>
      2. Manager enters API key, secret, and webhook endpoints.<br>
      3. Manager clicks "Lưu thiết lập".<br>
      4. System validates keys, updates the system configurations, and logs audit logs.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">None.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">
      - Non-authorized access &rarr; System rejects updates.<br>
      - Wrong keys format &rarr; System flags formatting errors.
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
    <td colspan="3">BR-53, BR-31</td>
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
    <td width="30%">Library Manager</td>
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
    <td colspan="3">Manager is logged in.</td>
  </tr>
  <tr>
    <td><b>Postconditions:</b></td>
    <td colspan="3">Paginated performance metrics table rendered.</td>
  </tr>
  <tr>
    <td><b>Normal Flow:</b></td>
    <td colspan="3">
      1. Manager opens Staff Performance tab.<br>
      2. System aggregates desk transaction stats filtering by Librarian role.<br>
      3. System renders metrics showing librarian code, checkout counts, check-in counts, and cash collections.
    </td>
  </tr>
  <tr>
    <td><b>Alternative Flows:</b></td>
    <td colspan="3">Manager filters logs by Month/Year.</td>
  </tr>
  <tr>
    <td><b>Exceptions:</b></td>
    <td colspan="3">None.</td>
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
    <td colspan="3">BR-52</td>
  </tr>
</table>
