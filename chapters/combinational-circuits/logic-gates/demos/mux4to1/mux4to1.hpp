// Function to implement 4-to-1 multiplexer
int mux4to1(int s0, int s1, int i0, int i1, int i2, int i3) {
    // Use the select value to choose the appropriate input
    switch ((s1 << 1) | s0) {
        case 0:
            return i0;
        case 1:
            return i1;
        case 2:
            return i2;
        case 3:
            return i3;
        default:
            return 0; // Default case (should never be reached)
    }
}