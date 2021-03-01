#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <dirent.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>

int LUA_ls(lua_State *L)
{
    DIR *dir;
    struct dirent *entry;
    const char *path = luaL_checkstring(L, 1);

    dir = opendir(path);
    if (dir == NULL) {
        lua_pushstring(L, strerror(errno));
        lua_error(L);
    }

    lua_newtable(L);
    int i = 1;
    while ((entry = readdir(dir)) != NULL) {
        lua_pushnumber(L, i++);
        lua_pushstring(L, entry->d_name);
        lua_settable(L, -3);
    }

    closedir(dir);
    return 1;
}

static const luaL_Reg list[] = {
    {"ls", LUA_ls},
    {NULL, NULL}
};

int luaopen_test(lua_State *L)
{
    luaL_newlib(L, list);
    return 1;
}
