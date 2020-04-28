# Makefile
HX_SOURCEMOD = ../sourcemod
HX_SDKL4D2 = ../hl2sdk-l4d2
HX_METAMOD = ../mmsource
#
# l4d2_bugfixes.ext.so
#
HX_INCLUDE = -I. \
	-I$(HX_SDKL4D2)/public \
	-I$(HX_SDKL4D2)/public/tier0 \
	-I$(HX_SDKL4D2)/public/tier1 \
	-I$(HX_METAMOD)/core \
	-I$(HX_METAMOD)/core/sourcehook \
	-I$(HX_SOURCEMOD)/public \
	-I$(HX_SOURCEMOD)/public/amtl \
	-I$(HX_SOURCEMOD)/public/amtl/amtl \
	-I$(HX_SOURCEMOD)/sourcepawn/include
#
HX_QWERTY = -D_LINUX \
	-Dstricmp=strcasecmp \
	-D_stricmp=strcasecmp \
	-D_strnicmp=strncasecmp \
	-Dstrnicmp=strncasecmp \
	-D_snprintf=snprintf \
	-D_vsnprintf=vsnprintf \
	-D_alloca=alloca \
	-Dstrcmpi=strcasecmp \
	-Wall \
	-Werror \
	-Wno-switch \
	-Wno-unused \
	-msse \
	-DSOURCEMOD_BUILD \
	-DHAVE_STDINT_H \
	-m32 \
	-DNDEBUG \
	-O3 \
	-funroll-loops \
	-pipe \
	-fno-strict-aliasing \
	-fvisibility=hidden \
	-DCOMPILER_GCC \
	-mfpmath=sse

CPP_FLAGS = -Wno-non-virtual-dtor \
	-fvisibility-inlines-hidden \
	-fno-exceptions \
	-fno-rtti \
	-std=c++11
#
HX_SO = l4d2_release/smsdk_ext.o \
	l4d2_release/detours.o \
	l4d2_release/extension.o

#
HX_L4D2 = -DSOURCE_ENGINE=9 \
	-DSE_EPISODEONE=1 \
	-DSE_DARKMESSIAH=2 \
	-DSE_ORANGEBOX=3 \
	-DSE_BLOODYGOODTIME=4 \
	-DSE_EYE=5 \
	-DSE_CSS=6 \
	-DSE_ORANGEBOXVALVE=7 \
	-DSE_LEFT4DEAD=8 \
	-DSE_LEFT4DEAD2=9 \
	-DSE_ALIENSWARM=10 \
	-DSE_PORTAL2=11 \
	-DSE_CSGO=12
#
all:
	mkdir -p l4d2_release
	ln -sf $(HX_SDKL4D2)/lib/linux/libvstdlib_srv.so libvstdlib_srv.so;
	ln -sf $(HX_SDKL4D2)/lib/linux/libtier0_srv.so libtier0_srv.so;
#
	gcc $(HX_INCLUDE) $(HX_QWERTY) $(CPP_FLAGS) $(HX_L4D2) -o l4d2_release/smsdk_ext.o -c $(HX_SOURCEMOD)/public/smsdk_ext.cpp
	gcc $(HX_INCLUDE) $(HX_QWERTY) $(CPP_FLAGS) $(HX_L4D2) -o l4d2_release/detours.o -c CDetour/detours.cpp
	gcc $(HX_INCLUDE) $(HX_QWERTY) $(CPP_FLAGS) $(HX_L4D2) -o l4d2_release/extension.o -c extension.cpp
#
	gcc $(HX_SO) $(HX_SDKL4D2)/lib/linux/tier1_i486.a $(HX_SDKL4D2)/lib/linux/mathlib_i486.a asm/asm.c libvstdlib_srv.so libtier0_srv.so -static-libgcc -shared -m32 -lm -ldl -o l4d2_release/l4d2_bugfixes.ext.so
#
	rm -rf l4d2_release/*.o
