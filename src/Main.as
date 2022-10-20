void Main() {}

void RenderMenu() {
    if (UI::MenuItem(
            "\\$b33" + Icons::Kenney::SoundOff + "\\$z " + Meta::ExecutingPlugin().Name,
            Setting_EnableShortcut ? tostring(Setting_ShortcutKey) : "",
            IsMutedWhenUnfocused)
        ) {
        ToggleMuteWhenUnfocused();
    }
}

[Setting name="Enable Shortcut"]
bool Setting_EnableShortcut = true;

[Setting name="Shortcut Key"]
VirtualKey Setting_ShortcutKey = VirtualKey::F6;

/** Called whenever a key is pressed on the keyboard. See the documentation for the [`VirtualKey` enum](https://openplanet.dev/docs/api/global/VirtualKey).
*/
UI::InputBlocking OnKeyPress(bool down, VirtualKey key) {
    if (Setting_EnableShortcut && down && key == Setting_ShortcutKey) {
        ToggleMuteWhenUnfocused();
    }
    return UI::InputBlocking::DoNothing;
}

CGameManiaPlanetScriptAPI@ _mpApi;
CGameManiaPlanetScriptAPI@ mpApi {
    get {
        if (_mpApi is null) {
            auto app = cast<CGameManiaPlanet>(GetApp());
            @_mpApi = app.ManiaPlanetScriptAPI;
        }
        return _mpApi;
    }
}

bool IsMutedWhenUnfocused {
    get {
        return mpApi.AudioSettings_MuteWhenAppUnfocused;
    }
    set {
        mpApi.AudioSettings_MuteWhenAppUnfocused = value;
    }
}

void ToggleMuteWhenUnfocused() {
    auto new = !mpApi.AudioSettings_MuteWhenAppUnfocused;
    mpApi.AudioSettings_MuteWhenAppUnfocused = new;
    NotifyToggle(new);
}

void NotifyToggle(bool newValue) {
    UI::ShowNotification(Meta::ExecutingPlugin().Name, "Set 'Mute the game when not focused' to " + (newValue ? "True " + Icons::Check : "False" + Icons::Times));
}
