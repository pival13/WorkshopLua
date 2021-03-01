extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}

// Pour compiler: g++ basics.cpp -llua -ldl

int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    
    // Equivalent to:
    //    t = { x = "Toto" }
    lua_newtable(L);
    lua_pushstring(L, "Toto");
    lua_setfield(L, -2, "x");
    lua_setglobal(L, "t");

    // Equivalent to the following lua code
    //     print("Hello", t.x, 42)
    lua_getglobal(L, "print");
    lua_pushstring(L, "Hello");
    lua_getglobal(L, "t");
    lua_getfield(L, -1, "x");
    lua_remove(L, -2);
    lua_pushinteger(L, 42);
    lua_call(L, 3, 0);

    lua_close(L);
}