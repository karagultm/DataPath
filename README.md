# DataPath---CSE-3038-Project

New Designed Single Cycle Datapath: [draw.io link](https://app.diagrams.net/#G1z7Hj1Z_vkeHj8YUHHwLlktDPJ7t3C3rj#%7B%22pageId%22%3A%22NKrvwKDicTFQd9E-sb2j%22%7D)

## Overview

The project involved extending the processor to support six new instructions: **brv**, **jmxor**, **nori**, **blezal**, **jalpc**, and **baln**. This required modifications to the control logic, the addition of new multiplexers, and the inclusion of status register flags to handle the specific behaviors of these instructions.

## New Instructions

brv: R-type instruction that branches to the address in register $rs if the overflow status flag (V) is set.

jmxor: R-type instruction that jumps to the address found in memory at the address calculated by XORing $rs and $rt, and stores the link address in register $31.

nori: I-type instruction that performs a NOR operation between the value in $rs and a zero-extended immediate, storing the result in $rt.

blezal: I-type instruction that branches to a PC-relative address if the value in $rs is less than or equal to zero, and stores the link address in register $25.

jalpc: I-type instruction that jumps to a PC-relative address and stores the link address in $rt.

baln: J-type instruction that branches to a pseudo-direct address if the negative status flag (N) is set, storing the link address in register $31.

## Modifications

### Design

![](https://lh7-us.googleusercontent.com/DpWy8p4wZqhSD6oO5305Aplix6FVfKWQtOtwCiEz7lAbc2ZQDgJP33jUvmD02jbAu33FVmMRtdUd1xMs9WUTiVQaqVb88X8ZWEOcx_b-wO9L7_WG0eu8p8daZus6HHf3wcto_jHW3cifPdy0oc9bQvA)

The new design is built on the foundation of a single-cycle datapath. Components necessary for Zero extension and pseudo direct addressing have been added to accommodate the new instructions. Status registers have been implemented within the ALU based on the values of the previous instruction. Instructions that use PC-relative addressing are connected to pcsrc0 via an OR gate, while jump instructions are connected to pcsrc1 via another OR gate. Multiplexers have been expanded as needed to ensure the proper operation of all instructions in the design. By providing the function code as an input to the control unit, control signal adjustments have been configured for the new R-type instructions. Additionally, the bit width of the ALUop signal has been increased from 2 to 3 bits.

### INSTRUCTION FORMAT DETAIL

The parts used by the new instructions were determined according to their instruction formats.

### ALU CONTROL DETAILS

![](https://lh7-us.googleusercontent.com/TzyAQFtM9nblSJGFiaoGuYKTnsZOObWL4a598VPzaooOeUrwRwcV6TyYbmLMVCe834uosIogy-jC-lpjJFHlD6LfkkCs03n8KvylTfE1RpkNg0smIAGgfm-nG4XUFk9DsEPUKwyxAyqhtillSnGc8Uw)

The ALUop bit width was expanded to 3 bits. Accordingly, the signals coming from the ALU CONTROL were customized.

### CONTROL UNIT SIGNALS

![](https://lh7-us.googleusercontent.com/Amdd09HrNaoQs2de1A0t3Mck4D6TuqKc-jribneGARcUzsh1m4Kd9DjDqri9PD1dqbBWuyo2PxSw8WTXqkAzle1vHThnNO2_9bXX2kDZVGwii8o-r7_IYCUJ8rMTO4rYXnVYo6yyutA9WcbTglDJdOs)

The signals coming from the control unit were customized according to the instructions. This made the implementation of the control unit easier.

## BRV

Insturcion: 01094020 → add $8, $8,$9

Insturcion: 01000014 → brv $8

Insturcion: 01ce7020 → add $14, $14, $14

In this example, our first instruction, add $8, $8, $9, accounts for the condition where there is no overflow. So, the next instruction, which is brv, will not jump to the address in $8, which is 0x0000003C. The next instruction, add $14, $14, $14, causes an overflow. This overflow is written to the statusV register for use in the following instruction. When the brv instruction is encountered again, it will jump to the value in register $8. Therefore, our new PC will be 0x0000003C.

![](https://lh7-us.googleusercontent.com/gl7PyMuEW0asGPTdiZ30zJtwiJ2P1jcIJb8vK5DM8-PfXVZ7JMeGhyFyoicR2Qbw4TM82qIwC7Ew5ul0X8cERQ1sfE7PcH6J0vncMsfsjg7BMKLrsPjXTqAizNyX5C8zHBp0Z_ucDyrnAM2ophl-Hys)![](https://lh7-us.googleusercontent.com/uy0b51YOrB3OyexPp7L72JjrLU8rpRtgIAX9z0uP1svRqbs-J2mzzkJqhakZZX-FOMyxAtkSCm_9qyJqPdgApdXRJYUlYof7CQsLvdfI1KtaJcAAORYC1R2nXJKnlfCYdX6J9DKZiU7hQAk4V2kvfJE)

## JMXOR

Insturcion: 014b0022 → jmxor $10, $11

The jmxor instruction jumps to the address obtained by applying the XOR operation to the values in registers $rs and $rt. The next address is stored in register $31.

For instance, consider the instruction 0x014B0021.

$rs is $10

$10: 0000 0000 0000 0000 0000 0000 0000 0010

$rt is $11

$11: 0000 0000 0000 0000 0000 0000 0000 1000

Performing the XOR operation:

$10  :0000 0000 0000 0000 0000 0000 0000 0010

$11  :0000 0000 0000 0000 0000 0000 0000 1000

---

XOR  : 0000 0000 0000 0000 0000 0000 0000 1010 → 0x0000000A

Current PC: 0000 0000 0000 0000 0000 0000 0000 0100

PC + 4: 0000 0000 0000 0000 0000 0000 0000 1000 → 0x00000008 is stored in $31.

The program then jumps to 0x0000000A.

![](https://lh7-us.googleusercontent.com/poHf8FxExj2aRVeYjwIEWKbR-OrJZMTN8SesQRo8XGMxFjbk85nSJWSY8IOWe3nEwGwAggUinnyeabYZhufzos2ciap7_Mp00evuT7rgrTHlCvpw9_7VtpFkOcshQZZ6z1_q-Z5TziiImxAMlAqSFPo)![](https://lh7-us.googleusercontent.com/1bEauFXi6-sGFC5Ilxh4xCfK7ckLsga8kWVkdrdPXmF6jbnf1Pu8erYHuLWLpjqwM1DSwCHmkLuqrq7bjCsi7Ue3geO0wTm0EsW3noMjDVJhN-wPUnolmCwOjq2bJzdyH59XUFE1BRHCpPK1OGzYz4g)

## NORI

Instruction: 3dae894a → nori $14, $13, 0x894a

(001111 01101 011101 1001 1001 0100 1010)

The nori instruction applies the NOR operation to the data of the $rs register and the zero-extended label (0x894A), then writes the result to the $rt register.

For instance, let's consider the instruction with the hex code 0x3DAE894A.

Label: 0x894A

$13 (rs): 0x00000000

$14 (rt): (result destination register)

Performing the NOR operation:

Label:    0000 0000 0000 0000 1000 1001 0100 1010

$13 (rs): 0000 0000 0000 0000 0000 0000 0000 0000

---

NORI:    1111 1111 1111 1111 0111 0110 1011 0101  → 0xFFFF76B5

So, 0xFFFF76B5 is stored in $14 (rt).

![](https://lh7-us.googleusercontent.com/2iOrP1NYF4Wn5fRM0VBSru43KWWVvlT1NYoTf35fgEWa56gITJn8lxsOpibjVaaO7XMK_sJ_eq8QxFekAYyX5yjpbUDVkqnccnqPZcMxmV1k9lmo35XRJDRNAZ3tYl33ToMjNsPzMQQPi_hjTPwpJNQ)![](https://lh7-us.googleusercontent.com/3oba-71q5Q3AFDTFd-io1LkdJ9kQfj618Atff9xYj7E_a8cv7rk_2hteX56WFUETex2KfkYlvTOUPiUXQWrP5wG2pPPoPGDjaMQVhCKEPBDF6LOEDgr2vghg_SyLDF8c0flC6K4HsRO6OC5WCPcEpbw)

## JALPC

Instruction: 7c0f0002 → jalpc $15, 0x0002

The Jalpc instruction jumps to a PC-relative address (BTA) and links the address to $rt.

For instance, let's consider the instruction with the hex code 0x7C0F0002.

0x0002 is our target address.

Target     :  0000 0000 0000 0000 0000 0000 0000 0010

To go to PC-related address we must shift by two the target and add to the PC+4

PC+4       : 0000 0000 0000 0000 0000 0000 0000 0100

Target *4 : 0000 0000 0000 0000 0000 0000 0000 1000

---

Total       :  0000 0000 0000 0000 0000 0000 0000 1100

After determining the destination address we  go there by adding 4:

Next PC:  0000 0000 0000 0000 0000 0000 0001 0000  → 0x00000010

And the previous address is stored in $rt register which in our case it’s $15 register and it’s content is

PC+4: 0000 0000 0000 0000 0000 0000 0000 1000   → 0x00000008

![](https://lh7-us.googleusercontent.com/k3k-8tiHytlj9wnGIeM0EJfA5aEqZA-JfvKUP-kDtSsDc47sbGKE_g_haNCeG1TZMiBZWRk4w9ivbQlauimE15HI9JxMnfAwIUX-MfznUYcb2TR7jlnuTxhQjWiMptYv2IqMP36sDkX09bmItrxiI6o)![](https://lh7-us.googleusercontent.com/Nw7fAkK0AIZwck7I9tg188dyyD7YszgVDA8ftDotl3iAD7BDuGXEPJE7I1JaGPsQhHIvi8gyAq_svkCFv-nZ6AjfowZcIX5xZYmWmyzIanosI-R-WtYJZgja0baE5PCRsxSD5OLOoHcIkiplUgBU18E)

## BLEZAL

Instruction: 0x91c00004 → blezal $14, 0x0004

Instruction: 0x91400004 → blezal $10, 0x0004

Instruction: 0x91800004 → blezal $12, 0x0004

Blezal instruction checks if R[rs] is smaller or equal to 0 if it is it jumps to do PC-relative address. The link address is stored $25 register.

For instance,

### Case 1

Let's consider the instruction with the hex code 0x91C00004.

$14 (rs): 1000 0000 0000 0000 0000 0000 0000 → negative so instruction will jump to new address

LABEL: 0000 0000 0000 0000 0000 0000 0100

PC+4    : 0000 0000 0000 0000 0000 0000 1000 → 0x00000008 stored in $25 register

LABEL x 4: 0000 0000 0000 0000 0000 0001 0000
------------------------------------------------

New PC : 0000 0000 0000 0000 0000 0001 1000  →  0x00000018

![](https://lh7-us.googleusercontent.com/rt2G6COZfKNw3riRsUJXiv36AxUZRxKDl7_JwTY0RqVgspmBev50MM03d8e-0TfEZ50YFvktXnNEgKM1ms9BMqE5TuaQEBLKwSC4oDs5G7a00HSLeAVTNXeQN__dcnrlsyS9gWTGIeQA1uGoryQhDFQ)![](https://lh7-us.googleusercontent.com/iAgpDeRmCcGlUuqnHAfgIzgXuLtsl1rVTkfnYIAi87Jd4aWacJDDbAYLA5Z5-dCt90gxtJwnCi8_kNKNNQtsgdj-IkS857T_Tks987zjkN7kzE4U6dv0jw0MQGb6QE_d5XECH2Nr4B7Fitt8uow3840)

### Case 2

Let's consider the instruction with the hex code 0x91400004.

$10 (rs)	: 0000 0000 0000 0000 0000 0000 0002 → positive so instruction will not jump to new address

LABEL	: 0000 0000 0000 0000 0000 0000 0100

PC+4	    : 	0000 0000 0000 0000 0000 0000 1000 → 0x00000008 (nothing change)

![](https://lh7-us.googleusercontent.com/Dsmcx5ociTem1tVhDPG2Tedv5dVfECjIbuCjjZQeN0YnvDTbB3yY_WSvmoxDebuHoTnKhx-XmSUgeL0IuQ1i15NBmf89ea_yUgqRkQANxORSzfJW7Q2AigQryiiEsE8HkwdE_aLIc74p6WXNpRT54yU)![](https://lh7-us.googleusercontent.com/1H_9YIPhlSY2ZxzJY56A2FFsjJXAqvrMJwY3QbhL2ak64amJciz5AEMRWspkOYHMytTLYIJQlCap4YH_-WqtbhhNVQi2wokh0-cIuwnJvAYNia1bZALsDh4Ret6Pw-AVj955u74me6XrR8gRnip4n5U)

### Case 3

Let's consider the instruction with the hex code 0x91800004.

$12 (rs): 0000 0000 0000 0000 0000 0000 0000 → zero so instruction will jump to new address

LABEL: 0000 0000 0000 0000 0000 0000 0100

PC+4    : 0000 0000 0000 0000 0000 0000 1000 → 0x00000008 stored in $25 register

LABEL x 4: 0000 0000 0000 0000 0000 0001 0000
------------------------------------------------

New PC : 0000 0000 0000 0000 0000 0001 1000  →  0x00000018

![](https://lh7-us.googleusercontent.com/L1f0XHQzs-jhcwCsJ5N4fQ0-JIbu1gX-A50EYNeVgnJv4ZOqZ8VrIs3i64M1jvYr4fc80KhzF8Jicp55ZFNH8os-9sM4PGVVkEqn28_-Ebz6VL1ap38qRN8GNx8X7DssJx-sOXjNnRilQvKv9unQtP0)![](https://lh7-us.googleusercontent.com/88qOgpxVr9TqSU3csKjdvHaQ5qD3fGMXyB_i8RfrFIoiXg_3geWYq4iheT76sGKa0ITMyXFw2X4dc5XNGqfRKK-esIbqgEdI86Q9G83CDHAClWzoHuV8RxBd6mS2qAbkPNdm8dMX07fi6zAuuKwCa-Q)

## BALN

First Instruction: 01c07020 → add $14, $14, $0

Second Instruction: 6c000005 → baln 0x000005

The "baln" instruction functions similarly to the "jal" instruction but with a condition. If the status flag [N] is set to 1, indicating a negative result from a previous operation, the program branches to a pseudo-direct address, similar to how "jal" operates. Additionally, the address of the instruction following the branch is stored in register 31.

The first instruction is add $14, $14, $0

Register $14 contains a value of 0x80000000, which is a negative value. Since $0 is a zero register with a value of 0, the result will indeed be negative.

The program then branches to a pseudo-direct address calculated by concatenating the PC incremented by 4 and the extended label, resulting in a new PC value:

PC+4    : 0000 0000 0000 0000 0000 0000 1000 → first 4 bit ⇒ 0000

(0x00000008 stored in $31 register)

Label        : 0000 0000 0000 0000 0101

Extended label: 0000 0000 0000 0000 0101 00

---

New PC   : 0000 0000  0000 0000 0001 0100 → 000014

![](https://lh7-us.googleusercontent.com/1kqmXpgg2Y3nbjaCVnsDMLv5o2ABHWWrXMVCIjdlAODTbLSjAiFqNQfdYmi5GF3AytF3SRC5NG3Xdl2BKVxHkDqWaHleYVeg5Uj6VcKU4xaHYbxuoNfsrfKM-hcYDuKo7BRXPeysj33R6mS82V9FTD0)![](https://lh7-us.googleusercontent.com/X34sg7iBZA2sRh9jrEvOgR_5rbmi3aF6QZ7AgxdfyG7z5YV_4ZmW9BXZaqZ3XC8qkMnP4PkGjGfXBYsNtGT8xJnWmS9mf6BFwS0wlaSOM8s9pyBKMJM3_VdeoAQf1_hXTADLhVXsyfEHpPy5p9IkrWs)

## TEST CASES

| ### BRV                                                                         | ### JMXOR                    | ### NORI                     | ### BLEZAL                                                     | ### JALPC                    | ### BALN                                      |
| ------------------------------------------------------------------------------- | ---------------------------- | ---------------------------- | -------------------------------------------------------------- | ---------------------------- | --------------------------------------------- |
| @0000000000``01094020``01000014``01ce7020``01000014 | @0000000000``014b0022 | @0000000000``3dae894a | @0000000000``91C00004``91400004``91800004 | @0000000000``7c0f0002 | @0000000000``01c07020``6c000005 |

**
