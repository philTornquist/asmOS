# asmOS
A toy x86 OS written entirely in Assembly Language which I wrote to learn about the basics of operating systems. Features include:

- Handwritten bootloader to switch into 32-bit protected mode
- Virtual memory management
- Application code runs in user mode
- Lightweight Threading model
- Basic VGA graphics
- Drivers implemented like any other application(via Thread)(Keyboard driver implemented)
- System calls via Interrupts(I never explored the newer sysenter instruction)

All application code runs as Threads, which have the following properties

- **Non-preemptive scheduling:** Threads execute until they make a system call. Register state is not preserved across system calls, since threads can save any needed register state before making the system call.
- **Virtual Memory Per Thread:** Each Thread gets it's own virtual memory space. This achieves strong isolation and enable cooperation(see next point).
- **Page Sharing between Threads:** Via system calls share/wait_for_share, Threads can share physical memory at addresses of their virtual memory space. The sharer and sharee both get to choose where the page is mapped in their own address spaces.
- **Signaling:** Thread A can request to be blocked until Thread B, and only Thread B, signals a wake-up. This combined with physical memory sharing allows for full cooperation. 
- **Thread "Service Discovery"**: Threads can register a description with the Kernel so other Threads can find their ThreadID dynamically. As implemented here, this allows the "shell" application to find and connect to the "terminal". 
