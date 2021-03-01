/*
 * Command to run:
 *    g++ main.cpp -llua -ldl --std=c++17
 */

extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}

#include <iostream>
#include <exception>
#include <filesystem>

extern "C" int LUA_ls(lua_State *L)
{
    std::string path;
    if (lua_gettop(L) == 0)
        path = ".";
    else
        path = luaL_checkstring(L, 1);
    
    if (!std::filesystem::exists(path) || !std::filesystem::is_directory(path)) {
        lua_pushstring(L, ("The given path \""+path+"\" does not exist or is not a directory.").c_str());
        lua_error(L);
    }
    
    std::filesystem::path _path = std::filesystem::absolute(path);
    
    std::cout << path << ":" << std::endl;
    for (const auto &entry : std::filesystem::directory_iterator(_path))
        std::cout << "  " << entry.path().filename().string() << std::endl;
    return 0;
}

void execFileLua(lua_State *L, const std::string &file)
{
    int error = luaL_dofile(L, file.c_str());
    if (error) {
        std::string s = lua_tostring(L, -1);
        lua_pop(L, 1);
        throw std::invalid_argument(s);
    }
}

int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    lua_register(L, "myLs", LUA_ls);

    try {
        execFileLua(L, "myLs.lua");
        lua_getglobal(L, "luafunction");
        lua_pushstring(L, "test");
        if (lua_pcall(L, 1, 0, 0) != LUA_OK) {
            std::string e = lua_tostring(L, -1);
            throw std::runtime_error(e);
        }
    } catch (const std::exception &e) {
        std::cerr << e.what() << std::endl;
    }

    lua_close(L);
}