// Copyright (c) 2009 Chris Pickel <sfiera@gmail.com>
//
// This file is part of libzipxx, a free software project.  You can redistribute it and/or modify
// it under the terms of the MIT License.

#include "zipxx/Zip.hpp"

#include <errno.h>
#include <zip.h>
#include <sfz/sfz.hpp>

using sfz::Bytes;
using sfz::CString;
using sfz::Exception;
using sfz::PrintTarget;
using sfz::String;
using sfz::StringSlice;
using sfz::format;
using std::unique_ptr;

namespace utf8 = sfz::utf8;

namespace zipxx {

namespace {

class AutoCloseZipFile {
  public:
    AutoCloseZipFile(zip_file* file) : _file(file) { }
    ~AutoCloseZipFile() { zip_fclose(_file); }
  private:
    zip_file* _file;
};

struct ZipErrorFormatter {
    ZipErrorFormatter(int ze, int se)
        : zip_error(ze),
          system_error(se) { }

    const int zip_error;
    const int system_error;
};

void print_to(PrintTarget out, const ZipErrorFormatter& error) {
    int size = zip_error_to_str(NULL, 0, error.zip_error, error.system_error);
    unique_ptr<char[]> buf(new char[size + 1]);
    zip_error_to_str(buf.get(), size + 1, error.zip_error, error.system_error);
    print_to(out, buf.get());
}

ZipErrorFormatter zip_error(int ze, int se) {
    return ZipErrorFormatter(ze, se);
}

ZipErrorFormatter zip_error(zip* archive) {
    int ze;
    int se;
    zip_error_get(archive, &ze, &se);
    return zip_error(ze, se);
}

ZipErrorFormatter zip_error(zip_file* file) {
    int ze;
    int se;
    zip_file_error_get(file, &ze, &se);
    return zip_error(ze, se);
}

}  // namespace

ZipArchive::ZipArchive(const StringSlice& path, int flags)
    : _path(path) {
    int error;
    CString c_str(path);
    const char* c_path = reinterpret_cast<const char*>(c_str.data());
    _c_obj = zip_open(c_path, 0, &error);
    if (_c_obj == NULL) {
        throw Exception(format("{0}: {1}", path, zip_error(error, errno)));
    }
}

ZipArchive::~ZipArchive() {
    if (zip_close(_c_obj) != 0) {
        fprintf(stderr, "couldn't close zip\n");
    }
}

const String& ZipArchive::path() const {
    return _path;
}

zip* ZipArchive::c_obj() {
    return _c_obj;
}

size_t ZipArchive::size() const {
    return zip_get_num_files(_c_obj);
}

ZipFileReader::ZipFileReader(ZipArchive& archive, const StringSlice& path) {
    struct zip_stat st;
    CString c_str(path);
    if (zip_stat(archive.c_obj(), c_str.data(), 0, &st) != 0) {
        throw Exception(format(
                    "{0}: {1}: {2}", archive.path(), path, zip_error(archive.c_obj())));
    }
    initialize(archive, st);
}

ZipFileReader::ZipFileReader(ZipArchive& archive, int index) {
    struct zip_stat st;
    if (zip_stat_index(archive.c_obj(), index, 0, &st) != 0) {
        throw Exception(format(
                    "{0}: {1}: {2}", archive.path(), index, zip_error(archive.c_obj())));
    }
    initialize(archive, st);
}

void ZipFileReader::initialize(ZipArchive& archive, const struct zip_stat& st) {
    _path.assign(utf8::decode(st.name));

    zip_file* file = zip_fopen_index(archive.c_obj(), st.index, 0);
    if (file == NULL) {
        throw Exception(format(
                    "{0}: {1}: {2}", archive.path(), _path, zip_error(archive.c_obj())));
    }
    AutoCloseZipFile close(file);

    _data.resize(st.size);
    int bytes_read = zip_fread(file, _data.data(), _data.size());
    if ((bytes_read < 0) || (bytes_read - _data.size() != 0)) {
        throw Exception(format("{0}: {1}: {2}", archive.path(), _path, zip_error(file)));
    }
}

const String& ZipFileReader::path() const {
    return _path;
}

const Bytes& ZipFileReader::data() const {
    return _data;
}

}  // namespace zipxx
