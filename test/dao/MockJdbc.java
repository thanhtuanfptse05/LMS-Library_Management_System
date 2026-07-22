package dao;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.Map;

/**
 * MockJdbc — Helper tạo đối tượng JDBC Mock offline (Connection, PreparedStatement, ResultSet)
 * để kiểm thử các lớp DAO an toàn 100% không cần CSDL thật và không ghi dơ dữ liệu.
 */
public class MockJdbc {

    public static Connection createMockConnection(final Map<String, Object> columnValues, final int affectedRows) {
        return (Connection) Proxy.newProxyInstance(
                MockJdbc.class.getClassLoader(),
                new Class<?>[]{Connection.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        String methodName = method.getName();
                        if ("prepareStatement".equals(methodName)) {
                            return createMockPreparedStatement(columnValues, affectedRows);
                        } else if ("setAutoCommit".equals(methodName) || "commit".equals(methodName) || "rollback".equals(methodName) || "close".equals(methodName)) {
                            return null;
                        } else if ("isClosed".equals(methodName)) {
                            return false;
                        }
                        return defaultValue(method.getReturnType());
                    }
                });
    }

    public static PreparedStatement createMockPreparedStatement(final Map<String, Object> columnValues, final int affectedRows) {
        return (PreparedStatement) Proxy.newProxyInstance(
                MockJdbc.class.getClassLoader(),
                new Class<?>[]{PreparedStatement.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        String methodName = method.getName();
                        if ("executeQuery".equals(methodName) || "getGeneratedKeys".equals(methodName)) {
                            Map<String, Object> generatedKeyMap = columnValues != null ? columnValues : new HashMap<String, Object>();
                            if (generatedKeyMap.isEmpty()) {
                                generatedKeyMap.put("1", 5);
                            }
                            return createMockResultSet(generatedKeyMap);
                        } else if ("executeUpdate".equals(methodName)) {
                            return affectedRows;
                        } else if ("close".equals(methodName) || methodName.startsWith("set")) {
                            return null;
                        }
                        return defaultValue(method.getReturnType());
                    }
                });
    }

    public static ResultSet createMockResultSet(final Map<String, Object> columnValues) {
        final Map<String, Object> data = columnValues != null ? columnValues : new HashMap<String, Object>();
        final boolean[] moved = new boolean[]{false};

        return (ResultSet) Proxy.newProxyInstance(
                MockJdbc.class.getClassLoader(),
                new Class<?>[]{ResultSet.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        String methodName = method.getName();
                        if ("next".equals(methodName)) {
                            if (!moved[0] && !data.isEmpty()) {
                                moved[0] = true;
                                return true;
                            }
                            return false;
                        } else if ("getString".equals(methodName)) {
                            String key = args[0] instanceof Integer ? String.valueOf(args[0]) : (String) args[0];
                            Object val = data.get(key);
                            return val != null ? val.toString() : null;
                        } else if ("getInt".equals(methodName)) {
                            String key = args[0] instanceof Integer ? String.valueOf(args[0]) : (String) args[0];
                            Object val = data.get(key);
                            return val instanceof Number ? ((Number) val).intValue() : 5;
                        } else if ("getBoolean".equals(methodName)) {
                            String key = args[0] instanceof Integer ? String.valueOf(args[0]) : (String) args[0];
                            Object val = data.get(key);
                            return Boolean.TRUE.equals(val);
                        } else if ("getMetaData".equals(methodName)) {
                            return createMockMetaData(data);
                        } else if ("close".equals(methodName)) {
                            return null;
                        }
                        return defaultValue(method.getReturnType());
                    }
                });
    }

    private static ResultSetMetaData createMockMetaData(final Map<String, Object> data) {
        return (ResultSetMetaData) Proxy.newProxyInstance(
                MockJdbc.class.getClassLoader(),
                new Class<?>[]{ResultSetMetaData.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        if ("getColumnCount".equals(method.getName())) {
                            return data.size();
                        }
                        return defaultValue(method.getReturnType());
                    }
                });
    }

    private static Object defaultValue(Class<?> type) {
        if (type == boolean.class || type == Boolean.class) return false;
        if (type == int.class || type == Integer.class) return 0;
        if (type == long.class || type == Long.class) return 0L;
        return null;
    }
}
