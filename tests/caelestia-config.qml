import QtQuick
import Quickshell
import Caelestia.Config

Scope {
    id: root
    property bool failed: false
    Connections {
        target: GlobalConfig
        // The pinned Nix plugin and the live Arch plugin expose different APIs.
        ignoreUnknownSignals: true
        function onUnknownOption(key: string, screen: string): void {
            console.error("CONFIG_CHECK_FAILED unknown option: " + key);
            root.failed = true;
        }
        function onLoadFailed(error: string, screen: string): void {
            console.error("CONFIG_CHECK_FAILED " + error);
            root.failed = true;
        }
        function onTreeLoadFailed(self, error: string): void {
            console.error("CONFIG_CHECK_FAILED " + error);
            root.failed = true;
        }
    }
    Timer {
        interval: 100
        running: true
        onTriggered: {
            if (typeof GlobalConfig.reload === "function") GlobalConfig.reload();
        }
    }
    Timer {
        interval: 1000
        running: true
        onTriggered: {
            for (const diagnostic of (GlobalConfig.diagnostics ?? [])) {
                console.error("CONFIG_CHECK_FAILED " + JSON.stringify(diagnostic));
                root.failed = true;
            }
            if (!root.failed) console.log("CONFIG_CHECK_PASSED");
            Qt.quit();
        }
    }
}
