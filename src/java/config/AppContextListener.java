package config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebListener
public class AppContextListener implements ServletContextListener {
    
    private static final Logger LOGGER = Logger.getLogger(AppContextListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        java.util.TimeZone.setDefault(java.util.TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        LOGGER.log(Level.INFO, "[AppListener] Application LMS Started. System TimeZone set to Asia/Ho_Chi_Minh.");
        try {
            SystemConfigCache.load(sce.getServletContext());
            LOGGER.log(Level.INFO, "[AppListener] SystemConfigCache loaded successfully.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[AppListener] Failed to load SystemConfigCache. Business defaults will be used.", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.log(Level.INFO, "[AppListener] Application LMS Stopping. Cleaning up JDBC Drivers...");
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                LOGGER.log(Level.INFO, "[AppListener] Deregistering JDBC driver: {0}", driver);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "[AppListener] Error deregistering JDBC driver", e);
            }
        }
    }
}
