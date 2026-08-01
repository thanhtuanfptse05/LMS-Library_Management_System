package service;

import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class ReservationCapacityPolicyTest {

    @Test
    public void physicalLossDecrementsWhenAFreeSlotExists() {
        assertEquals(ReservationCapacityPolicy.CapacityLossAction.DECREMENT_AVAILABLE,
                ReservationCapacityPolicy.onPhysicalCopyUnavailable(1));
    }

    @Test
    public void physicalLossDemotesReadyHoldWhenQuantityIsZero() {
        assertEquals(ReservationCapacityPolicy.CapacityLossAction.DEMOTE_LATEST_READY,
                ReservationCapacityPolicy.onPhysicalCopyUnavailable(0));
    }

    @Test
    public void releasingReadyHoldTransfersCapacityWhenQueueExists() {
        assertEquals(ReservationCapacityPolicy.CapacityReleaseAction.TRANSFER_TO_NEXT,
                ReservationCapacityPolicy.onReadyHoldReleased(true));
    }

    @Test
    public void releasingReadyHoldIncrementsOnlyWhenQueueIsEmpty() {
        assertEquals(ReservationCapacityPolicy.CapacityReleaseAction.INCREMENT_AVAILABLE,
                ReservationCapacityPolicy.onReadyHoldReleased(false));
    }

    @Test
    public void restoredCopyIsAllocatedBeforeIncreasingAvailability() {
        assertEquals(ReservationCapacityPolicy.CapacityReleaseAction.TRANSFER_TO_NEXT,
                ReservationCapacityPolicy.onPhysicalCopyRestored(true));
    }
}
