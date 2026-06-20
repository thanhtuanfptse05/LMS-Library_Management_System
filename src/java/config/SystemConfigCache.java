package config;

import dao.SystemConfigDAO;
import jakarta.servlet.ServletContext;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.SystemConfiguration;
import util.DatabaseConnection;

public class SystemConfigCache {

    private static final Logger LOGGER = Logger.getLogger(SystemConfigCache.class.getName());
    private static final String CACHE_ATTR = "systemConfigCache";

    public static synchronized void load(ServletContext ctx) {
        Map<String, String> cache = new HashMap<>();
        SystemConfigDAO dao = new SystemConfigDAO();

        try (Connection conn = DatabaseConnection.getConnection()) {
            List<SystemConfiguration> configs = dao.findAll(conn);
            for (SystemConfiguration config : configs) {
                cache.put(config.getConfigKey(), config.getConfigValue());
            }
            ctx.setAttribute(CACHE_ATTR, cache);
            LOGGER.log(Level.INFO, "SystemConfigCache loaded {0} configs.", configs.size());
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to load SystemConfigCache", ex);
        }
    }

    public static void reload(ServletContext ctx) {
        load(ctx);
    }

    @SuppressWarnings("unchecked")
    private static Map<String, String> getCacheMap(ServletContext ctx) {
        Object attr = ctx.getAttribute(CACHE_ATTR);
        if (attr instanceof Map) {
            return (Map<String, String>) attr;
        }
        return new HashMap<>();
    }

    public static String get(ServletContext ctx, String key) {
        Map<String, String> cache = getCacheMap(ctx);
        return cache.get(key);
    }

    public static int getInt(ServletContext ctx, String key, int defaultValue) {
        String val = get(ctx, key);
        if (val == null || val.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Config key {0} value ''{1}'' is not a valid integer.", new Object[]{key, val});
            return defaultValue;
        }
    }

    public static double getDouble(ServletContext ctx, String key, double defaultValue) {
        String val = get(ctx, key);
        if (val == null || val.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Double.parseDouble(val.trim());
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Config key {0} value ''{1}'' is not a valid double.", new Object[]{key, val});
            return defaultValue;
        }
    }
}
