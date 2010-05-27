// Copyright (c) 2009 Chris Pickel <sfiera@gmail.com>
//
// This file is part of libzipxx, a free software project.  You can redistribute it and/or modify
// it under the terms of the MIT License.

#ifndef ZIPXX_ZIP_HPP_
#define ZIPXX_ZIP_HPP_

#include <exception>
#include "sfz/sfz.hpp"

struct zip;
struct zip_file;

namespace zipxx {

class ZipArchive {
  public:
    ZipArchive(const sfz::StringPiece& path, int flags);
    ~ZipArchive();

    const sfz::String& path() const;

    zip* c_obj();

  private:
    zip* _zip;

    sfz::String _path;

    DISALLOW_COPY_AND_ASSIGN(ZipArchive);
};

class ZipFileReader {
  public:
    ZipFileReader(ZipArchive* archive, const sfz::StringPiece& path);

    sfz::BytesPiece data() const;

  private:
    size_t _size;
    sfz::scoped_array<uint8_t> _data;

    DISALLOW_COPY_AND_ASSIGN(ZipFileReader);
};

}  // namespace zipxx

#endif  // ZIPXX_ZIP_HPP_
