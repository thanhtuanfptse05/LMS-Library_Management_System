package config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebListener
public class AppContextListener implements ServletContextListener {
    
    private static final Logger LOGGER = Logger.getLogger(AppContextListener.class.getName());

    // Tiến trình ngầm Hủy đặt trước quá hạn (F5)
    private ScheduledExecutorService reservationExpirationScheduler;

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

        // Đăng ký Tiến trình Hủy đặt trước quá hạn lặp lại tự động sau mỗi 1 giờ (initialDelay=0, period=1, TimeUnit.HOURS)
        reservationExpirationScheduler = Executors.newSingleThreadScheduledExecutor(runnable -> {
            Thread thread = new Thread(runnable, "ReservationExpiration-Thread");
            thread.setDaemon(true); // daemon thread: tự tắt khi JVM dừng
            return thread;
        });
        reservationExpirationScheduler.scheduleAtFixedRate(
            new service.ReservationExpirationProcessor(),
            0,
            1,
            TimeUnit.HOURS
        );
        LOGGER.log(Level.INFO, "[AppListener] Đã đăng ký tiến trình ngầm ReservationExpirationProcessor tự động chạy mỗi 1 giờ.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.log(Level.INFO, "[AppListener] Application LMS Stopping. Cleaning up resources...");

        // Dừng scheduler trước
        if (reservationExpirationScheduler != null && !reservationExpirationScheduler.isShutdown()) {
            LOGGER.log(Level.INFO, "[AppListener] Đang dừng tiến trình ngầm ReservationExpirationProcessor...");
            reservationExpirationScheduler.shutdownNow();
            try {
                if (!reservationExpirationScheduler.awaitTermination(5, TimeUnit.SECONDS)) {
                    LOGGER.log(Level.WARNING, "[AppListener] Tiến trình ngầm không dừng trong thời gian quy định.");
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }

        // Giải phóng JDBC drivers
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
