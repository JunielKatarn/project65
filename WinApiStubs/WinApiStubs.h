// The following ifdef block is the standard way of creating macros which make exporting
// from a DLL simpler. All files within this DLL are compiled with the WINAPISTUBS_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see
// WINAPISTUBS_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef WINAPISTUBS_EXPORTS
#define WINAPISTUBS_API __declspec(dllexport)
#else
#define WINAPISTUBS_API __declspec(dllimport)
#endif

// This class is exported from the dll
class WINAPISTUBS_API CWinApiStubs {
public:
	CWinApiStubs(void);
	// TODO: add your methods here.
};

extern WINAPISTUBS_API int nWinApiStubs;

WINAPISTUBS_API int fnWinApiStubs(void);
