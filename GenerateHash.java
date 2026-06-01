
import org.mindrot.jbcrypt.BCrypt;
public class GenerateHash {
    public static void main(String[] args) {
        String[] emails = {"caotuan01122005@gmail.com", "caothanhtuan576@gmail.com", "vuvanquyet0305@gmail.com"};
        for (String email : emails) {
            System.out.println(email + ": " + BCrypt.hashpw(email, BCrypt.gensalt(10)));
        }
    }
}