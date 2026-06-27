package f14;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MockJdbc {

    public static Connection createMockConnection(final Map<String, List<Map<String, Object>>> sqlQueries) {
        return (Connection) Proxy.newProxyInstance(
            Connection.class.getClassLoader(),
            new Class[] { Connection.class },
            new InvocationHandler() {
                @Override
                public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                    String methodName = method.getName();
                    if ("prepareStatement".equals(methodName)) {
                        String sql = (String) args[0];
                        return createMockPreparedStatement(sql, sqlQueries);
                    }
                    if ("createStatement".equals(methodName)) {
                        return createMockPreparedStatement("", sqlQueries);
                    }
                    if ("setAutoCommit".equals(methodName) || "commit".equals(methodName) || "rollback".equals(methodName) || "close".equals(methodName) || "isClosed".equals(methodName)) {
                        return null;
                    }
                    return null;
                }
            }
        );
    }

    private static PreparedStatement createMockPreparedStatement(final String sql, final Map<String, List<Map<String, Object>>> sqlQueries) {
        return (PreparedStatement) Proxy.newProxyInstance(
            PreparedStatement.class.getClassLoader(),
            new Class[] { PreparedStatement.class },
            new InvocationHandler() {
                private final List<Object> params = new ArrayList<>();
                @Override
                public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                    String methodName = method.getName();
                    if (methodName.startsWith("set") && args != null && args.length >= 2) {
                        int index = (Integer) args[0];
                        Object val = args[1];
                        while (params.size() < index) {
                            params.add(null);
                        }
                        params.set(index - 1, val);
                        return null;
                    }
                    if ("executeQuery".equals(methodName)) {
                        List<Map<String, Object>> rows = findMatchingRows(sql, sqlQueries);
                        return createMockResultSet(rows);
                    }
                    if ("execute".equals(methodName)) {
                        return false;
                    }
                    if ("executeUpdate".equals(methodName)) {
                        return 1;
                    }
                    if ("getGeneratedKeys".equals(methodName)) {
                        List<Map<String, Object>> rows = new ArrayList<>();
                        Map<String, Object> row = new HashMap<>();
                        row.put("1", 123);
                        rows.add(row);
                        return createMockResultSet(rows);
                    }
                    if ("close".equals(methodName)) {
                        return null;
                    }
                    return null;
                }
            }
        );
    }

    private static List<Map<String, Object>> findMatchingRows(String sql, Map<String, List<Map<String, Object>>> sqlQueries) {
        if (sqlQueries == null) return new ArrayList<>();
        List<String> sortedKeys = new ArrayList<>(sqlQueries.keySet());
        sortedKeys.sort((a, b) -> Integer.compare(b.length(), a.length()));
        for (String key : sortedKeys) {
            if (sql.toLowerCase().contains(key.toLowerCase())) {
                return sqlQueries.get(key);
            }
        }
        return new ArrayList<>();
    }

    private static ResultSet createMockResultSet(final List<Map<String, Object>> rows) {
        return (ResultSet) Proxy.newProxyInstance(
            ResultSet.class.getClassLoader(),
            new Class[] { ResultSet.class },
            new InvocationHandler() {
                private int cursor = -1;
                @Override
                public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                    String methodName = method.getName();
                    if ("next".equals(methodName)) {
                        cursor++;
                        return cursor < rows.size();
                    }
                    if ("getString".equals(methodName)) {
                        Object col = args[0];
                        Map<String, Object> current = rows.get(cursor);
                        if (col instanceof Integer) {
                            return String.valueOf(current.values().toArray()[(Integer) col - 1]);
                        } else {
                            return (String) current.get(col);
                        }
                    }
                    if ("getInt".equals(methodName)) {
                        Object col = args[0];
                        Map<String, Object> current = rows.get(cursor);
                        Object val = null;
                        if (col instanceof Integer) {
                            val = current.values().toArray()[(Integer) col - 1];
                        } else {
                            val = current.get(col);
                        }
                        if (val instanceof Number) {
                            return ((Number) val).intValue();
                        }
                        return val == null ? 0 : Integer.parseInt(val.toString());
                    }
                    if ("getLong".equals(methodName)) {
                        Object col = args[0];
                        Map<String, Object> current = rows.get(cursor);
                        Object val = null;
                        if (col instanceof Integer) {
                            val = current.values().toArray()[(Integer) col - 1];
                        } else {
                            val = current.get(col);
                        }
                        if (val instanceof Number) {
                            return ((Number) val).longValue();
                        }
                        return val == null ? 0L : Long.parseLong(val.toString());
                    }
                    if ("getDouble".equals(methodName)) {
                        Object col = args[0];
                        Map<String, Object> current = rows.get(cursor);
                        Object val = null;
                        if (col instanceof Integer) {
                            val = current.values().toArray()[(Integer) col - 1];
                        } else {
                            val = current.get(col);
                        }
                        if (val instanceof Number) {
                            return ((Number) val).doubleValue();
                        }
                        return val == null ? 0.0 : Double.parseDouble(val.toString());
                    }
                    if ("getBigDecimal".equals(methodName)) {
                        Object col = args[0];
                        Map<String, Object> current = rows.get(cursor);
                        Object val = null;
                        if (col instanceof Integer) {
                            val = current.values().toArray()[(Integer) col - 1];
                        } else {
                            val = current.get(col);
                        }
                        if (val == null) return null;
                        return new java.math.BigDecimal(val.toString());
                    }
                    if ("getObject".equals(methodName)) {
                        Object col = args[0];
                        Map<String, Object> current = rows.get(cursor);
                        if (col instanceof Integer) {
                            return current.values().toArray()[(Integer) col - 1];
                        }
                        return current.get(col);
                    }
                    if ("getTimestamp".equals(methodName)) {
                        Object col = args[0];
                        Map<String, Object> current = rows.get(cursor);
                        Object val = null;
                        if (col instanceof Integer) {
                            val = current.values().toArray()[(Integer) col - 1];
                        } else {
                            val = current.get(col);
                        }
                        if (val instanceof java.sql.Timestamp) {
                            return val;
                        }
                        return null;
                    }
                    if ("wasNull".equals(methodName)) {
                        return false;
                    }
                    if ("close".equals(methodName)) {
                        return null;
                    }
                    return null;
                }
            }
        );
    }
}
