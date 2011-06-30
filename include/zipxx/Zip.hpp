// Copyright (c) 2009 Chris Pickel <sfiera@gmail.com>
//
// This file is part of libzipxx, a free software project.  You can redistribute it and/or modify
// it under the terms of the MIT License.

#ifndef ZIPXX_ZIP_HPP_
#define ZIPXX_ZIP_HPP_

#include <exception>
#include <sfz/sfz.hpp>

struct zip;
struct zip_file;
struct zip_stat;

namespace zipxx {

class ZipArchive {
  public:
    ZipArchive(const sfz::StringSlice& path, int flags);
    ~ZipArchive();

    const sfz::String& path() const;

    size_t size() const;

    zip* c_obj();

  private:
    zip* _c_obj;

    sfz::String _path;

    DISALLOW_COPY_AND_ASSIGN(ZipArchive);
};

class ZipFileReader {
  public:
    ZipFileReader(ZipArchive& archive, int index);
    ZipFileReader(ZipArchive& archive, const sfz::StringSlice& path);

    const sfz::String& path() const;
    const sfz::Bytes& data() const;

  private:
    void initialize(ZipArchive& archive, const struct zip_stat& st);

    sfz::String _path;
    sfz::Bytes _data;

    DISALLOW_COPY_AND_ASSIGN(ZipFileReader);
};

}  // namespace zipxx

#endif  // ZIPXX_ZIP_HPP_
