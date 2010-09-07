{
    'target_defaults': {
        'include_dirs': [
            'include',
        ],
    },
    'targets': [
        {
            'target_name': 'libzipxx',
            'type': '<(library)',
            'sources': [
                'src/zipxx/Zip.cpp',
            ],
            'dependencies': [
                '<(DEPTH)/ext/libsfz/libsfz.gyp:libsfz',
                '<(DEPTH)/ext/libzip/libzip.gyp:libzip',
            ],
            'direct_dependent_settings': {
                'include_dirs': [
                    'include',
                ],
            },
            'export_dependent_settings': [
                '<(DEPTH)/ext/libsfz/libsfz.gyp:libsfz',
                '<(DEPTH)/ext/libzip/libzip.gyp:libzip',
            ],
        },
    ],
}
