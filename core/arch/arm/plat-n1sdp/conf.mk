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
$(call force,CFG_CORE_LARGE_PHYS_ADDR,y)
$(call force,CFG_CORE_ARM64_PA_BITS,42)

CFG_CORE_HEAP_SIZE = 0x40000 # 256KB

CFG_TEE_CORE_NB_CORE = 4
CFG_TZDRAM_START ?= 0x0080000000
CFG_TZDRAM_SIZE  ?= 0x0004000000 # 64 MB

CFG_SHMEM_START  ?= ($(CFG_TZDRAM_START) + $(CFG_TZDRAM_SIZE))
CFG_SHMEM_SIZE   ?= 0x00400000 # 4 MB

$(call force,CFG_CACHE_API ,n)

# CFG_TZSRAM_START ?= 0x0004060000
# CFG_TZSRAM_SIZE  ?= 0x0000020000 # 128 KB

# CFG_TEE_RAM_START ?= ($(CFG_TZDRAM_START) + $(CFG_TEE_RAM_START))
# CFG_TEE_RAM_VA_SIZE  ?= 0x400000
# CFG_TEE_RAM_PH_SIZE  ?= CFG_TEE_RAM_VA_SIZE
# CFG_TEE_LOAD_ADDR  ?= (CFG_TZDRAM_START + 0x20000)

# CFG_TA_RAM_START ?= (CFG_TZDRAM_START + CFG_TEE_RAM_VA_SIZE)
# CFG_TA_RAM_SIZE  ?= (CFG_TZDRAM_SIZE - CFG_TEE_RAM_VA_SIZE)
