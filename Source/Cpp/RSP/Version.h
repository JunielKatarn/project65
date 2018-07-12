/*
* RSP Compiler plug in for Project64 (A Nintendo 64 emulator).
*
* (c) Copyright 2001 jabo (jabo@emulation64.com) and
* zilmar (zilmar@emulation64.com)
*
* pj64 homepage: www.pj64.net
*
* Permission to use, copy, modify and distribute Project64 in both binary and
* source form, for non-commercial purposes, is hereby granted without fee,
* providing that this license information and copyright notice appear with
* all copies and any derived work.
*
* This software is provided 'as-is', without any express or implied
* warranty. In no event shall the authors be held liable for any damages
* arising from the use of this software.
*
* Project64 is freeware for PERSONAL USE only. Commercial users should
* seek permission of the copyright holders first. Commercial use includes
* charging money for Project64 or software derived from Project64.
*
* The copyright holders request that bug fixes and improvements to the code
* should be forwarded to them so if they want them.
*
*/

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
#define GIT_VERSION                 ""
#endif // GIT_VERSION

#define VER_FILE_DESCRIPTION_STR    "RSP emulation Plugin"
#define VER_FILE_VERSION            VERSION_MAJOR, VERSION_MINOR, VERSION_REVISION, VERSION_BUILD
#define VER_FILE_VERSION_STR        STRINGIZE(VERSION_MAJOR)        \
                                    "." STRINGIZE(VERSION_MINOR)    \
                                    "." STRINGIZE(VERSION_REVISION) \
                                    "." STRINGIZE(VERSION_BUILD)    \
                                    "-" GIT_VERSION

#define VER_PRODUCTNAME_STR         "RSP"
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
