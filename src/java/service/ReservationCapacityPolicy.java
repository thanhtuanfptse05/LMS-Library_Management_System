package service;

/**
 * Quy tắc thuần cho số suất khả dụng khi Reservation không giữ BookCopy cụ thể.
 */
public final class ReservationCapacityPolicy {

    public enum CapacityLossAction {
        DECREMENT_AVAILABLE,
        DEMOTE_LATEST_READY
    }

    public enum CapacityReleaseAction {
        TRANSFER_TO_NEXT,
        INCREMENT_AVAILABLE
    }

    private ReservationCapacityPolicy() {
    }

    public static CapacityLossAction onPhysicalCopyUnavailable(int availableQuantity) {
        return availableQuantity > 0
                ? CapacityLossAction.DECREMENT_AVAILABLE
                : CapacityLossAction.DEMOTE_LATEST_READY;
    }

    public static CapacityReleaseAction onReadyHoldReleased(boolean hasPendingReservation) {
        return hasPendingReservation
                ? CapacityReleaseAction.TRANSFER_TO_NEXT
                : CapacityReleaseAction.INCREMENT_AVAILABLE;
    }

    public static CapacityReleaseAction onPhysicalCopyRestored(boolean hasPendingReservation) {
        return onReadyHoldReleased(hasPendingReservation);
    }
}
