using System;
using RimWorld;
using UnityEngine;
using Verse;

namespace NiceInventoryTabAddOnPreview
{
    internal static class PreviewPanelPatch
    {
        internal const float PanelWidth = 244f;
        internal const float PanelGap = 0f;

        private const float PanelTopInset = 38f;
        private const float PanelRightMargin = 6f;
        private const float PanelBottomMargin = 6f;
        private const float InnerMargin = 8f;
        private const float ControlsHeight = 44f;
        private const float SectionGap = 8f;
        private const float RotationButtonSize = 38f;
        private const float RotationButtonGap = 12f;

        private static bool drawFailureLogged;
        private static bool renderFailureLogged;
        private static bool extensionApplied;
        private static ITab_Pawn_Gear extendedTab;
        private static float previousBaseWidth;
        private static float previousExpandedWidth;

        internal static void Prefix(ITab_Pawn_Gear __0, ref Vector2 __1)
        {
            RestorePreviouslyExpandedWidth(__0, ref __1);
        }

        internal static void Postfix(ITab_Pawn_Gear __0, ref Vector2 __1)
        {
            if (__0 == null)
            {
                return;
            }

            try
            {
                if (!PreviewState.IsVisible)
                {
                    ClearTrackedExtension();
                    return;
                }

                float baseWidth = __1.x;
                float expandedWidth = baseWidth + PanelGap + PanelWidth;

                __1.x = expandedWidth;
                extendedTab = __0;
                previousBaseWidth = baseWidth;
                previousExpandedWidth = expandedWidth;
                extensionApplied = true;

                DrawPanel(baseWidth, __1.y);
            }
            catch (Exception exception)
            {
                if (drawFailureLogged)
                {
                    return;
                }

                drawFailureLogged = true;
                Log.Error($"[Nice Inventory Tab Add-on: Preview] Could not draw the integrated preview panel: {exception}");
            }
        }

        private static void RestorePreviouslyExpandedWidth(ITab_Pawn_Gear tab, ref Vector2 tabSize)
        {
            if (!extensionApplied || !ReferenceEquals(extendedTab, tab))
            {
                return;
            }

            if (Mathf.Approximately(tabSize.x, previousExpandedWidth))
            {
                tabSize.x = previousBaseWidth;
            }

            ClearTrackedExtension();
        }

        private static void ClearTrackedExtension()
        {
            extensionApplied = false;
            extendedTab = null;
            previousBaseWidth = 0f;
            previousExpandedWidth = 0f;
        }

        private static void DrawPanel(float baseWidth, float tabHeight)
        {
            float panelHeight = tabHeight - PanelTopInset - PanelBottomMargin;
            if (panelHeight <= ControlsHeight + InnerMargin * 2f + SectionGap)
            {
                return;
            }

            Rect panelRect = new Rect(
                baseWidth + PanelGap,
                PanelTopInset,
                PanelWidth - PanelRightMargin,
                panelHeight);

            Widgets.DrawWindowBackground(panelRect);

            Rect innerRect = panelRect.ContractedBy(InnerMargin);
            Rect controlsRect = new Rect(
                innerRect.x,
                innerRect.yMax - ControlsHeight,
                innerRect.width,
                ControlsHeight);

            Rect portraitRect = new Rect(
                innerRect.x,
                innerRect.y,
                innerRect.width,
                controlsRect.y - innerRect.y - SectionGap);

            Pawn pawn = GetSelectedPawn();
            DrawPortrait(portraitRect, pawn);
            DrawControls(controlsRect);
        }

        private static Pawn GetSelectedPawn()
        {
            Thing selectedThing = Find.Selector.SingleSelectedThing;
            if (selectedThing is Pawn pawn)
            {
                return pawn;
            }

            if (selectedThing is Corpse corpse)
            {
                return corpse.InnerPawn;
            }

            return null;
        }

        private static void DrawPortrait(Rect rect, Pawn pawn)
        {
            Widgets.DrawMenuSection(rect);
            Rect portraitRect = rect.ContractedBy(InnerMargin);

            if (pawn == null)
            {
                Text.Anchor = TextAnchor.MiddleCenter;
                Widgets.Label(portraitRect, "NITAP_NoPawnSelected".Translate().ToString());
                Text.Anchor = TextAnchor.UpperLeft;
                return;
            }

            try
            {
                RenderTexture portrait = PortraitsCache.Get(
                    pawn,
                    new Vector2(portraitRect.width, portraitRect.height),
                    PreviewState.Rotation);

                if (portrait != null)
                {
                    GUI.DrawTexture(portraitRect, portrait, ScaleMode.ScaleToFit, true);
                }
            }
            catch (Exception exception)
            {
                if (!renderFailureLogged)
                {
                    renderFailureLogged = true;
                    Log.Error($"[Nice Inventory Tab Add-on: Preview] Pawn portrait rendering failed: {exception}");
                }

                Text.Anchor = TextAnchor.MiddleCenter;
                Widgets.Label(portraitRect, "NITAP_RenderUnavailable".Translate().ToString());
                Text.Anchor = TextAnchor.UpperLeft;
            }
        }

        private static void DrawControls(Rect rect)
        {
            float totalWidth = RotationButtonSize * 2f + RotationButtonGap;
            float firstButtonX = rect.x + (rect.width - totalWidth) / 2f;
            float buttonY = rect.y + (rect.height - RotationButtonSize) / 2f;

            Rect rotateLeftButton = new Rect(
                firstButtonX,
                buttonY,
                RotationButtonSize,
                RotationButtonSize);

            Rect rotateRightButton = new Rect(
                rotateLeftButton.xMax + RotationButtonGap,
                buttonY,
                RotationButtonSize,
                RotationButtonSize);

            if (DrawRotationButton(rotateLeftButton, TexUI.ArrowTexLeft, "←"))
            {
                PreviewState.RotateClockwise();
            }

            if (DrawRotationButton(rotateRightButton, TexUI.ArrowTexRight, "→"))
            {
                PreviewState.RotateCounterclockwise();
            }

            TooltipHandler.TipRegion(
                rotateLeftButton,
                "NITAP_RotateClockwise".Translate());

            TooltipHandler.TipRegion(
                rotateRightButton,
                "NITAP_RotateCounterclockwise".Translate());
        }

        private static bool DrawRotationButton(Rect rect, Texture2D texture, string fallbackLabel)
        {
            if (texture != null)
            {
                return Widgets.ButtonImage(rect, texture);
            }

            return Widgets.ButtonText(rect, fallbackLabel);
        }
    }
}
