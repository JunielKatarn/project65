// WinApiStubs.cpp : Defines the exported functions for the DLL.
//

#include "WinApiStubs.h"

#include <Windows.h>
#include <WinInet.h>

namespace {

char charsStub[1];
LPVOID voidStub = static_cast<LPVOID>(charsStub);

} //namespace

EXTERN_C __declspec(dllexport) HINTERNET STDAPICALLTYPE InternetOpenW(
	_In_opt_ LPCWSTR lpszAgent,
	_In_ DWORD dwAccessType,
	_In_opt_ LPCWSTR lpszProxy,
	_In_opt_ LPCWSTR lpszProxyBypass,
	_In_ DWORD dwFlags
)
{
	return voidStub;
}

EXTERN_C __declspec(dllexport) HINTERNET STDAPICALLTYPE
InternetConnectW(
	_In_ HINTERNET hInternet,
	_In_ LPCWSTR lpszServerName,
	_In_ INTERNET_PORT nServerPort,
	_In_opt_ LPCWSTR lpszUserName,
	_In_opt_ LPCWSTR lpszPassword,
	_In_ DWORD dwService,
	_In_ DWORD dwFlags,
	_In_opt_ DWORD_PTR dwContext
)
{
	return voidStub;
}

EXTERN_C __declspec(dllexport) HINTERNET STDAPICALLTYPE
HttpOpenRequestW(
	_In_ HINTERNET hConnect,
	_In_opt_ LPCWSTR lpszVerb,
	_In_opt_ LPCWSTR lpszObjectName,
	_In_opt_ LPCWSTR lpszVersion,
	_In_opt_ LPCWSTR lpszReferrer,
	_In_opt_z_ LPCWSTR FAR* lplpszAcceptTypes,
	_In_ DWORD dwFlags,
	_In_opt_ DWORD_PTR dwContext
)
{
	return voidStub;
}

//BOOLAPI 

//EXTERN_C __declspec(dllexport) BOOL _Success_(return != FALSE) STDAPICALLTYPE
extern "C" /*__declspec(dllimport)*/ BOOL __stdcall
InternetCloseHandle(
	_In_ HINTERNET hInternet
)
{
	return FALSE;
}

EXTERN_C __declspec(dllexport) BOOL _Success_(return != FALSE) STDAPICALLTYPE
HttpSendRequestW(
	_In_ HINTERNET hRequest,
	_In_reads_opt_(dwHeadersLength) LPCWSTR lpszHeaders,
	_In_ DWORD dwHeadersLength,
	_In_reads_bytes_opt_(dwOptionalLength) LPVOID lpOptional,
	_In_ DWORD dwOptionalLength
)
{
	return FALSE;
}

EXTERN_C __declspec(dllexport) BOOL _Success_(return != FALSE) STDAPICALLTYPE
HttpQueryInfoW(
	_In_ HINTERNET hRequest,
	_In_ DWORD dwInfoLevel,
	_Inout_updates_bytes_to_opt_(*lpdwBufferLength, *lpdwBufferLength) __out_data_source(NETWORK) LPVOID lpBuffer,
	_Inout_ LPDWORD lpdwBufferLength,
	_Inout_opt_ LPDWORD lpdwIndex
)
{
	*reinterpret_cast<DWORD*>(lpBuffer) = 200;

	return FALSE;
}
