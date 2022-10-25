include core/arch/arm/cpu/cortex-armv8-0.mk

CFG_DEBUG_INFO = y
CFG_TEE_CORE_LOG_LEVEL = 4

# Workaround 808870: Unconditional VLDM instructions might cause an
# alignment fault even though the address is aligned
# Either hard float must be disabled for AArch32 or strict alignment checks
# must be disabled
ifeq ($(CFG_SCTLR_ALIGNMENT_CHECK),y)
$(call force,CFG_TA_ARM32_NO_HARD_FLOAT_SUPPORT,y)
else
$(call force,CFG_SCTLR_ALIGNMENT_CHECK,n)
endif

CFG_ARM64_core ?= y

CFG_ARM_GICV3 = y

# ARM debugger needs this
platform-cflags-debug-info = -gdwarf-4
platform-aflags-debug-info = -gdwarf-4

CFG_CORE_SEL1_SPMC	= y
CFG_WITH_ARM_TRUSTED_FW	= y

$(call force,CFG_GIC,y)
$(call force,CFG_PL011,y)
$(call force,CFG_SECURE_TIME_SOURCE_CNTPCT,y)

CFG_CORE_HEAP_SIZE = 0x32000 # 200kb

CFG_TEE_CORE_NB_CORE = 4
CFG_TZDRAM_START ?= 0x08000000
CFG_TZDRAM_SIZE  ?= 0x02008000

CFG_SHMEM_START  ?= 0x83000000
CFG_SHMEM_SIZE   ?= 0x00210000
# DRAM1 is defined above 4G
$(call force,CFG_CORE_LARGE_PHYS_ADDR,y)
$(call force,CFG_CORE_ARM64_PA_BITS,42)
