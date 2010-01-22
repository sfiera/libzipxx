// Copyright (c) 2009 Chris Pickel <sfiera@gmail.com>
//
// This file is part of libzipxx, a free software project.  You can redistribute it and/or modify
// it under the terms of the MIT License.

#include "zipxx/Zip.hpp"

#include <errno.h>
#include <zip.h>
#include "sfz/Exception.hpp"

using sfz::Bytes;
using sfz::BytesPiece;
using sfz::Exception;
using sfz::FormatItem;
using sfz::FormatItemPrinter;
using sfz::String;
using sfz::StringPiece;
using sfz::ascii_encoding;
using sfz::utf8_encoding;
using sfz::scoped_array;

namespace zipxx {

namespace {

class AutoCloseZipFile {
  public:
    AutoCloseZipFile(zip_file* file) : _file(file) { }
    ~AutoCloseZipFile() { zip_fclose(_file); }
  private:
    zip_file* _file;
};

class ZipErrorFormatter : public FormatItemPrinter {
  public:
    ZipErrorFormatter(int ze, int se)
        : _zip_error(ze),
          _system_error(se) { }

    virtual void print_to(String* out) const {
        int size = zip_error_to_str(NULL, 0, _zip_error, _system_error);
        scoped_array<char> buf(new char[size + 1]);
        zip_error_to_str(buf.get(), size + 1, _zip_error, _system_error);
        out->append(buf.get(), ascii_encoding());
    }

  private:
    const int _zip_error;
    const int _system_error;
};

FormatItem zip_error(int ze, int se) {
    return FormatItem::make(new ZipErrorFormatter(ze, se));
}

FormatItem zip_error(zip* archive) {
    int ze;
    int se;
    zip_error_get(archive, &ze, &se);
    return zip_error(ze, se);
}

FormatItem zip_error(zip_file* file) {
    int ze;
    int se;
    zip_file_error_get(file, &ze, &se);
    return zip_error(ze, se);
}

}  // namespace

ZipArchive::ZipArchive(const StringPiece& path, int flags)
    : _path(path) {
    int error;
    Bytes path_bytes(path, utf8_encoding());
    path_bytes.resize(path_bytes.size() + 1);
    const char* c_path = reinterpret_cast<const char*>(path_bytes.data());
    _zip = zip_open(c_path, 0, &error);
    if (_zip == NULL) {
        throw Exception("{0}: {1}", path, zip_error(error, errno));
    }
}

ZipArchive::~ZipArchive() {
    if (zip_close(_zip) != 0) {
        fprintf(stderr, "couldn't close zip\n");
    }
}

const String& ZipArchive::path() const { return _path; }
zip* ZipArchive::c_obj() { return _zip; }

ZipFileReader::ZipFileReader(ZipArchive* archive, const StringPiece& path) {
    struct zip_stat st;
    Bytes path_bytes(path, utf8_encoding());
    path_bytes.resize(path_bytes.size() + 1);
    const char* c_path = reinterpret_cast<const char*>(path_bytes.data());
    if (zip_stat(archive->c_obj(), c_path, 0, &st) != 0) {
        throw Exception("{0}: {1}: {2}", archive->path(), path, zip_error(archive->c_obj()));
    }
    _size = st.size;
    _data.reset(new uint8_t[_size]);

    zip_file* file = zip_fopen(archive->c_obj(), c_path, 0);
    if (file == NULL) {
        throw Exception("{0}: {1}: {2}", archive->path(), path, zip_error(archive->c_obj()));
    }
    AutoCloseZipFile close(file);

    int bytes_read = zip_fread(file, _data.get(), _size);
    if (bytes_read < 0 || static_cast<unsigned int>(bytes_read) != _size) {
        throw Exception("{0}: {1}: {2}", archive->path(), path, zip_error(file));
    }
}

BytesPiece ZipFileReader::data() const { return BytesPiece(_data.get(), _size); }

}  // namespace zipxx
