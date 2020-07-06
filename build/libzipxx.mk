# Copyright (c) 2009 Chris Pickel <sfiera@twotaled.com>
# This file is part of libzipxx, a free software project.  You can redistribute it and/or modify
# it under the terms of the MIT License.

LIBZIPXX_CPPFLAGS := -I $(LIBZIPXX_ROOT)/include $(LIBZIP_CPPFLAGS)
LIBZIPXX_LDFLAGS := $(LIBZIP_LDFLAGS)

LIBZIPXX_A := $(OUT)/libzipxx.a
LIBZIPXX_SRCS := \
    $(LIBZIPXX_ROOT)/src/zipxx/Zip.cpp

LIBZIPXX_OBJS := $(LIBZIPXX_SRCS:%=$(OUT)/%.o)

$(LIBZIPXX_A): $(LIBZIPXX_OBJS) $(LIBZIP_OBJS)
	$(AR) rcs $@ $+

$(LIBZIPXX_OBJS): $(OUT)/%.cpp.o: %.cpp
	@$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CXXFLAGS) $(LIBZIPXX_CPPFLAGS) $(LIBPROCYON_CPPFLAGS) -c $< -o $@

-include $(LIBZIPXX_OBJS:.o=.d)
