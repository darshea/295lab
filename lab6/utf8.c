#include <stdint.h>
#include <stdio.h>

void report_character(uint32_t character, int byte_count) {
    printf("Character: %u, Byte Count: %d\n", character, byte_count);
}

void decode_utf8(const char* string) {
    
    while (*string) {
        uint32_t character = 0;
        int byte_count = 0;
        unsigned char byte = *string;

        if ((byte & 0x80) == 0) {  // 1byte char
            character = byte;
            byte_count = 1;
        } else if ((byte & 0xE0) == 0xC0) {  // 2byte char
            character = (byte & 0x1F) << 6;
            string++;
            character |= *string & 0x3F;
            byte_count = 2;
        } else if ((byte & 0xF0) == 0xE0) {  // 3 char
            character = (byte & 0x0F) << 12;
            string++;
            character |= (*string & 0x3F) << 6;
            string++;
            character |= *string & 0x3F;
            byte_count = 3;
        } else if ((byte & 0xF8) == 0xF0) {  // 4 char
            character = (byte & 0x07) << 18;
            string++;
            character |= (*string & 0x3F) << 12;
            string++;
            character |= (*string & 0x3F) << 6;
            string++;
            character |= *string & 0x3F;
            byte_count = 4;
        }
        
        report_character(character, byte_count);
        string++;
    }

}
