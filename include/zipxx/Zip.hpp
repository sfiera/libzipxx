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
    using size_type             = int64_t;
    static const size_type npos = -1;

    ZipArchive(const pn::string_view& path, int flags);
    ZipArchive(const ZipArchive&) = delete;
    ZipArchive(ZipArchive&&)      = delete;
    ~ZipArchive();

    pn::string_view path() const;

    size_type size() const;

    size_type       locate(pn::string_view name) const;
    pn::string_view name(size_type index) const;

    zip* c_obj() const;

  private:
    zip* _c_obj;

    pn::string _path;
};

class ZipFileReader {
  public:
    ZipFileReader(const ZipArchive& archive, ZipArchive::size_type index);
    ZipFileReader(const ZipArchive& archive, const pn::string_view& path);

    ZipFileReader(const ZipFileReader&) = delete;
    ZipFileReader(ZipFileReader&&)      = delete;

    pn::string_view path() const;
    pn::data_view   data() const;
    pn::string_view string() const;

  private:
    void initialize(const ZipArchive& archive, const struct zip_stat& st);

    pn::string _path;
    pn::data   _data;
};

}  // namespace zipxx

#endif  // ZIPXX_ZIP_HPP_
