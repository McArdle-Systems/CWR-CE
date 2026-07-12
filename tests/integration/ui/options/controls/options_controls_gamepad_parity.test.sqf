// Gamepad parity on the Controls index + reset-confirm modal:
//   - D-pad navigation should drive the same flat-menu focus cycle as arrows
//   - A should activate the focused row like Enter
//   - B should resolve the modal through the same cancel path as Esc

#include "../../../helpers/options_preamble.sqf"
#include "../../../helpers/controls_preamble.sqf"

triAssert [(triGetControlFocused 1401)]   // Keyboard & Mouse default

triGpadLeft [0, 1]      // Left stick is editor-only, not main/options navigation
triWaitFrames 5
triGpadLeft [0, 0]
triAssert [(triGetControlFocused 1401)]

triGpadPov 4            // Down -> Mouse
triWaitFrames 5
triScreenshot "00_after_first_gamepad_down"

triGpadPov 4            // Down -> Gamepad
triWaitFrames 5
triAssert [(triGetControlFocused 1405)]

triGpadButton 0         // A -> open Gamepad page
triWaitFrames 5
triScreenshot "01_gamepad_bindings_via_gamepad"

triGpadButton 1         // B -> back to Controls
triWaitFrames 5
triAssert [(triGetControlFocused 1405)]   // focus restore on parent page

triGpadPov 4            // Down -> Gamepad Tuning
triWaitFrames 5
triAssert [(triGetControlFocused 1406)]

// Touch Controls is available on every platform whose mounted resource bundle
// contains the row.  Some external game-data bundles can predate the engine's
// touch UI; WrapFocus skips their missing row and lands directly on Reset All.
private _hasTouchControls = (triAssert [(triGetControlVisible 1407)]) == "OK";
triGpadPov 4            // Down -> Touch Controls, or Reset All when absent
triWaitFrames 5
if (_hasTouchControls) then {
    triAssert [(triGetControlFocused 1407)];
    triGpadPov 4;       // Down -> Reset all to defaults
};

triWaitFrames 5
triAssert [(triGetControlFocused 1403)]

triGpadButton 0         // A -> open confirm modal
triWaitFrames 5
triAssert [(triGetControlFocused 9102)]   // Cancel default
triAssertIncludes [(triVisibleTexts), "Reset all to defaults"]
triAssertIncludes [(triVisibleTexts), "Cancel"]

triGpadPov 6            // Left -> Reset
triWaitFrames 5
triAssert [(triGetControlFocused 9101)]

triGpadPov 2            // Right -> Cancel
triWaitFrames 5
triAssert [(triGetControlFocused 9102)]
triScreenshot "02_reset_confirm_via_gamepad"

triGpadButton 1         // B -> cancel modal
triWaitFrames 5
triAssert [(triGetControlFocused 1403)]
triAssertIncludes [(triVisibleTexts), "Reset all to defaults"]
triScreenshot "03_back_at_controls_after_gamepad_cancel"

triEndTest
