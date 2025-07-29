ENTRY(Reset_Handler)

MEMORY
{
	ROM   (rx)  : ORIGIN = 0x08000000, LENGTH = 2M
	DTCM  (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
	RAM   (rwx) : ORIGIN = 0x20020000, LENGTH = 384K	
}

__StackTop   = ORIGIN(DTCM) + LENGTH(DTCM);   /* 0x2002_000 */
__StackLimit = __StackTop - 0x2000;            	  

_estack = __StackTop;

SECTIONS
{
	.isr_vector : 
	{
		. = ALIGN(4);
		KEEP(*(.isr_vector));
		. = ALIGN(4);
	} >ROM

	.text :
	{
		. = ALIGN(4);
		*(.text)
		*(.text.*)
		_etext = .;
	} >ROM

	.rodata : 
	{
		. = ALIGN(4);
		*(.rodata*)
		. = ALIGN(4);
	} >ROM
	
	.ARM.extab : 
	{
		. = ALIGN(4);
		*(.ARM.extab* .gnu.linkonce.armxtab.*)
		. = ALIGN(4);
	} >ROM

	_sidata = LOADADDR(.data);

	.data : 
	{
		. = ALIGN(4);
		_sdata = .;
		*(.data*)
		. = ALIGN(4);
		_edata = .;
	} >RAM AT> ROM

	.bss :
	{
		. = ALIGN(32);
		_sbss = .;
		*(.bss*)
		*(COMMON)

		. = ALIGN(32);
		_ebss = .;
	} >RAM

	.dtcm (NOLOAD) : 
	{
		. = ORIGIN(DTCM);
		*(.dtcm*)
		. = ALIGN(4);
	} >DTCM

	.heap (NOLOAD) :
	{
		. = ALIGN(32);
		_sheap = .;
		. += 64K;
		_eheap = .;
	} >RAM
}
