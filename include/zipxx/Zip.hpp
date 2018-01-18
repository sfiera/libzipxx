// Copyright (c) 2009 Chris Pickel <sfiera@gmail.com>
//
// This file is part of libzipxx, a free software project.  You can redistribute
// it and/or modify
// it under the terms of the MIT License.

#ifndef ZIPXX_ZIP_HPP_
#define ZIPXX_ZIP_HPP_

#include <exception>
#include <memory>
#include <pn/data>
#include <pn/string>

struct zip;
struct zip_file;
struct zip_stat;

namespace zipxx {

class ZipArchive {
  public:
    ZipArchive(const pn::string_view& path, int flags);
    ZipArchive(const ZipArchive&) = delete;
    ZipArchive(ZipArchive&&)      = delete;
    ~ZipArchive();

    pn::string_view path() const;

    size_t size() const;

    zip* c_obj();

  private:
    zip* _c_obj;

    pn::string _path;
};

class ZipFileReader {
  public:
    ZipFileReader(ZipArchive& archive, int index);
    ZipFileReader(ZipArchive& archive, const pn::string_view& path);
    ZipFileReader(const ZipFileReader&) = delete;
    ZipFileReader(ZipFileReader&&)      = delete;

    pn::string_view path() const;
    pn::data_view   data() const;

  private:
    void initialize(ZipArchive& archive, const struct zip_stat& st);

    pn::string _path;
    pn::data   _data;
};

}  // namespace zipxx

#endif  // ZIPXX_ZIP_HPP_
