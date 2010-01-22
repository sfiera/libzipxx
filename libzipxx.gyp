{
    'target_defaults': {
        'include_dirs': [
            'include',
            '../libsfz/include',
            '../libzip/lib',
        ],
        'xcode_settings': {
            'GCC_TREAT_WARNINGS_AS_ERRORS': 'YES',
            'GCC_SYMBOLS_PRIVATE_EXTERN': 'YES',
            'SDKROOT': 'macosx10.4',
            'GCC_VERSION': '4.0',
            'ARCHS': 'ppc x86_64 i386',
            'WARNING_CFLAGS': [
                '-Wall',
                '-Wendif-labels',
            ],
        },
    },
    'targets': [
        {
            'target_name': 'libzipxx',
            'type': '<(library)',
            'sources': [
                'src/zipxx/Zip.cpp',
            ],
            'dependencies': [
                '../libsfz/libsfz.gyp:libsfz',
                '../libzip/libzip.gyp:libzip',
            ],
        },
    ],
}
