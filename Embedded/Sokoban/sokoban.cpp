extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}

#include <thread>
#include <string>
#include <vector>
#include <chrono>
#include <iostream>
#include <exception>
#include <algorithm>

void execFileLua(lua_State *L, const std::string &file)
{
    int error = luaL_dofile(L, file.c_str());
    if (error) {
        std::string s = lua_tostring(L, -1);
        lua_pop(L, 1);
        lua_error((s).c_str());
    }
}

bool getBoolLua(lua_State *L, const std::string &name)
{
    lua_getglobal(L, name.c_str());
    if (lua_isnil(L, -1)) {
        lua_pop(L, -1);
        lua_error(("Variable " + name + " does not exist.").c_str());
    } else if (!lua_isboolean(L, -1)) {
        lua_pop(L, -1);
        lua_error(("Variable " + name + " is not a boolean.").c_str());
    }
    bool b = lua_toboolean(L, -1);
    lua_pop(L, -1);
    return b;
}

double getNumberLua(lua_State *L, const std::string &name)
{
    lua_getglobal(L, name.c_str());
    if (lua_isnil(L, -1)) {
        lua_pop(L, -1);
        lua_error(("Variable " + name + " does not exist.").c_str());
    } else if (!lua_isnumber(L, -1)) {
        lua_pop(L, -1);
        lua_error(("Variable " + name + " is not a number.").c_str());
    }
    double b = lua_tonumber(L, -1);
    lua_pop(L, -1);
    return b;
}

std::string getStringLua(lua_State *L, const std::string &name)
{
    lua_getglobal(L, name.c_str());
    if (lua_isnil(L, -1)) {
        lua_pop(L, -1);
        lua_error(("Variable " + name + " does not exist.").c_str());
    } else if (!lua_isstring(L, -1)) {
        lua_pop(L, -1);
        lua_error(("Variable " + name + " is not a string.").c_str());
    }
    std::string b = lua_tostring(L, -1);
    lua_pop(L, -1);
    return b;
}

int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    execFileLua(L, "data.lua");

    try {
        size_t width = getNumberLua(L, "width");
        size_t height = getNumberLua(L, "height");
        std::string mapL = getStringLua(L, "map");

        if (mapL.size() != width * height)
            lua_error(("Incorrect map size. Expecter " + std::to_string(width*height) + ", but got " + std::to_string(mapL.size())).c_str());
        else if (std::any_of(mapL.begin(), mapL.end(), [](char c) { return c != 'P' && c != ' ' && c != 'o' && c != 'X' && c != '#' && c != '@'; }))
            lua_error(("Invalid character in map.").c_str());
        else if (std::count(mapL.begin(), mapL.end(), 'P') != 1)
            lua_error(("Invalid number of player.").c_str());
        else if (std::count(mapL.begin(), mapL.end(), 'o') != std::count(mapL.begin(), mapL.end(), 'X'))
            lua_error(("The number of box doesn't match the number of slots.").c_str());
        
        for (size_t i = 0; i != height; ++i)
            std::cout << mapL.substr(i*width, width) << std::endl;
        while (true) {
            size_t pos = std::find(mapL.begin(), mapL.end(), 'P') - mapL.begin();
            if (std::count(mapL.begin(), mapL.end(), 'X') == 0 || std::cin.eof())
                break;
            
            beginSwitch:
            char c = std::cin.get();
            if (std::cin.eof()) break;
            switch (c) {
            case 'q':
                if (pos % width != 0 && mapL[pos-1] != '#') {
                    if (mapL[pos-1] == 'X') {
                        if (pos % width != 1 && (mapL[pos-2] == ' ' || mapL[pos-2] == 'o'))
                            mapL[pos-2] = mapL[pos-2] == 'o'? '@': 'X';
                        else
                            goto endSwitch;
                    }
                    mapL[pos-1] = 'P';
                    mapL[pos] = ' ';
                }
                break;
            case 'd':
                if (pos % width != width-1 && mapL[pos+1] != '#') {
                    if (mapL[pos+1] == 'X') {
                        if (pos % width != width-2 && (mapL[pos+2] == ' ' || mapL[pos+2] == 'o'))
                            mapL[pos+2] = mapL[pos+2] == 'o'? '@': 'X';
                        else
                            goto endSwitch;
                    }
                    mapL[pos+1] = 'P';
                    mapL[pos] = ' ';
                }
                break;
            case 's':
                if (pos / width != height-1 && mapL[pos+width] != '#') {
                    if (mapL[pos+width] == 'X') {
                        if (pos / width != height-2 && (mapL[pos+width*2] == ' ' || mapL[pos+width*2] == 'o'))
                            mapL[pos+width*2] = mapL[pos+width*2] == 'o'? '@': 'X';
                        else
                            goto endSwitch;
                    }
                    mapL[pos+width] = 'P';
                    mapL[pos] = ' ';
                }
                break;
            case 'z':
                if (pos / width != 0 && mapL[pos-width] != '#') {
                    if (mapL[pos-width] == 'X') {
                        if (pos / width != 1 && (mapL[pos-width*2] == ' ' || mapL[pos-width*2] == 'o'))
                            mapL[pos-width*2] = mapL[pos-width*2] == 'o'? '@': 'X';
                        else
                            goto endSwitch;
                    }
                    mapL[pos-width] = 'P';
                    mapL[pos] = ' ';
                }
                break;
            default:
                endSwitch:
                goto beginSwitch;
                break;
            }
            std::cout << "\33[H\33[2J\33[3J" << std::endl;
            for (size_t i = 0; i != height; ++i)
                std::cout << mapL.substr(i*width, width) << std::endl;
            std::this_thread::sleep_for(std::chrono::milliseconds(200));
        }
        std::cout << "Congratulation!" << std::endl;
    } catch (const std::exception &e) {
        std::cerr << e.what() << std::endl;
    }

    lua_close(L);
}