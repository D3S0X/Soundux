#pragma once
#include <map>
#include "../config/config.h"

namespace Soundux
{
    namespace Hooks
    {
        namespace internal
        {
            inline std::map<int, bool> pressedKeys;

            inline void onKeyEvent(int key, bool down)
            {
                pressedKeys[key] = down;

                if (down)
                {
                    for (auto &hk : Config::gConfig.tabs[Config::gConfig.currentTab].songs)
                    {
                        bool allPresed = true;
                        for (auto &key : hk.hotKeys)
                        {
                            if (!pressedKeys[key])
                                allPresed = false;
                        }
                        if (allPresed)
                        {
                            // TODO: Play sound
                            break;
                        }
                    }
                }
            }
        } // namespace internal
    }     // namespace Hooks
} // namespace Soundux