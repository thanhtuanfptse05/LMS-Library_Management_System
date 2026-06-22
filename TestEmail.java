import service.EmailService;
public class TestEmail {
    public static void main(String[] args) {
        System.out.println("Starting EmailService test to caothanhtuan576@gmail.com...");
        service.EmailService.sendAsyncHtmlEmail(
            "caothanhtuan576@gmail.com",
            "LMS Notification Test",
            "<h1>Hello</h1><p>This is a test broadcast email from LMS system.</p>"
        );
        try {
            Thread.sleep(5000);
        } catch(Exception e) {}
        System.out.println("Finished test script.");
        System.exit(0);
    }
}
