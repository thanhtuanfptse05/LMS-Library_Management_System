package filter;

import jakarta.servlet.http.HttpServletRequest;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class AuthFilterBookManagementRouteTest {

    @Test
    public void legacyGetRedirectsToCanonicalAndKeepsQuery() throws Exception {
        AuthFilter filter = new AuthFilter();
        HttpServletRequest request = request("GET", "q=java&page=2");

        assertTrue(shouldRedirectLegacy(filter, request));
        assertEquals("/app/librarian/book-management/titles?q=java&page=2",
                buildRedirect(filter, request, "/app", "/book-management/titles", true));
    }

    @Test
    public void legacyPostDoesNotRedirectToAvoidLosingBody() throws Exception {
        AuthFilter filter = new AuthFilter();

        assertFalse(shouldRedirectLegacy(filter, request("POST", null)));
    }

    @Test
    public void legacyRootRedirectsToOverview() throws Exception {
        AuthFilter filter = new AuthFilter();
        HttpServletRequest request = request("GET", null);

        assertEquals("/app/librarian/book-management/overview",
                buildRedirect(filter, request, "/app", "/book-management", true));
    }

    @Test
    public void canonicalRootRedirectsToOverview() throws Exception {
        AuthFilter filter = new AuthFilter();
        HttpServletRequest request = request("GET", "tab=summary");

        assertEquals("/app/librarian/book-management/overview?tab=summary",
                buildRedirect(filter, request, "/app", "/librarian/book-management", false));
    }

    private static boolean shouldRedirectLegacy(AuthFilter filter, HttpServletRequest request) throws Exception {
        Method method = AuthFilter.class.getDeclaredMethod(
                "shouldRedirectLegacyBookManagementRoute", HttpServletRequest.class);
        method.setAccessible(true);
        return (Boolean) method.invoke(filter, request);
    }

    private static String buildRedirect(AuthFilter filter, HttpServletRequest request, String contextPath,
            String path, boolean legacyRoute) throws Exception {
        Method method = AuthFilter.class.getDeclaredMethod(
                "buildBookManagementRedirectUrl", HttpServletRequest.class, String.class, String.class, boolean.class);
        method.setAccessible(true);
        return (String) method.invoke(filter, request, contextPath, path, legacyRoute);
    }

    private static HttpServletRequest request(String httpMethod, String queryString) {
        InvocationHandler handler = (proxy, method, args) -> {
            switch (method.getName()) {
                case "getMethod":
                    return httpMethod;
                case "getQueryString":
                    return queryString;
                case "toString":
                    return "AuthFilterBookManagementRouteTestRequest";
                case "hashCode":
                    return System.identityHashCode(proxy);
                case "equals":
                    return proxy == args[0];
                default:
                    return null;
            }
        };
        return (HttpServletRequest) Proxy.newProxyInstance(
                AuthFilterBookManagementRouteTest.class.getClassLoader(),
                new Class<?>[]{HttpServletRequest.class},
                handler);
    }
}
