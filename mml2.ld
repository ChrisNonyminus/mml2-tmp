SECTIONS
{
    __romPos = 0;
    _gp = 0x80078920;
    header_ROM_START = __romPos;
    header_VRAM = ADDR(.header);
    .header : AT(header_ROM_START) SUBALIGN(16)
    {
        header_DATA_START = .;
        header_s = .;
        build/asm/main/header.s.o(.data);
        header_DATA_END = .;
        header_DATA_SIZE = ABSOLUTE(header_DATA_END - header_DATA_START);
    }
    __romPos += SIZEOF(.header);
    header_ROM_END = __romPos;
    header_VRAM_END = .;

    main_ROM_START = __romPos;
    main_VRAM = ADDR(.main);
    .main 0x80010000 : AT(main_ROM_START) SUBALIGN(4)
    {
        main_RODATA_START = .;
        build/asm/main/data/800.rodata.s.o(.rodata);
        build/asm/main/data/11A0.rodata.s.o(.rodata);
        main_RODATA_END = .;
        main_RODATA_SIZE = ABSOLUTE(main_RODATA_END - main_RODATA_START);
        main_TEXT_START = .;
        build/src/main/16D4.c.o(.text);
        build/src/main/60F4.c.o(.text);
        build/asm/main/43AE4.s.o(.text);
        build/asm/main/44624.s.o(.text);
        build/asm/main/44654.s.o(.text);
        build/asm/main/446D4.s.o(.text);
        build/asm/main/447C4.s.o(.text);
        build/asm/main/448D4.s.o(.text);
        build/asm/main/44DB4.s.o(.text);
        build/asm/main/452D4.s.o(.text);
        build/asm/main/45304.s.o(.text);
        build/asm/main/455C4.s.o(.text);
        build/asm/main/45764.s.o(.text);
        build/asm/main/45924.s.o(.text);
        build/asm/main/45984.s.o(.text);
        build/asm/main/459E4.s.o(.text);
        build/asm/main/45AA4.s.o(.text);
        build/asm/main/45B54.s.o(.text);
        build/asm/main/45CB4.s.o(.text);
        build/asm/main/470E4.s.o(.text);
        build/asm/main/47224.s.o(.text);
        build/asm/main/472A4.s.o(.text);
        build/asm/main/472D4.s.o(.text);
        build/asm/main/47304.s.o(.text);
        build/asm/main/47384.s.o(.text);
        build/asm/main/47474.s.o(.text);
        build/asm/main/475B4.s.o(.text);
        build/asm/main/47BB4.s.o(.text);
        build/asm/main/48994.s.o(.text);
        build/asm/main/489B4.s.o(.text);
        build/asm/main/48D34.s.o(.text);
        build/asm/main/48D64.s.o(.text);
        build/asm/main/548F4.s.o(.text);
        main_TEXT_END = .;
        main_TEXT_SIZE = ABSOLUTE(main_TEXT_END - main_TEXT_START);
    }
    main_bss_VRAM = ADDR(.main_bss);
    .main_bss (NOLOAD) : SUBALIGN(4)
    {
        main_BSS_START = .;
        build/src/main/16D4.c.o(.bss);
        build/src/main/60F4.c.o(.bss);
        build/asm/main/43AE4.s.o(.bss);
        build/asm/main/44624.s.o(.bss);
        build/asm/main/44654.s.o(.bss);
        build/asm/main/446D4.s.o(.bss);
        build/asm/main/447C4.s.o(.bss);
        build/asm/main/448D4.s.o(.bss);
        build/asm/main/44DB4.s.o(.bss);
        build/asm/main/452D4.s.o(.bss);
        build/asm/main/45304.s.o(.bss);
        build/asm/main/455C4.s.o(.bss);
        build/asm/main/45764.s.o(.bss);
        build/asm/main/45924.s.o(.bss);
        build/asm/main/45984.s.o(.bss);
        build/asm/main/459E4.s.o(.bss);
        build/asm/main/45AA4.s.o(.bss);
        build/asm/main/45B54.s.o(.bss);
        build/asm/main/45CB4.s.o(.bss);
        build/asm/main/470E4.s.o(.bss);
        build/asm/main/47224.s.o(.bss);
        build/asm/main/472A4.s.o(.bss);
        build/asm/main/472D4.s.o(.bss);
        build/asm/main/47304.s.o(.bss);
        build/asm/main/47384.s.o(.bss);
        build/asm/main/47474.s.o(.bss);
        build/asm/main/475B4.s.o(.bss);
        build/asm/main/47BB4.s.o(.bss);
        build/asm/main/48994.s.o(.bss);
        build/asm/main/489B4.s.o(.bss);
        build/asm/main/48D34.s.o(.bss);
        build/asm/main/48D64.s.o(.bss);
        build/asm/main/548F4.s.o(.bss);
        main_BSS_END = .;
        main_BSS_SIZE = ABSOLUTE(main_BSS_END - main_BSS_START);
        _58840_data__s = .;
    }
    main_VRAM = ADDR(.main);
    .main 0x80010000 : AT(main_ROM_START) SUBALIGN(4)
    {
        main_DATA_START = .;
        build/asm/main/data/58840.data.s.o(.data);
        main_DATA_END = .;
        main_DATA_SIZE = ABSOLUTE(main_DATA_END - main_DATA_START);
    }
    __romPos += SIZEOF(.main);
    __romPos = ALIGN(__romPos, 16);
    main_ROM_END = __romPos;
    main_VRAM_END = .;

    /DISCARD/ :
    {
        *(*);
    }
}
