using Verse;

namespace NiceInventoryTabAddOnPreview
{
    internal static class PreviewState
    {
        private static Rot4 rotation = Rot4.South;

        internal static Rot4 Rotation => rotation;

        internal static void RotateClockwise()
        {
            rotation = rotation.Rotated(RotationDirection.Clockwise);
        }

        internal static void RotateCounterclockwise()
        {
            rotation = rotation.Rotated(RotationDirection.Counterclockwise);
        }
    }
}
