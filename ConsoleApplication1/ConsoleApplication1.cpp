// ConsoleApplication1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <windows.h>
#include <Wininet.h>

#include <iostream>

#pragma comment(lib, "Wininet.lib")

int main()
{
	HINTERNET hSession = InternetOpen(L"Project64", INTERNET_OPEN_TYPE_PRECONFIG, nullptr, nullptr, 0);

    std::cout << "Hello World!\n";
}
