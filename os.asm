TIMER_FREQUENCY = 0xffff
REDRAW_TIME = 0x1000

LOG_ALL = 0
LOG_TESTS = 0
LOGGING = LOG_ALL
LOG_THREAD_DETAILS = 0

include 'Functions'
include 'Constants'

include 'Macro/Cinc'
include 'Macro/Tinc'
include 'Macro/include_data'
include 'Macro/displayValue'
include 'Macro/IDT_Entry'
include 'Macro/assertEq'
include 'Macro/debug'
include 'Macro/print'
include 'Macro/writeln'
include 'Macro/timestamp'
include 'Macro/printThread'
include 'Macro/iretPrint'
include 'Macro/displayQueue'
include 'Macro/memset'
include 'Macro/write'
include 'Macro/event'
include 'Macro/reginfo'
include 'Macro/Int-Handler'

include 'Struct/Thread'
include 'Struct/Iret'

org BOOTLOADER_ADDRESS

include 'Kernel/bootloader'

memory_map_count dw 0

displayValue ($-$$)
display ' Size of Bootloader'
display 13,10
times 510-($-$$) db 'B'
dw 0xAA55
BINARY_SIZE = $-$$

org INITALIZE_ADDRESS;---------------------
setoffset (-V)

include 'Initalize/setupPaging'
include 'Initalize/enableA20'
include 'Initalize/enableProtectedMode'
include 'Initalize/enablePaging'

include 'Initalize/jumpToPMode'

include 'Initalize/remapIRQ'
include 'Initalize/installDefaultHandlers'
include 'Initalize/setupTSS'
include 'Initalize/setupThreadData'

include 'Initalize/zeroData'

include 'Initalize/memoryInit'
include 'Initalize/claimKernelPages'

setoffset 0
Cinc 'Initalize/enterUserMode', 1

displayValue ($-$$)
display ' Size of Initalize'
display 13,10
times 512 - ($-$$) mod 512 db 'E'
INITALIZE_SIZE = $-$$
BINARY_SIZE = BINARY_SIZE + INITALIZE_SIZE

org V+KERNEL_ADDRESS ;----------------------

include 'Data/Variables'


include 'Kernel/GDTHeader'
include 'Kernel/IDTHeader'

align 32
include_data IDT, 'Kernel/IDT'
include_data GDT, 'Kernel/GDT'
include_data TSS, 'Kernel/TSS'

Cinc 'Graphics/DrawChar', 0
Cinc 'Graphics/DrawNumber', 0
Cinc 'Graphics/DrawRect', 0
Cinc 'Graphics/DrawString', 0
Cinc 'Graphics/DrawColor', 0

Cinc 'BochsPrint/PrintChar', 0
Cinc 'BochsPrint/PrintNumber', 0
Cinc 'BochsPrint/PrintString', 0

Cinc 'Interrupt/DivideByZero', 1
Cinc 'Interrupt/PageFault', 0
Cinc 'Interrupt/UnhandledExceptions', 1
Cinc 'Interrupt/Timer', 0
Cinc 'Interrupt/Keyboard', 0
Cinc 'Interrupt/InstallHandler', 0
Cinc 'Interrupt/StartThread', 0
Cinc 'Interrupt/Share', 0
Cinc 'Interrupt/Signal', 0
Cinc 'Interrupt/WaitFor', 0
Cinc 'Interrupt/Sleep', 0
Cinc 'Interrupt/WaitForShare', 0
Cinc 'Interrupt/ThreadInfo', 0

include 'Kernel/Messages'

Cinc 'Kernel/AllocPage', 0
Cinc 'Kernel/FreePage', 0

Cinc 'Kernel/GetThreadWithTID', 0

Cinc 'Kernel/CreateThread', 0
Cinc 'Kernel/StartThread', 0
Cinc 'Kernel/QueueThread', 0
Cinc 'Kernel/stopThread', 0

include 'std/string_compare'
include 'std/string_copy'
include 'std/FindThreadWithDescription'
include 'std/read_byte'
include 'std/write_byte'
include 'std/find_tid'

include_data BLOCKFONT, 'Data/BlockFont';

Cinc 'Kernel/stopSystem', 1

;---------------------------------------;

;---------------------------------------;
displayValue ($-$$)                     ;
display ' Size of Kernel'               ;
display 13,10                           ;
times 512 - ($-$$) mod 512 db 'E'       ;
KERNEL_SIZE = $-$$                      ;
BINARY_SIZE = BINARY_SIZE + KERNEL_SIZE ;
;---------------------------------------;

org V+TEST_PROGRAMS
LOC= $

Cinc 'Manager/Keyboard', 0

Cinc 'UserProgram/apploader', 1

Cinc 'UserProgram/shell', 0
Cinc 'UserProgram/terminal', 0

Tinc 'Test/TestLoader', 0

Tinc 'Test/VirtualMemory', 0
Tinc 'Test/Lock', 0
Tinc 'Test/Share', 0

;---------------------------------------;
displayValue ($-LOC)                     ;
display ' Size of User Programs'               ;
display 13,10                           ;
times 512 - ($-LOC) mod 512 db 'E'       ;
PROGRAMS_SIZE = $-LOC                      ;

BINARY_SIZE = BINARY_SIZE + PROGRAMS_SIZE ;
;---------------------------------------;

;---------------------------------------;
displayValue BINARY_SIZE                ;
display ' Size of Binary'               ;
display 13,10                           ;
;---------------------------------------;

times (55*512) - BINARY_SIZE db 'C'
