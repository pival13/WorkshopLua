extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}

#include <string>
#include <regex>

/*
    match = double ancre
    search/find
    sub/replace
    findall

 object : {
    prefix  =   string
    suffix  =   string
    pattern =   string
    match   =   string
    submatch=   list string
    span    =   function
 }
*/

void registerMatch(lua_State *L, const std::smatch &m, const std::string &pattern)
{
    lua_createtable(L, 0, 6);
    lua_pushstring(L, pattern.c_str());
    lua_setfield(L, -2, "pattern");
    lua_pushstring(L, m.str().c_str());
    lua_setfield(L, -2, "match");
    lua_pushstring(L, m.prefix().str().c_str());
    lua_setfield(L, -2, "prefix");
    lua_pushstring(L, m.suffix().str().c_str());
    lua_setfield(L, -2, "suffix");

    lua_createtable(L, m.size(), 0);
    for (size_t i = 0; i < m.size(); ++i) {
        lua_pushstring(L, m[i].str().c_str());
        lua_seti(L, -2, i);
    }
    lua_setfield(L, -2, "submatch");

    lua_createtable(L, 0, 1);
    lua_getfield(L, -2, "submatch");
    lua_setfield(L, -2, "__index");
    lua_setmetatable(L, -2);

    lua_createtable(L, m.size(), 0);
    for (size_t i = 0; i < m.size(); ++i) {
        lua_pushinteger(L, m.position(i));
        lua_seti(L, -2, i);
    }
    lua_setfield(L, -2, "pos");
    
    luaL_dostring(L, R"(_ = function (o, i)
        i = i or 0
        if type(i) ~= "number" or i < 0 or i > #o.submatch then
            error("match:span expect a number between 0 and "..tostring(#o.submatch))
        end
        return o.pos[i], o.pos[i] + (i == 0 and #o.match or #o.submatch[i])
    end)");
    lua_getglobal(L, "_");
    lua_pushnil(L);
    lua_setglobal(L, "_");
    lua_setfield(L, -2, "span");
}

extern "C" int LUA_match(lua_State *L)
{
    std::string s, pattern;
    if (lua_gettop(L) != 2) {
        lua_pushstring(L, ("re.match expect exactly 2 arguments, "+std::to_string(lua_gettop(L))+" provided.").c_str());
        lua_error(L);
    }
    pattern = luaL_checkstring(L, 1);
    s = luaL_checkstring(L, 2);

    std::smatch m;
    if (std::regex_match(s, m, std::regex(pattern))) {
        registerMatch(L, m, pattern);
        return 1;
    } else
        return 0;
}

extern "C" int LUA_replace(lua_State *L)
{
    std::string s, pattern, rep;
    if (lua_gettop(L) < 3) {
        lua_pushstring(L, ("re.replace expect at least 3 arguments, "+std::to_string(lua_gettop(L))+" provided.").c_str());
        lua_error(L);
    }
    pattern = luaL_checkstring(L, 1);
    rep = luaL_checkstring(L, 2);
    s = luaL_checkstring(L, 3);

    s = std::regex_replace(s, std::regex(pattern), rep);
    lua_pushstring(L, s.c_str());
    return 1;
}


static const luaL_Reg list[] = {
    {"match", LUA_match},
    {"replace", LUA_replace},
    {NULL, NULL}
};

extern "C" int luaopen_regex(lua_State *L)
{
    luaL_newlib(L, list);
    return 1;
}
