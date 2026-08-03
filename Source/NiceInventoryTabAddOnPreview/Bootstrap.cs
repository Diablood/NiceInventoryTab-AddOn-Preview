using HarmonyLib;
using Verse;

namespace NiceInventoryTabAddOnPreview
{
    [StaticConstructorOnStartup]
    internal static class Bootstrap
    {
        internal const string HarmonyId = "diablood.niceinventorytab.addon.preview";
        internal const string NiceInventoryTabGearPatchTypeName = "NiceInventoryTab.ITab_Pawn_Gear_Patch";

        static Bootstrap()
        {
            if (!CompatibilityTargets.TryValidate(out string failureReason))
            {
                Log.Error($"[Nice Inventory Tab Add-on: Preview] {failureReason} The add-on will remain inactive.");
                return;
            }

            Harmony harmony = new Harmony(HarmonyId);

            harmony.Patch(
                CompatibilityTargets.AddonCheckBoxes,
                postfix: new HarmonyMethod(typeof(PreviewTogglePatch), nameof(PreviewTogglePatch.Postfix)));

            harmony.Patch(
                CompatibilityTargets.FillTabPrefix,
                prefix: new HarmonyMethod(typeof(PreviewPanelPatch), nameof(PreviewPanelPatch.Prefix)),
                postfix: new HarmonyMethod(typeof(PreviewPanelPatch), nameof(PreviewPanelPatch.Postfix)));

            Log.Message("[Nice Inventory Tab Add-on: Preview] Compatibility bootstrap initialized.");
            Log.Message("[Nice Inventory Tab Add-on: Preview] Integrated preview attached to Nice Inventory Tab.");
        }
    }
}
