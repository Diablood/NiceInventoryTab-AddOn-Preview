using System;
using System.Reflection;
using HarmonyLib;

namespace NiceInventoryTabAddOnPreview
{
    internal static class CompatibilityTargets
    {
        internal static Type GearPatchType => AccessTools.TypeByName(Bootstrap.NiceInventoryTabGearPatchTypeName);

        internal static MethodInfo FillTabPrefix => GearPatchType == null
            ? null
            : AccessTools.Method(GearPatchType, "Prefix");

        internal static MethodInfo AddonCheckBoxes => GearPatchType == null
            ? null
            : AccessTools.Method(GearPatchType, "AddonCheckBoxes");
    }
}
