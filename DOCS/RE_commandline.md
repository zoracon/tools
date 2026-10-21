# 1 Cyber Ops and Bash

- Ref: PDF_book

## Page 168 - Analyzing Files

### Conversion of hex,dec,binary, & ASCII

### Analyzing with xxd

- Can be examine any part of an executable
- Looking at a file's magioc number: position 0x00 and 4bytes
- -s for startuing position in decimal
- -l number of bytes to return
- The starting offset and length can also be specified in hexadecimal by prepending 0x to the number (i.e., 0x2A).

`xxd -s 0 -l 4 helloworld`

The fifth byte of the file will tell you whether the executable is 32-bit (0x01) or 64-bit (0x02) architecture. In this case, it is a 64-bit executable:

` xxd -s 4 -l 1 helloworld`

The sixth byte tells you whether the file is little-endian (0x01) or big-endian (0x02).
In this case, it is little-endian:

`xxd -s 5 -l 1 helloworld`

You know that the offset of the program header is 0x40 because the file is little-
endian. That offset can then be used to display the program header, which should be
0x38 bytes in length for a 64-bit ELF file:

`xxd -s 0x40 -l 0x38 helloworld`

# Hex Editor

xxd & vim

`vi helloworld`
`:%!xxd`

After you have made your edits, you can covert the file back to normal by using the vi command :%!xxd -r. 

To convert a file loaded in vi to Base64 encoding, use :%!base64.

To convert back from Base64, use :%!base64 -d.

# Extracting Strings

- `strings` is not universal, use `egrep`

`egrep -a -o '\b[[:print:]]{2,}\b' somefile.exe`
- 2 or mopre printable chars
- `-a`: process the binary executable as if it were a text file
- `-o`: will output only matching text instead of entire line

to remove duplicate:
`egrep -a -o '\b[[:print:]]{2,}\b' somefile.exe | sort -u`

usw `awk` to sort strings longest to shortest

`egrep -a -o '\b[[:print:]]{2,}\b' somefile.exe | awk '{print length(), $0}' | sort -rnu`

# VT

P. 152 for VTJson Script
P. 154 for Example 11-3. vtjson.awk

API from VT has JSOn output. To easily read:
`rep -Po '{"detected": true.*?"result":.*?,' Calc_VirusTotal.txt`

- `-P`: enable Perl engine
- `.*?`: lazy quantifier to satisfy entire regular expression
