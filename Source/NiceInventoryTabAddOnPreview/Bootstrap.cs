using System;
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
            Harmony harmony = new Harmony(HarmonyId);
            harmony.PatchAll();

            Type gearPatchType = AccessTools.TypeByName(NiceInventoryTabGearPatchTypeName);
            if (gearPatchType == null)
            {
                Log.Error("[Nice Inventory Tab Add-on: Preview] Nice Inventory Tab compatibility type was not found. The add-on will remain inactive.");
                return;
            }

            Log.Message("[Nice Inventory Tab Add-on: Preview] Compatibility bootstrap initialized.");
        }
    }
}
