macro(SET_DESKTOP_TARGET)
	# Set default target to build (under win32 its allows console debug)
	if(WIN32)
		option(DEVELOPER_WINCONSOLE "Enable windows console windows for debug" OFF)
		if(DEVELOPER_FEATURES AND DEVELOPER_WINCONSOLE)
			set(DESKTOP_TARGET 
				""
			)
		else(DEVELOPER_FEATURES AND DEVELOPER_WINCONSOLE)
			set(DESKTOP_TARGET 
				WIN32
			)
		endif(DEVELOPER_FEATURES AND DEVELOPER_WINCONSOLE)
	elseif(APPLE)
		set(DESKTOP_TARGET 
			MACOSX_BUNDLE
		)
	endif(WIN32)
endmacro(SET_DESKTOP_TARGET)

macro(DEFINE_DEFAULT_DEFINITIONS)
	add_definitions(
		-DNOMINMAX # do not define min() and max()
		-D_CRT_SECURE_NO_WARNINGS 
		-D_CRT_NONSTDC_NO_WARNINGS 
		-D__STDC_CONSTANT_MACROS
		-DWIN32_LEAN_AND_MEAN # remove obsolete things from windows headers
	)

	add_definitions(
		-DPROJECT_NAME="${PROJECT_NAME}"
		-DPROJECT_FULLNAME="${PROJECT_FULLNAME}" 
		-DPROJECT_DOMAIN="${PROJECT_DOMAIN}" 
		-DPROJECT_COMPANYNAME="${PROJECT_COMPANYNAME}"
	)

	if(DEVELOPER_NEWFEATURE)
		add_definitions(
			-DDEVELOPER_NEWFEATURE
		)
	endif(DEVELOPER_NEWFEATURE)
	
	if(DEVELOPER_FEATURES)
		add_definitions(
			-DDEVELOPER_FEATURES
		)
		if(WIN32)
			set(CMAKE_EXE_LINKER_FLAGS_RELEASE 
				"${CMAKE_EXE_LINKER_FLAGS_RELEASE} /DEBUG"
			)
			set(ADDITIONAL_LIBS 
				imagehlp.lib 
				Psapi.lib
			)
		endif(WIN32)
	endif(DEVELOPER_FEATURES)

	if(DEVELOPER_DISABLE_SETTINGS)
		add_definitions(-DDEVELOPER_DISABLE_SETTINGS)
	endif(DEVELOPER_DISABLE_SETTINGS)

	if(WIN32)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Zi")
	endif(WIN32)

endmacro(DEFINE_DEFAULT_DEFINITIONS)

