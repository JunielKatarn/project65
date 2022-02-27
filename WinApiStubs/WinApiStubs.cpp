// WinApiStubs.cpp : Defines the exported functions for the DLL.
//

#include "pch.h"
#include "framework.h"
#include "WinApiStubs.h"


// This is an example of an exported variable
WINAPISTUBS_API int nWinApiStubs=0;

// This is an example of an exported function.
WINAPISTUBS_API int fnWinApiStubs(void)
{
    return 0;
}

// This is the constructor of a class that has been exported.
CWinApiStubs::CWinApiStubs()
{
    return;
}

#include <Windows.h>
#include <WinInet.h>

namespace {

	char sessionStubChars[1];
	LPVOID sessionStubVoid = static_cast<LPVOID>(sessionStubChars); //(LPVOID)lpb;

} //namespace

EXTERN_C __declspec(dllexport) HINTERNET STDAPICALLTYPE InternetOpenW(
	_In_opt_ LPCWSTR lpszAgent,
	_In_ DWORD dwAccessType,
	_In_opt_ LPCWSTR lpszProxy,
	_In_opt_ LPCWSTR lpszProxyBypass,
	_In_ DWORD dwFlags
)
{
	return sessionStubVoid;
}