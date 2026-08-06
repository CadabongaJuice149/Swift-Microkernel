/// x86 (i386) Kernel Entry Point and Bootstrap in Swift

public class ArchX86 {
    public static func boot() {
        // 1. Initialize GDT, IDT
        // 2. Setup Paging
        // 3. Jump to Kernel Main
        kprint("x86 Bootstrap: Initializing CPU state...\n")
        kernel_main()
    }
}

// Note: Kernel class removed as kernel_main is now global
