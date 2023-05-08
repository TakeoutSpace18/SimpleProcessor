# SimpleProcessor

## ISA ##

### Register type instructions ###
Syntax: ```opcode[5bit] | r1[3bit] | r2[3bit] | r3[3bit]```

| name | opcode | description                     |
|------|--------|---------------------------------|
| add  | 0      | r3 = r1 + r2                    |
| sub  | 1      | r3 = r1 - r2                    |
| div  | 2      | r3 = r1 / r2                    |
| mul  | 3      | r3 = r1 * r2                    |
| mod  | 4      | r3 = r1 % r2                    |
| sil  | 5      | r3 = 1 if r1 < r2, else r3 = 0  |
| sie  | 6      | r3 = 1 if r1 == r2, else r3 = 0 |


### Immediate type instructions ###
Syntax: ```opcode[5bit] | r1[3bit] | arg[16bit]```

| name | opcode | description                     |
|------|--------|---------------------------------|
| br   | 7      | jump to \<arg\> if r1 == 1      |
| load | 8      | load value from \<arg\> in RAM to r1|
| store| 9      | store r1 value to \<arg\> in RAM|
