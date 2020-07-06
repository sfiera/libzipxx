# Copyright (c) 2009 Chris Pickel <sfiera@twotaled.com>
# This file is part of libzipxx, a free software project.  You can redistribute it and/or modify
# it under the terms of the MIT License.

ifeq ($(TARGET_OS),linux)

LIBZIP_CPPFLAGS := $(shell pkg-config --cflags libzip)
LIBZIP_LDFLAGS := $(shell pkg-config --libs libzip)

else

LIBZIP_CPPFLAGS := \
	$(ZLIB_CPPFLAGS) \
	-I $(LIBZIPXX_ROOT)/libzip-1.1.3/lib \
	-I $(LIBZIPXX_ROOT)/config/include/$(TARGET_OS) \
	-D ZIP_STATIC
LIBZIP_LDFLAGS := $(ZLIB_LDFLAGS)

LIBZIP_A := $(OUT)/libzip.a
LIBZIP_SRCS := \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/mkstemp.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_add.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_add_dir.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_add_entry.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_buffer.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_close.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_delete.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_dir_add.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_dirent.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_discard.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_entry.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_err_str.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_error.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_error_clear.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_error_get.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_error_get_sys_type.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_error_strerror.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_error_to_str.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_extra_field.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_extra_field_api.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_fclose.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_fdopen.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_file_add.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_file_error_clear.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_file_error_get.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_file_get_comment.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_file_get_external_attributes.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_file_get_offset.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_file_rename.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_file_replace.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_file_set_comment.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_file_set_external_attributes.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_file_set_mtime.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_file_strerror.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_filerange_crc.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_fopen.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_fopen_encrypted.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_fopen_index.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_fopen_index_encrypted.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_fread.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_get_archive_comment.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_get_archive_flag.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_get_compression_implementation.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_get_encryption_implementation.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_get_file_comment.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_get_name.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_get_num_entries.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_get_num_files.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_hash.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_io_util.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_memdup.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_name_locate.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_new.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_open.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_rename.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_replace.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_set_archive_comment.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_set_archive_flag.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_set_default_password.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_set_file_comment.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_set_file_compression.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_set_name.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_begin_write.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_buffer.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_call.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_close.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_commit_write.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_crc.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_deflate.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_error.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_filep.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_free.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_function.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_is_deleted.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_layered.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_open.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_pkware.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_read.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_remove.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_rollback_write.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_seek.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_seek_write.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_stat.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_supports.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_tell.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_tell_write.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_window.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_write.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_zip.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_zip_new.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_stat.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_stat_index.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_stat_init.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_strerror.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_string.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_unchange.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_unchange_all.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_unchange_archive.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_unchange_data.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_utf-8.c

ifeq ($(TARGET_OS),win)
LIBZIP_SRCS += \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_win32a.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_win32handle.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_win32utf8.c \
	$(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_win32w.c
else
LIBZIP_SRCS += $(LIBZIPXX_ROOT)/libzip-1.1.3/lib/zip_source_file.c
endif

LIBZIP_OBJS := $(LIBZIP_SRCS:%=$(OUT)/%.o)

$(LIBZIP_A): $(LIBZIP_OBJS)
	$(AR) rcs $@ $+

LIBZIP_PRIVATE_CPPFLAGS := \
	$(LIBZIP_CPPFLAGS) \
	-I $(LIBZIPXX_ROOT)/config/src/$(TARGET_OS)  \
	-D HAVE_CONFIG_H  \
	-Wno-implicit-function-declaration 

$(LIBZIP_OBJS): $(OUT)/%.c.o: %.c
	@$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LIBZIP_PRIVATE_CPPFLAGS) -c $< -o $@

-include $(LIBZIP_OBJS:.o=.d)

endif