macro(SETUP_COMPILER_SETTINGS IS_DYNAMIC)
	set(IS_DYNAMIC ${IS_DYNAMIC})

	string(REPLACE ";" " " cmake_cl_release_init_str "${ADDITIONAL_CL_OPTIMIZATION_OPTIONS} /D NDEBUG /EHsc")
	string(REPLACE ";" " " cmake_linker_release_init_str "${ADDITIONAL_LINKER_OPTIMIZATION_OPTIONS}")
		
	if(IS_DYNAMIC)

		set(makeRulesOwerrideContent "

			if(WIN32)

				set(CMAKE_C_FLAGS_DEBUG_INIT 			\"/D_DEBUG /MDd /Zi /Ob0 /Od /RTC1\")
				set(CMAKE_C_FLAGS_MINSIZEREL_INIT     	\"/MD /O1 /Ob1 /D NDEBUG\")
				set(CMAKE_C_FLAGS_RELEASE_INIT       	\"/MD /O2 /Ob2 /D NDEBUG\")
				set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT 	\"/MD /Zi /O2 /Ob1 /D NDEBUG\")

				set(CMAKE_CXX_FLAGS_DEBUG_INIT 			\"/D_DEBUG /MDd /Zi /Ob0 /Od /EHsc /RTC1\")
				set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT     \"/MD /O1 ${cmake_cl_release_init_str}\")
				set(CMAKE_CXX_FLAGS_RELEASE_INIT        \"/MD /O2 ${cmake_cl_release_init_str}\")
				set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT \"/MD /Zi /O2 /Ob1 /D NDEBUG /EHsc\")

				set(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL_INIT		\"${cmake_linker_release_init_str}\")
				set(CMAKE_EXE_LINKER_FLAGS_RELEASE_INIT			\"${cmake_linker_release_init_str}\")
				set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_INIT	\"${cmake_linker_release_init_str}\")

			endif(WIN32)

"		)

		if(WIN32)
			set(CMAKE_CXX_FLAGS_DEBUG "/MDd /D_DEBUG /Zi /Ob0 /Od /RTC1")
			set(CMAKE_CXX_FLAGS_RELEASE "/MD /O2 ${cmake_cl_release_init_str}")
			set(CMAKE_CXX_FLAGS_MINSIZEREL "/MD /O1 ${cmake_cl_release_init_str}")
			set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "/MD /O2 /Zi ${cmake_cl_release_init_str}")
			set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${cmake_linker_release_init_str}")
			set(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "${cmake_linker_release_init_str}")
			set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${cmake_linker_release_init_str}")
		endif(WIN32)

		message("Using setting for DYNAMIC run-time")

	else(IS_DYNAMIC)

		set(makeRulesOwerrideContent "

			if(WIN32)

				set(CMAKE_C_FLAGS_INIT \"/MT\")
				set(CMAKE_CXX_FLAGS_INIT \"/MT /EHsc\")

				set(CMAKE_C_FLAGS_DEBUG_INIT 			\"/D_DEBUG /MTd /Zi /Ob0 /Od /RTC1\")
				set(CMAKE_C_FLAGS_MINSIZEREL_INIT     	\"/MT /O1 /Ob1 /D NDEBUG\")
				set(CMAKE_C_FLAGS_RELEASE_INIT       	\"/MT /O2 /Ob2 /D NDEBUG\")
				set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT 	\"/MT /Zi /O2 /Ob1 /D NDEBUG\")

				set(CMAKE_CXX_FLAGS_DEBUG_INIT 			\"/D_DEBUG /MTd /Zi /Ob0 /Od /EHsc /RTC1\")
				set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT     \"/MT /O1 ${cmake_cl_release_init_str}\")
				set(CMAKE_CXX_FLAGS_RELEASE_INIT        \"/MT /O2 ${cmake_cl_release_init_str}\")
				set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT \"/MT /Zi /O2 /Ob1 /D NDEBUG /EHsc\")

				set(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL_INIT		\"${cmake_linker_release_init_str}\")
				set(CMAKE_EXE_LINKER_FLAGS_RELEASE_INIT			\"${cmake_linker_release_init_str}\")
				set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_INIT	\"${cmake_linker_release_init_str}\")
			endif(WIN32)

"		)

		if(WIN32)
			set(CMAKE_CXX_FLAGS_DEBUG "/MTd /D_DEBUG /Zi /Ob0 /Od /RTC1")
			set(CMAKE_CXX_FLAGS_RELEASE "/MT /O2 ${cmake_cl_release_init_str}")
			set(CMAKE_CXX_FLAGS_MINSIZEREL "/MT /O1 ${cmake_cl_release_init_str}")
			set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "/MT /O2 /Zi ${cmake_cl_release_init_str}")
			set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${cmake_linker_release_init_str}")
			set(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "${cmake_linker_release_init_str}")
			set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${cmake_linker_release_init_str}")
		endif(WIN32)

		message("Using setting for STATIC run-time")

		add_definitions(
			-DQT_STATICPLUGINS
		)
	endif(IS_DYNAMIC)

	file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/makeRulesOwerride.cmake" "${makeRulesOwerrideContent}")
	set(CMAKE_USER_MAKE_RULES_OVERRIDE ${CMAKE_CURRENT_BINARY_DIR}/makeRulesOwerride.cmake)
	
	if(APPLE)
		#set(LIBCXX_DIR	${CMAKE_CURRENT_SOURCE_DIR}/imports/libc++10.7)
		#set(CMAKE_OSX_ARCHITECTURES i386)
		#set(CMAKE_OSX_ARCHITECTURES_DEBUG i368)
		#set(CMAKE_CXX_FLAGS "-arch i386")
		#set(LINK_FLAGS "-arch i386")
		#set(CMAKE_XCODE_ATTRIBUTE_GCC_VERSION "com.apple.compilers.llvm.clang.1_0")
		#set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++11")
		#set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")
		#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++ -nostdinc++ -I${LIBCXX_DIR}/include -g -Wall")
		#set(LINK_FLAGS "${LINK_FLAGS} -L${LIBCXX_DIR}/lib -arch i386")
		
		# Detection target arch automaticly
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++ -g -Wall")
		set(CMAKE_XCODE_ATTRIBUTE_GCC_VERSION "com.apple.compilers.llvm.clang.1_0")
		set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++11")
		set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")
	elseif(UNIX)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall")
	endif()

	if(MSVC)
		set(DEVELOPER_NUM_BUILD_PROCS 3 CACHE STRING "Parameter for /MP option")
		if(${DEVELOPER_NUM_BUILD_PROCS} GREATER 1)
			string(REGEX REPLACE "/MP([0-9]+)" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
			set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP${DEVELOPER_NUM_BUILD_PROCS}")
		endif(${DEVELOPER_NUM_BUILD_PROCS} GREATER 1)
	endif(MSVC)
endmacro(SETUP_COMPILER_SETTINGS IS_DYNAMIC)


macro(INSTALL_RUNTIME_LIBRARIES)
	# Install CRT
	if(WIN32)
		set(CMAKE_INSTALL_SYSTEM_RUNTIME_DESTINATION .)
		if(DEVELOPER_FEATURES)
			set(CMAKE_INSTALL_DEBUG_LIBRARIES ON)
		endif(DEVELOPER_FEATURES)
		set(CMAKE_INSTALL_UCRT_LIBRARIES TRUE)
		include (InstallRequiredSystemLibraries)
	endif(WIN32)

# TODO: add code for other platforms here

endmacro(INSTALL_RUNTIME_LIBRARIES)


macro(INSTALL_DEBUG_INFO_FILE)

if(WIN32)
	#install pbd files
	foreach(buildCfg ${CMAKE_CONFIGURATION_TYPES})
		install(
			FILES ${CMAKE_CURRENT_BINARY_DIR}/${buildCfg}/${PROJECT_NAME}.pdb
			DESTINATION .
			CONFIGURATIONS ${buildCfg})
	endforeach(buildCfg ${CMAKE_CONFIGURATION_TYPES})
endif(WIN32)
# TODO: add code for other platforms here

endmacro(INSTALL_DEBUG_INFO_FILE)


macro(TARGET_BUNDLEFIX TARGET_NAME)
	if(APPLE)
		install(CODE "
					include(BundleUtilities)
					string(REPLACE \"\${CMAKE_SOURCE_DIR}/src/$(CONFIGURATION)\" \"${CMAKE_INSTALL_PREFIX}\" BUNDLE_LIBRARIES_MOVE \"${BUNDLE_LIBRARIES_MOVE}\")

					find_file(MACOSX_BUNDLE_ROOT ${CLIENT_DATA_DIR} \"${CMAKE_INSTALL_PREFIX}/${BINARY_INSTALL_DIR}/\")
					
					set(LIBS_ORIGINAL_DIR \"${QT_LIBRARY_DIR}\"
										\"${QT_PLUGINS_DIR}/imageformats\")
					fixup_bundle(
							\"\${MACOSX_BUNDLE_ROOT}\" 
							\"\${BUNDLE_LIBRARIES_MOVE}\" 
							\"\"
					)
					execute_process(COMMAND \"cp\" \"libc++abi.dylib\" \"libc++.1.dylib\" \"\${MACOSX_BUNDLE_ROOT}/Contents/MacOS/\"
									WORKING_DIRECTORY \"${CMAKE_SOURCE_DIR}/imports/libc++10.6/lib/\"
									OUTPUT_VARIABLE OUTPUT_VAR)
					execute_process(COMMAND \"install_name_tool\" \"-change\" \"/usr/lib/libc++abi.dylib\" \"@executable_path/../MacOS/libc++abi.dylib\" \"\${MACOSX_BUNDLE_ROOT}/Contents/MacOS/libc++.1.dylib\")
					execute_process(COMMAND \"install_name_tool\" \"-change\" \"/usr/lib/libc++.1.dylib\" \"@executable_path/../MacOS/libc++.1.dylib\" \"\${MACOSX_BUNDLE_ROOT}/Contents/MacOS/${PROJECT_NAME}\")
			" 
			COMPONENT Runtime
		)
	endif(APPLE)
endmacro(TARGET_BUNDLEFIX TARGET_NAME)

macro(CREATE_BRANDING_HXX)

file(WRITE	"${CMAKE_CURRENT_BINARY_DIR}/branding.hxx"
"#pragma once
#include <qglobal.h>
#include \"utilities/translation.h\"
namespace
{
	utilities::Tr::Translation PROJECT_FULLNAME_TRANSLATION		=	utilities::Tr::translate(\"AboutDialog\", \"${PROJECT_FULLNAME}\");
	utilities::Tr::Translation PROJECT_COMPANYNAME_TRANSLATION	=	utilities::Tr::translate(\"AboutDialog\", \"${PROJECT_COMPANYNAME}\");
}
"
)

set(FILES_TO_TRANSLATE
	${FILES_TO_TRANSLATE}
	"${CMAKE_CURRENT_BINARY_DIR}/branding.hxx"
)

source_group("main" FILES "${CMAKE_CURRENT_BINARY_DIR}/branding.hxx")


endmacro(CREATE_BRANDING_HXX)