// ConsoleApplication1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <windows.h>
#include <Wininet.h>

#include <iostream>

//#pragma comment(lib, "Wininet.lib")
//#pragma comment(lib, "StubWinInet.lib")
//#pragma comment(lib, "WinApiStubs.lib")

//namespace {
//
//	char sessionStubChars[1];
//	LPVOID sessionStubVoid = static_cast<LPVOID>(sessionStubChars); //(LPVOID)lpb;
//
//} //namespace
//
//EXTERN_C /*__declspec(dllexport)*/ HINTERNET STDAPICALLTYPE InternetOpenW(
//	_In_opt_ LPCWSTR lpszAgent,
//	_In_ DWORD dwAccessType,
//	_In_opt_ LPCWSTR lpszProxy,
//	_In_opt_ LPCWSTR lpszProxyBypass,
//	_In_ DWORD dwFlags
//)
//{
//	return sessionStubVoid;
//}


int main()
{
	//HINTERNET hSession = InternetOpen(L"Project64", INTERNET_OPEN_TYPE_PRECONFIG, nullptr, nullptr, 0);
	HINTERNET hSession = InternetOpenW(L"Project64", INTERNET_OPEN_TYPE_PRECONFIG, nullptr, nullptr, 0);

    std::cout << "Hello World!\n";
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
