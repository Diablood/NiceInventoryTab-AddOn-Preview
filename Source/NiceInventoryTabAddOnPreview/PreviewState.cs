using UnityEngine;
using Verse;

namespace NiceInventoryTabAddOnPreview
{
    internal static class PreviewState
    {
        private const float MinCameraZoom = 0.25f;
        private const float MaxCameraZoom = 2f;
        private const float CameraZoomStep = 0.1f;

        private static bool isVisible = true;
        private static bool showHeadgear = true;
        private static Rot4 rotation = Rot4.South;
        private static float cameraZoom = 1f;

        internal static bool IsVisible => isVisible;

        internal static bool ShowHeadgear => showHeadgear;

        internal static void ToggleHeadgear()
        {
            showHeadgear = !showHeadgear;
        }

        internal static Rot4 Rotation => rotation;

        internal static float CameraZoom => cameraZoom;

        internal static void ToggleVisibility()
        {
            isVisible = !isVisible;
        }

        internal static void RotateClockwise()
        {
            rotation = rotation.Rotated(RotationDirection.Clockwise);
        }

        internal static void RotateCounterclockwise()
        {
            rotation = rotation.Rotated(RotationDirection.Counterclockwise);
        }

        internal static void ZoomIn()
        {
            cameraZoom = Mathf.Min(MaxCameraZoom, cameraZoom + CameraZoomStep);
        }

        internal static void ZoomOut()
        {
            cameraZoom = Mathf.Max(MinCameraZoom, cameraZoom - CameraZoomStep);
        }
    }
}
