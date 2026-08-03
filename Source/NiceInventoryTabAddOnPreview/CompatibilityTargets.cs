using System;
using System.Reflection;
using HarmonyLib;
using RimWorld;
using UnityEngine;

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

        internal static bool TryValidate(out string failureReason)
        {
            Type gearPatchType = GearPatchType;
            if (gearPatchType == null)
            {
                failureReason = $"Type '{Bootstrap.NiceInventoryTabGearPatchTypeName}' was not found.";
                return false;
            }

            MethodInfo prefix = FillTabPrefix;
            if (!MatchesPrefixSignature(prefix))
            {
                failureReason = "Nice Inventory Tab's Prefix signature is no longer compatible.";
                return false;
            }

            MethodInfo addonCheckBoxes = AddonCheckBoxes;
            if (!MatchesAddonCheckBoxesSignature(addonCheckBoxes))
            {
                failureReason = "Nice Inventory Tab's AddonCheckBoxes signature is no longer compatible.";
                return false;
            }

            failureReason = null;
            return true;
        }

        private static bool MatchesPrefixSignature(MethodInfo method)
        {
            if (method == null || !method.IsStatic || method.ReturnType != typeof(bool))
            {
                return false;
            }

            ParameterInfo[] parameters = method.GetParameters();
            return parameters.Length == 2
                && parameters[0].ParameterType == typeof(ITab_Pawn_Gear)
                && parameters[1].ParameterType == typeof(Vector2).MakeByRefType();
        }

        private static bool MatchesAddonCheckBoxesSignature(MethodInfo method)
        {
            if (method == null || !method.IsStatic || method.ReturnType != typeof(void))
            {
                return false;
            }

            ParameterInfo[] parameters = method.GetParameters();
            return parameters.Length == 2
                && parameters[0].ParameterType == typeof(Rect)
                && parameters[1].ParameterType == typeof(int);
        }
    }
}
