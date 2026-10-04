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
        private const float ZoomButtonSize = 38f;
        private const float ZoomButtonGap = 12f;
        private const float RotationButtonSize = 38f;
        private const float RotationButtonGap = 12f;

        private static readonly Vector3 PortraitCameraOffset = new Vector3(0f, 0f, 0.3f);

        private static Texture2D headgearIcon;
        private static Texture2D apparelIcon;

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

        internal static void Postfix(ITab_Pawn_Gear __0, ref Vector2 __1, bool __result)
        {
            if (__0 == null)
            {
                return;
            }

            try
            {
                // Nice Inventory Tab's Harmony prefix returns true when it wants
                // RimWorld's vanilla ITab_Pawn_Gear.FillTab to run. In that mode
                // the add-on must not reserve width or draw its custom preview.
                if (__result)
                {
                    ClearTrackedExtension();
                    return;
                }

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
            if (panelHeight <= ControlsHeight * 2f + InnerMargin * 2f + SectionGap * 2f)
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
            Rect zoomControlsRect = new Rect(
                innerRect.x,
                innerRect.y,
                innerRect.width,
                ControlsHeight);

            Rect controlsRect = new Rect(
                innerRect.x,
                innerRect.yMax - ControlsHeight,
                innerRect.width,
                ControlsHeight);

            Rect portraitRect = new Rect(
                innerRect.x,
                zoomControlsRect.yMax + SectionGap,
                innerRect.width,
                controlsRect.y - zoomControlsRect.yMax - SectionGap * 2f);

            Pawn pawn = GetSelectedPawn();
            DrawZoomControls(zoomControlsRect);
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
                    PreviewState.Rotation,
                    cameraOffset: PortraitCameraOffset,
                    cameraZoom: PreviewState.CameraZoom,
                    renderHeadgear: PreviewState.ShowHeadgear,
                    renderClothes: PreviewState.ShowApparel);

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

        private static void DrawZoomControls(Rect rect)
        {
            float totalWidth = ZoomButtonSize * 4f + ZoomButtonGap * 3f;
            float firstButtonX = rect.x + (rect.width - totalWidth) / 2f;
            float buttonY = rect.y + (rect.height - ZoomButtonSize) / 2f;

            Rect zoomOutButton = new Rect(
                firstButtonX,
                buttonY,
                ZoomButtonSize,
                ZoomButtonSize);

            Rect zoomInButton = new Rect(
                zoomOutButton.xMax + ZoomButtonGap,
                buttonY,
                ZoomButtonSize,
                ZoomButtonSize);

            Rect headgearButton = new Rect(
                zoomInButton.xMax + ZoomButtonGap,
                buttonY,
                ZoomButtonSize,
                ZoomButtonSize);

            Rect apparelButton = new Rect(
                headgearButton.xMax + ZoomButtonGap,
                buttonY,
                ZoomButtonSize,
                ZoomButtonSize);

            if (DrawImageButton(zoomOutButton, TexButton.Minus, "-"))
            {
                PreviewState.ZoomOut();
            }

            if (DrawImageButton(zoomInButton, TexButton.Plus, "+"))
            {
                PreviewState.ZoomIn();
            }

            DrawHeadgearControl(headgearButton);
            DrawApparelControl(apparelButton);

            TooltipHandler.TipRegion(
                zoomOutButton,
                "NITAP_ZoomOut".Translate());

            TooltipHandler.TipRegion(
                zoomInButton,
                "NITAP_ZoomIn".Translate());
        }

        private static void DrawHeadgearControl(Rect rect)
        {
            // Resolve the Core helmet icon after Defs are available, during UI drawing.
            if (headgearIcon == null)
            {
                headgearIcon = DefDatabase<ThingDef>.GetNamedSilentFail("Apparel_SimpleHelmet")?.uiIcon;
            }

            if (PreviewState.ShowHeadgear)
            {
                Widgets.DrawHighlight(rect);
            }

            if (DrawImageButton(rect, headgearIcon, "NITAP_HeadgearLabel".Translate().ToString()))
            {
                PreviewState.ToggleHeadgear();
            }

            TooltipHandler.TipRegion(rect,
                (PreviewState.ShowHeadgear ? "NITAP_HideHeadgear" : PreviewState.ShowApparel ? "NITAP_ShowHeadgear" : "NITAP_ShowAllApparel").Translate());
        }

        private static void DrawApparelControl(Rect rect)
        {
            // Resolve the Core shirt icon only once Defs are available.
            if (apparelIcon == null)
            {
                apparelIcon = DefDatabase<ThingDef>.GetNamedSilentFail("Apparel_BasicShirt")?.uiIcon;
            }

            if (PreviewState.ShowApparel)
            {
                Widgets.DrawHighlight(rect);
            }

            if (DrawImageButton(rect, apparelIcon, "NITAP_ApparelLabel".Translate().ToString()))
            {
                PreviewState.ToggleApparel();
            }

            TooltipHandler.TipRegion(rect,
                (PreviewState.ShowApparel ? "NITAP_HideApparel" : "NITAP_ShowApparel").Translate());
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

        private static bool DrawImageButton(Rect rect, Texture2D texture, string fallbackLabel)
        {
            if (texture != null)
            {
                return Widgets.ButtonImage(rect, texture);
            }

            return Widgets.ButtonText(rect, fallbackLabel);
        }

        private static bool DrawRotationButton(Rect rect, Texture2D texture, string fallbackLabel)
        {
            return DrawImageButton(rect, texture, fallbackLabel);
        }
    }
}
