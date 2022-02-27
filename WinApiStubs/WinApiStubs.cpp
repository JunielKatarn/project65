// WinApiStubs.cpp : Defines the exported functions for the DLL.
//

#include "WinApiStubs.h"

#include <Windows.h>
#include <WinInet.h>

namespace {

char internetOpenStubChars[1];
LPVOID internetOpenStubVoid = static_cast<LPVOID>(internetOpenStubChars);

} //namespace

EXTERN_C __declspec(dllexport) HINTERNET STDAPICALLTYPE InternetOpenW(
	_In_opt_ LPCWSTR lpszAgent,
	_In_ DWORD dwAccessType,
	_In_opt_ LPCWSTR lpszProxy,
	_In_opt_ LPCWSTR lpszProxyBypass,
	_In_ DWORD dwFlags
)
{
	return internetOpenStubVoid;
}
