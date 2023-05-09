// SPDX-License-Identifier: BSD-2-Clause
/*
 * Copyright (c) 2022, Arm Limited.
 */

#include <arm.h>
#include <console.h>
#include <drivers/gic.h>
#include <drivers/pl011.h>
#include <drivers/tpm2_mmio.h>
#include <drivers/tpm2_ptp_fifo.h>
#include <drivers/tzc400.h>
#include <initcall.h>
#include <keep.h>
#include <kernel/boot.h>
#include <kernel/interrupt.h>
#include <kernel/misc.h>
#include <kernel/notif.h>
#include <kernel/panic.h>
#include <kernel/spinlock.h>
#include <kernel/tee_time.h>
#include <mm/core_memprot.h>
#include <mm/core_mmu.h>
#include <platform_config.h>
#include <sm/psci.h>
#include <stdint.h>
#include <string.h>
#include <trace.h>

static struct gic_data gic_data __nex_bss;
static struct pl011_data console_data __nex_bss;

register_phys_mem_pgdir(MEM_AREA_IO_SEC, CONSOLE_UART_BASE, PL011_REG_SIZE);
register_phys_mem_pgdir(MEM_AREA_EXT_DT, EXT_DT_BASE, EXT_DT_SIZE);

register_ddr(DRAM0_BASE, DRAM0_SIZE);
//register_ddr(DRAM1_BASE, DRAM1_SIZE);

register_phys_mem_pgdir(MEM_AREA_IO_SEC, GICD_BASE, GIC_DIST_REG_SIZE);
register_phys_mem_pgdir(MEM_AREA_IO_SEC, GICC_BASE, GIC_DIST_REG_SIZE);
register_phys_mem_pgdir(MEM_AREA_IO_SEC, GICR_BASE, GIC_DIST_REG_SIZE);

void main_init_gic(void)
{
	gic_init_base_addr(&gic_data, GICC_BASE,
			   GICD_BASE);
	itr_init(&gic_data.chip);
}

void main_secondary_init_gic(void)
{
	gic_cpu_init(&gic_data);
}

void itr_core_handler(void)
{
	gic_it_handle(&gic_data);
}

void console_init(void)
{
	pl011_init(&console_data, CONSOLE_UART_BASE, CONSOLE_UART_CLK_IN_HZ,
		   CONSOLE_BAUDRATE);
	register_serial_console(&console_data.chip);
}
