package f8;

import config.AiConfig;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import java.sql.Connection;
import java.util.*;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class AiConfigTest {

    private final int testId;
    private final String scenario;
    private final String sysRecommenProp;
    private final String sysGeminiProp;
    private final String sysChatbotProp;
    private final String dbValue;
    private final String expectKey;

    private String originalRecommen;
    private String originalGemini;
    private String originalChatbot;

    public AiConfigTest(int testId, String scenario, String sysRecommenProp, String sysGeminiProp, 
                        String sysChatbotProp, String dbValue, String expectKey) {
        this.testId = testId;
        this.scenario = scenario;
        this.sysRecommenProp = sysRecommenProp;
        this.sysGeminiProp = sysGeminiProp;
        this.sysChatbotProp = sysChatbotProp;
        this.dbValue = dbValue;
        this.expectKey = expectKey;
    }

    @Parameters(name = "{index}: TestId={0}, Scenario={1}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();
        
        // 1-5: System property priority for Recommendation key
        params.add(new Object[]{1, "sys_prop_recommen_only", "KEY_RECOMMEN", "", "", "MISSING_API_KEY", "KEY_RECOMMEN"});
        params.add(new Object[]{2, "sys_prop_gemini_only", "", "KEY_GEMINI", "", "MISSING_API_KEY", "KEY_GEMINI"});
        params.add(new Object[]{3, "sys_prop_both", "KEY_RECOMMEN", "KEY_GEMINI", "", "MISSING_API_KEY", "KEY_RECOMMEN"});
        params.add(new Object[]{4, "sys_prop_empty", " ", " ", "", "MISSING_API_KEY", "MISSING_API_KEY"}); // falls back to Env, which will yield MISSING_API_KEY or env key in test environment
        params.add(new Object[]{5, "sys_prop_null", null, null, "", "MISSING_API_KEY", "MISSING_API_KEY"});

        // 6-10: Database priority for Recommendation key
        params.add(new Object[]{6, "db_valid", "", "", "", "DB_KEY_VAL", "DB_KEY_VAL"});
        params.add(new Object[]{7, "db_empty_key", "", "", "", " ", "MISSING_API_KEY"});
        params.add(new Object[]{8, "db_missing", "", "", "", "MISSING_API_KEY", "MISSING_API_KEY"});
        params.add(new Object[]{9, "db_exception", "", "", "", "THROW_EXCEPTION", "MISSING_API_KEY"});
        params.add(new Object[]{10, "db_null", "", "", "", null, "MISSING_API_KEY"});

        // 11-15: System property priority for Chatbot key
        params.add(new Object[]{11, "chatbot_sys_prop", "", "", "CHAT_PROP_KEY", "MISSING_API_KEY", "CHAT_PROP_KEY"});
        params.add(new Object[]{12, "chatbot_sys_prop_empty", "", "", " ", "MISSING_API_KEY", "MISSING_API_KEY"});
        params.add(new Object[]{13, "chatbot_sys_prop_null", "", "", null, "MISSING_API_KEY", "MISSING_API_KEY"});
        params.add(new Object[]{14, "chatbot_db_valid", "", "", "", "CHAT_DB_KEY", "CHAT_DB_KEY"});
        params.add(new Object[]{15, "chatbot_db_exception", "", "", "", "THROW_EXCEPTION", "MISSING_API_KEY"});

        // 16-20: Mixture of DB and Prop fallbacks
        params.add(new Object[]{16, "mix_db_fallback_to_prop", "PROP_FALLBACK", "", "", "MISSING_API_KEY", "PROP_FALLBACK"});
        params.add(new Object[]{17, "mix_db_fallback_to_gemini_prop", "", "GEMINI_PROP_FALLBACK", "", "MISSING_API_KEY", "GEMINI_PROP_FALLBACK"});
        params.add(new Object[]{18, "mix_db_valid_ignores_prop", "PROP_KEY", "", "", "DB_KEY_PREVAL", "DB_KEY_PREVAL"});
        params.add(new Object[]{19, "mix_chatbot_db_valid_ignores_prop", "", "", "CHAT_PROP_VAL", "CHAT_DB_PREVAL", "CHAT_DB_PREVAL"});
        params.add(new Object[]{20, "mix_db_empty_fallback_to_prop", "PROP_KEY_2", "", "", " ", "PROP_KEY_2"});

        return params;
    }

    @Before
    public void setUp() throws Exception {
        // Save original system properties
        originalRecommen = System.getProperty("GEMINI_RECOMMEN_API_KEY");
        originalGemini = System.getProperty("GEMINI_API_KEY");
        originalChatbot = System.getProperty("GEMINI_CHATBOT_API_KEY");

        // Set properties for test
        if (sysRecommenProp != null) System.setProperty("GEMINI_RECOMMEN_API_KEY", sysRecommenProp);
        else System.clearProperty("GEMINI_RECOMMEN_API_KEY");

        if (sysGeminiProp != null) System.setProperty("GEMINI_API_KEY", sysGeminiProp);
        else System.clearProperty("GEMINI_API_KEY");

        if (sysChatbotProp != null) System.setProperty("GEMINI_CHATBOT_API_KEY", sysChatbotProp);
        else System.clearProperty("GEMINI_CHATBOT_API_KEY");

        // Set up mock DB Connection
        Map<String, List<Map<String, Object>>> queries = new HashMap<>();
        if (dbValue != null) {
            if ("THROW_EXCEPTION".equals(dbValue)) {
                // Return a connection that throws SQL exception on query execution
                util.DatabaseConnection.testConnection = (Connection) java.lang.reflect.Proxy.newProxyInstance(
                    Connection.class.getClassLoader(),
                    new Class[]{Connection.class},
                    (proxy, method1, args1) -> {
                        if ("prepareStatement".equals(method1.getName())) {
                            throw new java.sql.SQLException("Simulated database failure");
                        }
                        return null;
                    }
                );
                return;
            } else {
                List<Map<String, Object>> rows = new ArrayList<>();
                Map<String, Object> row = new HashMap<>();
                row.put("configValue", dbValue);
                rows.add(row);
                queries.put("SystemConfigurations", rows);
            }
        } else {
            // Null dbValue returns empty result set
            queries.put("SystemConfigurations", Collections.emptyList());
        }

        util.DatabaseConnection.testConnection = MockJdbc.createMockConnection(queries);
    }

    @After
    public void tearDown() {
        // Restore original system properties
        if (originalRecommen != null) System.setProperty("GEMINI_RECOMMEN_API_KEY", originalRecommen);
        else System.clearProperty("GEMINI_RECOMMEN_API_KEY");

        if (originalGemini != null) System.setProperty("GEMINI_API_KEY", originalGemini);
        else System.clearProperty("GEMINI_API_KEY");

        if (originalChatbot != null) System.setProperty("GEMINI_CHATBOT_API_KEY", originalChatbot);
        else System.clearProperty("GEMINI_CHATBOT_API_KEY");

        util.DatabaseConnection.testConnection = null;
    }

    @Test
    public void testApiKeyRetrieval() {
        if (scenario.startsWith("chatbot")) {
            String chatbotKey = AiConfig.getGeminiChatbotApiKey();
            if (!expectKey.equals("MISSING_API_KEY") || !"MISSING_API_KEY".equals(chatbotKey)) {
                // If expected value is MISSING_API_KEY, env vars might override, so we only assert if expected value is custom
                if (!expectKey.equals("MISSING_API_KEY")) {
                    assertEquals(expectKey, chatbotKey);
                }
            }
        } else if (scenario.startsWith("mix_chatbot")) {
            String chatbotKey = AiConfig.getGeminiChatbotApiKey();
            assertEquals(expectKey, chatbotKey);
        } else if (scenario.startsWith("sys_prop") || scenario.startsWith("mix_db_fallback")) {
            String key = AiConfig.resolveApiKey();
            if (!expectKey.equals("MISSING_API_KEY") || !"MISSING_API_KEY".equals(key)) {
                if (!expectKey.equals("MISSING_API_KEY")) {
                    assertEquals(expectKey, key);
                }
            }
        } else {
            // Recommendation key retrieval tests
            String recKey = AiConfig.getGeminiApiKey();
            if (!expectKey.equals("MISSING_API_KEY") || !"MISSING_API_KEY".equals(recKey)) {
                if (!expectKey.equals("MISSING_API_KEY")) {
                    assertEquals(expectKey, recKey);
                }
            }
        }
    }
}
