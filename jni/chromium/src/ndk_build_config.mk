## daiguozhou initialized, some common configurations for ndk build

## the build type
ifeq ($(filter Debug Release,$(BUILD_TYPE)),)
ifeq ($(filter debug,$(strip $(APP_OPTIM))),debug)
	BUILD_TYPE := Debug
else
	BUILD_TYPE := Release
endif
endif

$(BILD_TYPE "$(BUILD_TYPE)")
