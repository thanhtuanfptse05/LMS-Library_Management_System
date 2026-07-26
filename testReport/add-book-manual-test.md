# Test thu cong module AddBook

## 1. Tom tat module

- Module: AddBook - them dau sach moi.
- Huong lam: bai tap JUnit thuan Java, khong ket noi database.
- File logic test: `test/service/AddBookExerciseService.java`.
- File JUnit: `test/service/AddBookTest.java`.
- Ham chinh: `addBook(...)`.
- So truong kiem thu: 9 truong gom `bookId`, `isbn`, `title`, `author`, `category`, `publisher`, `publishedYear`, `quantity`, `status`.
- Tong test cases: 19.
- Ket qua hien tai: 16 passed, 3 failed, 0 untested.
- Phan loai N/A/B: 1 Normal, 10 Abnormal, 8 Boundary.

## 2. Dieu kien test

- Mo project trong NetBeans.
- Project co JUnit 4.x.
- Khong can chay Tomcat.
- Khong can ket noi PostgreSQL/Supabase.
- Trong NetBeans, chon `test/service/AddBookTest.java`, click chuot phai va chon `Test File`.

## 3. Test condition, input/output

| UTC | Dieu kien test | Input chinh | Expected output | Actual hien tai | Result | Type | Defect ID |
| --- | --- | --- | --- | --- | --- | --- | --- |
| UTC01 | Them sach hop le | Tat ca truong hop le, quantity `5`, status `AVAILABLE` | `BOOK_ADDED_SUCCESSFULLY` | `BOOK_ADDED_SUCCESSFULLY` | P | N | |
| UTC02 | Ma sach khong hop le | `bookId = 0` | `INVALID_BOOK_ID` | `INVALID_BOOK_ID` | P | B | |
| UTC03 | ISBN rong sau khi trim | `isbn = "   "` | `INVALID_ISBN` | `INVALID_ISBN` | P | A | |
| UTC04 | ISBN null | `isbn = null` | `INVALID_ISBN` | `INVALID_ISBN` | P | A | |
| UTC05 | ISBN bi trung nhung khac dinh dang | `isbn = "978-0-13-468599-1"`, `existingIsbns = {"9780134685991"}` | `DUPLICATE_ISBN` | `BOOK_ADDED_SUCCESSFULLY` | F | A | DF-01 |
| UTC06 | ISBN bi trung chinh xac | `isbn = "9780134685991"`, `existingIsbns = {"9780134685991"}` | `DUPLICATE_ISBN` | `DUPLICATE_ISBN` | P | A | |
| UTC07 | Ten sach rong | `title = " "` | `INVALID_TITLE` | `INVALID_TITLE` | P | A | |
| UTC08 | Tac gia rong | `author = " "` | `INVALID_AUTHOR` | `INVALID_AUTHOR` | P | A | |
| UTC09 | The loai rong | `category = " "` | `INVALID_CATEGORY` | `INVALID_CATEGORY` | P | A | |
| UTC10 | Nha xuat ban rong | `publisher = " "` | `INVALID_PUBLISHER` | `INVALID_PUBLISHER` | P | A | |
| UTC11 | Nam xuat ban qua cu | `publishedYear = 1899` | `INVALID_YEAR` | `INVALID_YEAR` | P | B | |
| UTC12 | Nam xuat ban tai bien duoi hop le | `publishedYear = 1900` | `BOOK_ADDED_SUCCESSFULLY` | `BOOK_ADDED_SUCCESSFULLY` | P | B | |
| UTC13 | Nam xuat ban o tuong lai | `publishedYear = currentYear + 1` | `INVALID_YEAR` | `BOOK_ADDED_SUCCESSFULLY` | F | B | DF-02 |
| UTC14 | Nam xuat ban nam hien tai | `publishedYear = currentYear` | `BOOK_ADDED_SUCCESSFULLY` | `BOOK_ADDED_SUCCESSFULLY` | P | B | |
| UTC15 | So luong am | `quantity = -1` | `INVALID_QUANTITY` | `INVALID_QUANTITY` | P | B | |
| UTC16 | Trang thai sai | `status = "DELETED"` | `INVALID_STATUS` | `INVALID_STATUS` | P | A | |
| UTC17 | Trang thai rong sau khi trim | `status = " "` | `INVALID_STATUS` | `INVALID_STATUS` | P | A | |
| UTC18 | So luong bang 0 nhung status AVAILABLE | `quantity = 0`, `status = "AVAILABLE"` | `INVALID_STATUS_FOR_ZERO_QUANTITY` | `BOOK_ADDED_SUCCESSFULLY` | F | B | DF-03 |
| UTC19 | So luong bang 0 va status UNAVAILABLE | `quantity = 0`, `status = "UNAVAILABLE"` | `BOOK_ADDED_SUCCESSFULLY` | `BOOK_ADDED_SUCCESSFULLY` | P | B | |

## 4. Issues tim thay truoc khi fix

- DF-01: ISBN bi trung nhung khac dinh dang, vi nguoi dung nhap ISBN co dau gach ngang trong khi ISBN da ton tai duoc luu dang khong co dau gach ngang.
- DF-02: Nam xuat ban trong tuong lai khong bi bat loi vi code cu chi check `publishedYear < 1900`.
- DF-03: Sach co `quantity = 0` van duoc gan `AVAILABLE`, sai voi rule sach khong co so luong thi khong the san sang muon.

## 5. Cach fix

- DF-01: Normalize ISBN bang cach loai bo dau gach ngang/khoang trang truoc khi so sanh voi danh sach ISBN da ton tai.
- DF-02: Check nam xuat ban trong khoang `1900 <= publishedYear <= Year.now().getValue()`.
- DF-03: Them rule `quantity == 0 && status == "AVAILABLE"` thi tra ve `INVALID_STATUS_FOR_ZERO_QUANTITY`.
