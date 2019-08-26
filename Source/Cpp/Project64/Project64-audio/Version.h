/****************************************************************************
*                                                                           *
* Project64-audio - A Nintendo 64 audio plugin.                             *
* http://www.pj64-emu.com/                                                  *
* Copyright (C) 2017 Project64. All rights reserved.                        *
*                                                                           *
* License:                                                                  *
* GNU/GPLv2 http://www.gnu.org/licenses/gpl-2.0.html                        *
*                                                                           *
****************************************************************************/
#define STRINGIZE2(s) #s
#define STRINGIZE(s) STRINGIZE2(s)

#ifndef VERSION_MAJOR
#define VERSION_MAJOR               0
#endif // VERSION_MAJOR

#ifndef VERSION_MINOR
#define VERSION_MINOR               0
#endif // VERSION_MINOR

#ifndef VERSION_REVISION
#define VERSION_REVISION            0
#endif // VERSION_REVISION

#ifndef VERSION_BUILD
#define VERSION_BUILD               0
#endif // VERSION_BUILD

#ifndef GIT_VERSION
#define GIT_VERSION                 "00000000"
#endif // GIT_VERSION

#define VER_FILE_DESCRIPTION_STR    "Project64-audio"
#define VER_FILE_VERSION            VERSION_MAJOR, VERSION_MINOR, VERSION_REVISION, VERSION_BUILD
#define VER_FILE_VERSION_STR        STRINGIZE(VERSION_MAJOR)        \
                                    "." STRINGIZE(VERSION_MINOR)    \
                                    "." STRINGIZE(VERSION_BUILD)    \
                                    "." STRINGIZE(VERSION_REVISION) \
                                    "-" GIT_VERSION

#define VER_PRODUCTNAME_STR         "Project64-audio"
#define VER_PRODUCT_VERSION         VER_FILE_VERSION
#define VER_PRODUCT_VERSION_STR     VER_FILE_VERSION_STR
#define VER_ORIGINAL_FILENAME_STR   VER_PRODUCTNAME_STR ".dll"
#define VER_INTERNAL_NAME_STR       VER_PRODUCTNAME_STR
#define VER_COPYRIGHT_STR           "Copyright (C) 2017"

#ifdef _DEBUG
#define VER_VER_DEBUG             VS_FF_DEBUG
#else
#define VER_VER_DEBUG             0
#endif

#define VER_FILEOS                  VOS_NT_WINDOWS32
#define VER_FILEFLAGS               VER_VER_DEBUG
#define VER_FILETYPE                VFT_DLL
