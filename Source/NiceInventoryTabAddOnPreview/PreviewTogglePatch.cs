using System;
using UnityEngine;
using Verse;

namespace NiceInventoryTabAddOnPreview
{
    internal static class PreviewTogglePatch
    {
        private const float ButtonStep = 54f;
        private const float ButtonWidth = 46f;
        private static bool drawFailureLogged;

        private static readonly Texture2D CheckedTexture =
            ContentFinder<Texture2D>.Get("NiceInventoryTab/Checkbox_Checked", false);

        private static readonly Texture2D EmptyTexture =
            ContentFinder<Texture2D>.Get("NiceInventoryTab/Checkbox_Empty", false);

        private static readonly Texture2D PortraitTexture =
            ContentFinder<Texture2D>.Get("NiceInventoryTab/Portrait", false);

        internal static void Postfix(Rect rectButtons, int indent)
        {
            try
            {
                DrawToggle(rectButtons, indent);
            }
            catch (Exception exception)
            {
                if (drawFailureLogged)
                {
                    return;
                }

                drawFailureLogged = true;
                Log.Error($"[Nice Inventory Tab Add-on: Preview] Could not draw the preview toggle: {exception}");
            }
        }

        private static void DrawToggle(Rect rectButtons, int indent)
        {
            Rect buttonRect = new Rect(
                rectButtons.xMax - ButtonStep * (indent + 1),
                rectButtons.y,
                ButtonWidth,
                rectButtons.height);

            Rect checkboxRect = new Rect(
                buttonRect.x,
                buttonRect.y,
                buttonRect.height,
                buttonRect.height);

            Rect iconRect = new Rect(
                buttonRect.xMax - buttonRect.height,
                buttonRect.y,
                buttonRect.height,
                buttonRect.height);

            Texture2D checkboxTexture = PreviewState.IsVisible
                ? CheckedTexture
                : EmptyTexture;

            if (checkboxTexture != null)
            {
                GUI.DrawTexture(checkboxRect, checkboxTexture);
            }

            if (PortraitTexture != null)
            {
                Widgets.DrawTextureFitted(iconRect.ContractedBy(-2f), PortraitTexture, 0.9f);
            }
            else
            {
                Text.Anchor = TextAnchor.MiddleCenter;
                Widgets.Label(iconRect, "P");
                Text.Anchor = TextAnchor.UpperLeft;
            }

            if (Widgets.ButtonInvisible(buttonRect))
            {
                PreviewState.ToggleVisibility();
            }

            TooltipHandler.TipRegion(buttonRect, "NITAP_PreviewToggle".Translate());
        }
    }
}
