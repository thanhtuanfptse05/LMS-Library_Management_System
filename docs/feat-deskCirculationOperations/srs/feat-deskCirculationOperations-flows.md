# Business Flows — Desk Circulation Operations

## Flow: Quy trình Mượn Sách tại Quầy (Check-Out Flow)
**Trigger**: Độc giả mang sách tới quầy thư viện và xuất trình thẻ độc giả để làm thủ tục mượn.  
**Related UC**: UC-DCO-01 (Check-Out at Desk)  
**Related FR**: FR-F6-01, FR-F6-02, FR-F6-03  

![Quy trình Mượn Sách tại Quầy — swimlane](./feat-dco-checkout-swimlane.svg)

> **Nguồn mã PlantUML**: [`feat-dco-checkout-swimlane.puml`](./feat-dco-checkout-swimlane.puml). Khi có thay đổi về quy trình nghiệp vụ, chỉnh sửa file `.puml` và tiến hành re-render lại file `.svg`.

---

## Flow: Quy trình Nhận Sách và Xử Lý Trả tại Quầy (Check-In Flow)
**Trigger**: Độc giả mang sách đến quầy làm thủ tục trả sách.  
**Related UC**: UC-DCO-02 (Check-In at Desk)  
**Related FR**: FR-F6-04, FR-F6-05, FR-F6-06  

![Quy trình Nhận Sách và Xử Lý Trả tại Quầy — swimlane](./feat-dco-checkin-swimlane.svg)

> **Nguồn mã PlantUML**: [`feat-dco-checkin-swimlane.puml`](./feat-dco-checkin-swimlane.puml). Tuân thủ 100% quy tắc từ [`plantuml-activity-diagram-ruleset.md`](../../../plantuml-activity-diagram-ruleset.md).
