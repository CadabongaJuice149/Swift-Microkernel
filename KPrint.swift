/// Minimal Kernel Print in Swift

@_extern(c, "vga_putchar")
func vga_putchar(_ c: Int8)

public func kprint(_ message: StaticString) {
    message.withUTF8Buffer { buffer in
        for byte in buffer {
            vga_putchar(Int8(byte))
        }
    }
}

public func kprint_char(_ c: Character) {
    // Simplified for now
    vga_putchar(Int8(97)) // 'a'
}
