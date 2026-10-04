#import "../../labs/common/template.typ": handout-document

#show heading.where(level: 2): set heading(numbering: none, outlined: false)
#show heading.where(level: 3): set heading(numbering: none, outlined: false)
#show: handout-document.with([AB Exam Model: Worked Solutions], lang: "en")

= Hexadecimal to Binary
#include "hextobin/sol.typ"

= Hexadecimal to Decimal
#include "hextodec/sol.typ"

= IEEE 754
#include "ieee754/sol.typ"

= Cache Type
#include "cachetype/sol.typ"

= Cache Block Size
#include "cacheblocksize/sol.typ"

= Cache Size
#include "cachesize/sol.typ"

= Cache Associativity
#include "cacheassociativity/sol.typ"

= Multi-level Cache
#include "multilevelcache/sol.typ"

= Adder Type
#include "addertype/sol.typ"

= Booth's Algorithm
#include "booth/sol.typ"

= Flags
#include "flags/sol.typ"

= Addressing Modes
#include "addressing/sol.typ"

= Instruction Set
#include "instructionset/sol.typ"

= Decoding
#include "decoding/sol.typ"

= I/O
#include "io/sol.typ"

= UART
#include "uart/sol.typ"

= Interrupts
#include "interrupts/sol.typ"

= Microcode MIC
#include "microcode/mic.typ"

= Microcode MMC
#include "microcode/mmc.typ"

= Microcode Minimal Instruction Set
#include "microcode/minimal.typ"

#heading(level: 1, numbering: none)[Appendix: Detailed Microcode Walkthrough]
#include "microcode/appendix.typ"